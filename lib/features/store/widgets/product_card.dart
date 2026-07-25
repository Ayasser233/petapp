import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/widgets/auth_network_image.dart';
import 'package:petapp/features/store/models/product_summary_model.dart';

/// Premium product card — matches Wago Store screenshot design.
class ProductCard extends StatelessWidget {
  final ProductSummaryModel product;
  final bool isInCart;
  final bool isFavorite;
  final VoidCallback onAddToCart;
  final VoidCallback? onFavorite;
  final VoidCallback? onTap;
  final double? width;

  const ProductCard({
    super.key,
    required this.product,
    required this.isInCart,
    this.isFavorite = false,
    required this.onAddToCart,
    this.onFavorite,
    this.onTap,
    this.width,
  });

  // ── card background ──────────────────────────────────────────────
  static const _cardBgLight = Color(0xFFFFF5E1); // warm cream
  static const _imageBgLight = Color(0xFFFFF0D6); // slightly deeper cream

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.lightblack : _cardBgLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
        ),
        // Column: [image Stack] + [Expanded content]
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image section ────────────────────────────────────
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: _buildImage(isDark),
                  ),
                ),
                // Heart icon — top right
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavorite,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black54 : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 16,
                        color: isFavorite
                            ? Colors.red
                            : (isDark
                                ? Colors.grey.shade400
                                : Colors.grey.shade500),
                      ),
                    ),
                  ),
                ),
                // Add-to-cart / in-cart button — bottom right of image
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onAddToCart,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isInCart ? Colors.green : AppColors.orange,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.orange.withValues(alpha: 0.45),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        isInCart ? Icons.check_rounded : Icons.add_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Content section ───────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      product.title ?? '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            height: 1.3,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Description
                    if (product.description != null &&
                        product.description!.isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(
                        product.description!,
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                  fontSize: 11,
                                  height: 1.35,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const Spacer(),

                    // Rating  "★ 0.00  (0)"
                    if (product.averageRating != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 14),
                          const SizedBox(width: 3),
                          Text(
                            '${product.averageRating!.toStringAsFixed(2)}  '
                            '(${product.reviewCount ?? 0})',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  color: isDark
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade600,
                                  fontSize: 11,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                    ],

                    // Price  "850 EGP"
                    Text(
                      product.minPrice != null
                          ? '${product.minPrice!.toStringAsFixed(0)} EGP'
                          : '',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                    ),

                    // Vendor
                    if (product.vendor != null &&
                        product.vendor!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        product.vendor!,
                        style:
                            Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: AppColors.orange,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(bool isDark) {
    final bg = isDark ? AppColors.lightblack : _imageBgLight;
    final url = product.imageUrl;
    if (url == null || url.isEmpty) {
      return _placeholder(bg);
    }
    return AuthNetworkImage(
      url: url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
      placeholder: () => Container(
        color: bg,
        child: const Center(
          child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(AppColors.orange)),
        ),
      ),
      errorWidget: () => _placeholder(bg),
    );
  }

  Widget _placeholder(Color bg) => Container(
        color: bg,
        child: const Center(
            child: Icon(Icons.pets, size: 48, color: AppColors.lightorange)),
      );
}