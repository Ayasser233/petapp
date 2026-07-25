import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/features/store/controllers/cart_controller.dart';
import 'package:petapp/features/store/controllers/favorites_controller.dart';
import 'package:petapp/features/store/widgets/product_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);
    final favCtrl = Get.find<FavoritesController>();
    final cartCtrl = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : null;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(localizations.myFavorites,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          final favorites = favCtrl.favorites;
          if (favorites.isEmpty) {
            return _buildEmptyState(context, isDark, localizations);
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.54,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, i) {
              final product = favorites[i];
              return Obx(() => ProductCard(
                    product: product,
                    isInCart: cartCtrl?.isInCart(product.id) ?? false,
                    isFavorite: true,
                    onFavorite: () => favCtrl.toggleFavorite(product),
                    onAddToCart: () =>
                        Get.toNamed(AppRoutes.productDetail, arguments: product.id),
                    onTap: () =>
                        Get.toNamed(AppRoutes.productDetail, arguments: product.id),
                  ));
            },
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState(
      BuildContext context, bool isDark, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border_rounded,
            size: 80,
            color: AppColors.orange.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noFavoriteProducts,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              l10n.favoriteProductsDesc,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.store),
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Browse Store'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange,
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }
}