import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/features/store/models/product_summary_model.dart';

/// Reusable product card — used in StoreScreen grid
class ProductCard extends StatelessWidget {
  final ProductSummaryModel product;
  final bool isInCart;
  final VoidCallback onAddToCart;
  final VoidCallback? onTap;
  final double? width;

  const ProductCard({
    super.key,
    required this.product,
    required this.isInCart,
    required this.onAddToCart,
    this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: isDark ? AppColors.lightblack : AppColors.storeCardBg,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            if (!isDark)
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                  child: _buildImage(),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onAddToCart,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: isInCart ? Colors.green : AppColors.orange,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.orange.withValues(alpha: 0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isInCart ? Icons.check : Icons.add,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (product.vendor != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      product.vendor!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.orange,
                            fontSize: 10,
                          ),
                    ),
                  ],
                  if (product.averageRating != null) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${product.averageRating!.toStringAsFixed(1)}',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.grey.shade600, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 5),
                  Text(
                    product.minPrice != null
                        ? '${product.minPrice!.toStringAsFixed(0)} EGP'
                        : '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (product.imageUrl == null || product.imageUrl!.isEmpty) {
      return Container(
        height: 160,
        color: AppColors.storeCardBg,
        child: const Center(child: Icon(Icons.pets, size: 48, color: AppColors.lightorange)),
      );
    }
    return Image.network(
      product.imageUrl!,
      width: double.infinity,
      height: 160,
      fit: BoxFit.cover,
      loadingBuilder: (ctx, child, progress) {
        if (progress == null) return child;
        return Container(
          height: 160,
          color: AppColors.storeCardBg,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.orange)),
          ),
        );
      },
      errorBuilder: (ctx, _, __) => Container(
        height: 160,
        color: AppColors.storeCardBg,
        child: const Center(child: Icon(Icons.pets, size: 48, color: AppColors.lightorange)),
      ),
    );
  }
}