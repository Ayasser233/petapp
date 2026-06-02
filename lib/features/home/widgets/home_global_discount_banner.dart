import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/app_colors.dart';

/// A compact, animated home-screen banner for the app-wide global discount.
///
/// Pass the raw [discountData] map from the API response:
/// ```json
/// { "title": "50%", "description": "50% off", "type": "percentage",
///   "value": 50, "isActive": true, "usageMode": "until_deactivated" }
/// ```
class HomeGlobalDiscountBanner extends StatefulWidget {
  final Map<String, dynamic> discountData;

  const HomeGlobalDiscountBanner({super.key, required this.discountData});

  @override
  State<HomeGlobalDiscountBanner> createState() =>
      _HomeGlobalDiscountBannerState();
}

class _HomeGlobalDiscountBannerState extends State<HomeGlobalDiscountBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _shimmer;
  late Animation<double> _pulse;

  // dismiss state - removed: banner stays until discount is deactivated from dashboard
  // bool _dismissed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _shimmer = Tween<double>(begin: -2.0, end: 3.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _pulse = Tween<double>(begin: 0.96, end: 1.04).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── helpers ───────────────────────────────────────────────────────────────

  String get _badgeLabel {
    final type = widget.discountData['type']?.toString() ?? 'percentage';
    final value = (widget.discountData['value'] as num?)?.toDouble() ?? 0;
    return type == 'percentage'
        ? '${value.toStringAsFixed(0)}%\nOFF'
        : '${value.toStringAsFixed(0)}\nEGP';
  }

  String get _description =>
      widget.discountData['description']?.toString() ?? 'Exclusive discount';

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => ScaleTransition(
        scale: _pulse,
        child: _buildCard(context),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFD44000), Color(0xFFEA9249), Color(0xFFFFB347)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // ── Background decorations ───────────────────────────
          _bgCircle(size: 130, x: -40, y: -30, opacity: 0.07),
          _bgCircle(size: 80, x: null, y: -20, xRight: 60, opacity: 0.08),
          _bgCircle(size: 50, x: null, y: null, xRight: -10,
              yBottom: -15, opacity: 0.06),

          // ── Shimmer sweep ────────────────────────────────────
          AnimatedBuilder(
            animation: _shimmer,
            builder: (_, __) => Positioned.fill(
              child: ShaderMask(
                shaderCallback: (rect) => LinearGradient(
                  begin: Alignment(_shimmer.value - 0.4, 0),
                  end: Alignment(_shimmer.value + 0.4, 0),
                  colors: [
                    Colors.transparent,
                    Colors.white.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ).createShader(rect),
                blendMode: BlendMode.srcOver,
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
            child: Row(
              children: [
                // Left: pulsing badge circle
                _DiscountBadge(label: _badgeLabel, ctrl: _ctrl),

                const SizedBox(width: 14),

                // Middle: text block
                Expanded(child: _textBlock(context)),

                const SizedBox(width: 8),

                // Right: CTA button
                _ctaButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textBlock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Aleefy exclusive pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.22),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.verified_rounded, color: Colors.white, size: 11),
              SizedBox(width: 4),
              Text(
                'Aleefy Exclusive',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          _description,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'On all vet appointments • Auto-applied',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.82),
            fontSize: 10.5,
          ),
        ),
      ],
    );
  }

  Widget _ctaButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.vetExplorer),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.calendar_month_rounded,
                color: AppColors.orange, size: 20),
            SizedBox(height: 3),
            Text(
              'Book\nNow',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.orange,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Background decorative circle helper
  Widget _bgCircle({
    required double size,
    double? x,
    double? y,
    double? xRight,
    double? yBottom,
    required double opacity,
  }) {
    return Positioned(
      left: x,
      top: y,
      right: xRight,
      bottom: yBottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: opacity),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated badge circle
// ─────────────────────────────────────────────────────────────────────────────

class _DiscountBadge extends StatelessWidget {
  final String label;
  final AnimationController ctrl;

  const _DiscountBadge({required this.label, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final wobble = math.sin(ctrl.value * 2 * math.pi) * 0.03;
        return Transform.rotate(
          angle: wobble,
          child: Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.55),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
          ),
        );
      },
    );
  }
}
