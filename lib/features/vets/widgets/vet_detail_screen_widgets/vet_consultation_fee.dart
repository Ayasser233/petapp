import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'vet_global_discount_banner.dart';

class VetConsultationFee extends StatelessWidget {
  final String price;
  final double? emergencyPrice;
  final bool hasEmergency;
  /// Pass the parsed [GlobalDiscount] to show discounted pricing.
  final GlobalDiscount? globalDiscount;

  const VetConsultationFee({
    super.key,
    required this.price,
    this.emergencyPrice,
    this.hasEmergency = false,
    this.globalDiscount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[700];

    // Extract numeric value from price string (e.g., "75.00 EGP" -> 75)
    final priceValue = price.replaceAll(RegExp(r'[^0-9.]'), '').trim();
    final originalFee = double.tryParse(priceValue) ?? 0;

    // Compute discounted fee when a global discount exists
    final hasGlobalDiscount = globalDiscount != null;
    final discountedFee =
        hasGlobalDiscount ? globalDiscount!.discountedPrice(originalFee) : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.orange.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.orange.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // ── Consultation Fee Row ────────────────────────────────
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context).consultationFee,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context).initialExaminationFee,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: subTextColor,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Price column: shows original (struck-through) + discounted
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (hasGlobalDiscount) ...[
                    // Original price — struck through
                    Text(
                      price,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.grey,
                          ),
                    ),
                    const SizedBox(height: 2),
                    // Discounted price
                    Text(
                      '${discountedFee!.toStringAsFixed(0)} EGP',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: const Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ] else
                    // Normal price — no discount
                    Text(
                      price,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: AppColors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ],
          ),

          // ── "You save X EGP" savings chip ──────────────────────
          if (hasGlobalDiscount) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.savings_rounded,
                      color: Color(0xFF2E7D32), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF2E7D32),
                              fontWeight: FontWeight.w600,
                            ),
                        children: [
                          const TextSpan(text: 'You save '),
                          TextSpan(
                            text:
                                '${(originalFee - discountedFee!).toStringAsFixed(0)} EGP',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                            ),
                          ),
                          const TextSpan(
                              text: ' with Aleefy\'s exclusive discount'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Emergency Fee Row ───────────────────────────────────
          if (hasEmergency && emergencyPrice != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: isDark ? 0.15 : 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.red.withValues(alpha: isDark ? 0.4 : 0.25),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emergency, color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context).emergencyFee,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Text(
                    '${emergencyPrice!.toStringAsFixed(0)} EGP',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),
          // ── Points earning note ─────────────────────────────────
          Row(
            children: [
              const Icon(Icons.stars, color: Colors.green, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: subTextColor,
                          height: 1.3,
                        ),
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context).earnPoints,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        // Points are based on the discounted price when applicable
                        text: hasGlobalDiscount
                            ? discountedFee!.toStringAsFixed(0)
                            : (priceValue.isNotEmpty ? priceValue : '75'),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: AppLocalizations.of(context).pointsAfterCompletion,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
