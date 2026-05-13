import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';

/// Parses the `globalDiscount` map from the vet API response and returns a
/// typed model, or null when the discount is absent / inactive.
class GlobalDiscount {
  final String title;
  final String description;
  final String type; // "percentage" | "fixed"
  final double value;
  final String usageMode;

  const GlobalDiscount({
    required this.title,
    required this.description,
    required this.type,
    required this.value,
    required this.usageMode,
  });

  factory GlobalDiscount.fromMap(Map<String, dynamic> map) => GlobalDiscount(
        title: map['title']?.toString() ?? '',
        description: map['description']?.toString() ?? '',
        type: map['type']?.toString() ?? 'percentage',
        value: (map['value'] as num?)?.toDouble() ?? 0,
        usageMode: map['usageMode']?.toString() ?? 'until_deactivated',
      );

  static GlobalDiscount? tryParse(dynamic raw) {
    if (raw == null) return null;
    if (raw is! Map<String, dynamic>) return null;
    if (raw['isActive'] != true) return null;
    return GlobalDiscount.fromMap(raw);
  }

  /// Compute the discounted price from the original fee.
  double discountedPrice(double original) {
    if (type == 'percentage') {
      return (original * (1 - value / 100)).clamp(0, double.infinity);
    }
    return (original - value).clamp(0, double.infinity);
  }

  /// Human-readable label, e.g. "50% OFF"
  String get badgeLabel =>
      type == 'percentage' ? '${value.toStringAsFixed(0)}% OFF' : '${value.toStringAsFixed(0)} EGP OFF';
}

// ─────────────────────────────────────────────────────────────────────────────
// Banner widget
// ─────────────────────────────────────────────────────────────────────────────

class VetGlobalDiscountBanner extends StatefulWidget {
  final GlobalDiscount discount;

  const VetGlobalDiscountBanner({super.key, required this.discount});

  @override
  State<VetGlobalDiscountBanner> createState() =>
      _VetGlobalDiscountBannerState();
}

class _VetGlobalDiscountBannerState extends State<VetGlobalDiscountBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final d = widget.discount;

    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (context, child) => _buildCard(context, isDark, d),
    );
  }

  Widget _buildCard(BuildContext context, bool isDark, GlobalDiscount d) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B00), Color(0xFFEA9249), Color(0xFFFFB347)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withValues(alpha: 0.45),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Decorative blurred circles ───────────────────────────
          Positioned(
            top: -30,
            right: -20,
            child: _decorCircle(110, Colors.white, 0.08),
          ),
          Positioned(
            bottom: -20,
            left: 80,
            child: _decorCircle(70, Colors.white, 0.07),
          ),
          // ── Shimmer sweep ────────────────────────────────────────
          AnimatedBuilder(
            animation: _shimmerAnim,
            builder: (_, __) => Positioned.fill(
              child: ShaderMask(
                shaderCallback: (rect) => LinearGradient(
                  begin: Alignment(_shimmerAnim.value - 0.3, 0),
                  end: Alignment(_shimmerAnim.value + 0.3, 0),
                  colors: [
                    Colors.transparent,
                    Colors.white.withValues(alpha: 0.15),
                    Colors.transparent,
                  ],
                ).createShader(rect),
                blendMode: BlendMode.srcOver,
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          // ── Content ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left: spinning "%" badge
                _buildBadge(d),
                const SizedBox(width: 14),
                // Right: text block
                Expanded(child: _buildTextBlock(context, d)),
                // Far-right: scissors icon
                const _SnipIcon(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(GlobalDiscount d) {
    return AnimatedBuilder(
      animation: _shimmerCtrl,
      builder: (_, __) {
        final angle = _shimmerCtrl.value * 2 * math.pi * 0.05; // subtle wobble
        return Transform.rotate(
          angle: math.sin(angle) * 0.04,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  d.type == 'percentage'
                      ? '${d.value.toStringAsFixed(0)}%'
                      : '-${d.value.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const Text(
                  'OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextBlock(BuildContext context, GlobalDiscount d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // "Aleefy Exclusive Offer" pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.verified_rounded, color: Colors.white, size: 12),
              SizedBox(width: 4),
              Text(
                'Aleefy Exclusive Offer',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          d.description,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Applied automatically at checkout',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _decorCircle(double size, Color color, double opacity) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// "Snip" / scissors icon — bounces gently
// ─────────────────────────────────────────────────────────────────────────────

class _SnipIcon extends StatefulWidget {
  const _SnipIcon();

  @override
  State<_SnipIcon> createState() => _SnipIconState();
}

class _SnipIconState extends State<_SnipIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.local_offer_rounded,
            color: Colors.white, size: 22),
      ),
    );
  }
}
