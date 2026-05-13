import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

/// Manages in-app review prompts with guard logic:
/// - max [_maxPrompts] total prompts (default 3)
/// - at least [_minDaysBetweenPrompts] days between prompts (default 30)
/// - never again once the user has explicitly rated / opened the store
///
/// Usage:
///   // After a positive milestone (booking, order, etc.) — no context needed:
///   ReviewService.markMeaningfulActionCompleted();
///
///   // Shortly after, from a Widget (with context):
///   ReviewService.maybePromptForReview(context);
///
///   // When the user explicitly taps "Rate the App" (always shown):
///   ReviewService.forceOpenStoreListing(context);
///
///   // In debug builds, reset all state:
///   ReviewService.resetReviewDebugState();
class ReviewService {
  ReviewService._();

  // ── SharedPreferences keys ────────────────────────────────────────────────
  static const _kPromptCount = 'review_prompt_count';
  static const _kLastPromptMs = 'review_last_prompt_ms';
  static const _kHasRated = 'review_has_rated';
  static const _kPendingPrompt = 'review_pending_prompt';

  // ── Guard thresholds ──────────────────────────────────────────────────────
  static const int _maxPrompts = 3;
  static const int _minDaysBetweenPrompts = 30;

  // ── Store URLs ────────────────────────────────────────────────────────────
  static const _androidStoreUrl =
      'https://play.google.com/store/apps/details?id=com.aleefy.petapp';
  static const _iosStoreUrl =
      'https://apps.apple.com/app/id6757188379';

  // ── Public API ────────────────────────────────────────────────────────────

  /// Call this after a meaningful positive action (successful booking, order, etc.).
  /// Sets a pending flag that [maybePromptForReview] will consume.
  /// Safe to call with no BuildContext — from controllers, use cases, etc.
  static Future<void> markMeaningfulActionCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!_shouldPrompt(prefs)) return; // guards already block — don't bother
      await prefs.setBool(_kPendingPrompt, true);
      debugPrint('ReviewService: meaningful action recorded');
    } catch (e) {
      debugPrint('ReviewService.markMeaningfulActionCompleted: $e');
    }
  }

  /// Call this from the UI after a positive milestone.
  /// Shows the native in-app review sheet (or store listing fallback)
  /// **only** when all guards pass AND a pending flag was set by
  /// [markMeaningfulActionCompleted].
  static Future<void> maybePromptForReview(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!_shouldPrompt(prefs)) return;

      final pending = prefs.getBool(_kPendingPrompt) ?? false;
      if (!pending) return;

      // Consume the pending flag before showing to prevent double-prompts
      await prefs.setBool(_kPendingPrompt, false);

      await _doPrompt(context, prefs);
    } catch (e) {
      debugPrint('ReviewService.maybePromptForReview: $e');
    }
  }

  /// Call this when the user explicitly taps "Rate the App".
  /// Bypasses the guards — always shows the native dialog or store listing.
  /// Marks the user as having rated so they are not prompted again automatically.
  static Future<void> forceOpenStoreListing(BuildContext context) async {
    final inAppReview = InAppReview.instance;
    try {
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      } else {
        await _openStoreUrl(context);
      }
      // Mark as rated so automatic prompts stop
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kHasRated, true);
    } catch (e) {
      debugPrint('ReviewService.forceOpenStoreListing: $e');
      await _openStoreUrl(context);
    }
  }

  /// Resets all persisted review state. Use only in debug / QA builds.
  static Future<void> resetReviewDebugState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kPromptCount);
    await prefs.remove(_kLastPromptMs);
    await prefs.remove(_kHasRated);
    await prefs.remove(_kPendingPrompt);
    debugPrint('ReviewService: state reset — all guards cleared');
  }

  // ── Internal helpers ──────────────────────────────────────────────────────

  /// Returns true if all guards pass (user CAN be prompted).
  static bool _shouldPrompt(SharedPreferences prefs) {
    // Never if user explicitly rated
    if (prefs.getBool(_kHasRated) ?? false) return false;

    // Never if max prompts reached
    final count = prefs.getInt(_kPromptCount) ?? 0;
    if (count >= _maxPrompts) return false;

    // Never if within the cooldown period since the last prompt
    final lastMs = prefs.getInt(_kLastPromptMs);
    if (lastMs != null) {
      final daysSince = DateTime.now()
          .difference(DateTime.fromMillisecondsSinceEpoch(lastMs))
          .inDays;
      if (daysSince < _minDaysBetweenPrompts) return false;
    }

    return true;
  }

  static Future<void> _doPrompt(
      BuildContext context, SharedPreferences prefs) async {
    final inAppReview = InAppReview.instance;
    try {
      if (await inAppReview.isAvailable()) {
        // Native sheet — OS decides what to actually show; no custom dialog needed
        await inAppReview.requestReview();
      } else {
        // Fallback: open the store listing so the user can leave a manual review
        await _openStoreUrl(context);
        // Opening the store counts as a "rated" interaction — stop prompting
        await prefs.setBool(_kHasRated, true);
      }

      // Update counters
      final newCount = (prefs.getInt(_kPromptCount) ?? 0) + 1;
      await prefs.setInt(_kPromptCount, newCount);
      await prefs.setInt(
          _kLastPromptMs, DateTime.now().millisecondsSinceEpoch);

      // After the last allowed prompt, mark as done
      if (newCount >= _maxPrompts) {
        await prefs.setBool(_kHasRated, true);
      }

      debugPrint(
          'ReviewService: prompt shown (count: $newCount / $_maxPrompts)');
    } catch (e) {
      debugPrint('ReviewService._doPrompt: $e');
    }
  }

  static Future<void> _openStoreUrl(BuildContext context) async {
    final uri = Uri.parse(Platform.isIOS ? _iosStoreUrl : _androidStoreUrl);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unable to open the store right now.'),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }
}
