import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class RewardsCard extends StatelessWidget {
  final int points;
  final int vouchers; // This now represents only available vouchers
  final VoidCallback? onRedeemTap;
  final VoidCallback? onVouchersTap;
  final VoidCallback? onViewHistoryTap;
  final bool showTitle;
  final bool showViewHistory;

  const RewardsCard({
    super.key,
    required this.points,
    required this.vouchers, // Available vouchers count only
    this.onRedeemTap,
    this.onVouchersTap,
    this.onViewHistoryTap,
    this.showTitle = true,
    this.showViewHistory = true,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      children: [
        // Title section
        if (showTitle) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localizations.redeemAndSave,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (showViewHistory)
                TextButton(
                  onPressed: onViewHistoryTap,
                  child: Text(
                    localizations.viewHistory,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.orange,
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Rewards card
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.orange, Color(0xFFF5A623)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.orange.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Points section
              Expanded(
                child: _buildPointsSection(context, localizations),
              ),
              Container(
                height: 100,
                width: 1,
                color: Colors.white.withValues(alpha: 0.3),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),
              // Vouchers section (only available vouchers)
              _buildVouchersSection(context, localizations),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPointsSection(BuildContext context, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.stars_rounded,
                color: AppColors.orange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatPoints(points),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  localizations.pointsAvailable,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: onRedeemTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
          ),
          child: Text(
            localizations.redeemNow,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.orange,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildVouchersSection(BuildContext context, AppLocalizations localizations) {
    return GestureDetector(
      onTap: onVouchersTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: vouchers > 0 ? Colors.white : Colors.white.withValues(alpha: 0.7),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                Icon(
                  Icons.confirmation_number_outlined,
                  color: vouchers > 0 ? AppColors.orange : AppColors.orange.withValues(alpha: 0.5),
                  size: 24,
                ),
                if (vouchers > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        vouchers > 9 ? '9+' : vouchers.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            vouchers.toString(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            'Available', // Changed from 'vouchers' to be more specific
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
          ),
          if (vouchers > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Tap to view',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                    ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatPoints(int points) {
    if (points >= 1000000) {
      return '${(points / 1000000).toStringAsFixed(1)}M';
    } else if (points >= 1000) {
      return '${(points / 1000).toStringAsFixed(1)}K';
    }
    return points.toString();
  }
}