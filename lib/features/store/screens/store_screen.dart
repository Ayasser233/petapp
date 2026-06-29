import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/features/store/controllers/cart_controller.dart';
import 'package:petapp/features/store/controllers/store_controller.dart';
import 'package:petapp/features/store/widgets/category_chip.dart';
import 'package:petapp/features/store/widgets/product_card.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StoreController storeCtrl = Get.find<StoreController>();
    final CartController cartCtrl = Get.find<CartController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(l10n.aleefyStore,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        actions: [
          Obx(() => Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined, size: 22),
                    onPressed: () => Get.toNamed(AppRoutes.cart),
                  ),
                  if (cartCtrl.itemCount > 0)
                    Positioned(
                      top: 6, right: 6,
                      child: Container(
                        width: 16, height: 16,
                        decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
                        child: Center(
                          child: Text('${cartCtrl.itemCount}',
                              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                ],
              )),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.lightblack : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Icon(Icons.search_rounded, color: Colors.grey.shade500, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: storeCtrl.setSearch,
                      decoration: InputDecoration(
                        hintText: l10n.search,
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.tune_rounded, color: Colors.grey.shade600, size: 20),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Categories
          Obx(() => SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: storeCtrl.categories.length,
                  itemBuilder: (context, i) {
                    final cat = storeCtrl.categories[i];
                    return CategoryChip(
                      label: cat,
                      selected: storeCtrl.selectedCategory.value == cat,
                      onTap: () => storeCtrl.selectCategory(cat),
                    );
                  },
                ),
              )),
          const SizedBox(height: 14),
          // Products grid
          Expanded(
            child: Obx(() {
              if (storeCtrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.orange));
              }
              if (storeCtrl.error.value.isNotEmpty && storeCtrl.products.isEmpty) {
                return Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.error_outline_rounded, size: 48, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(l10n.failedToLoadProducts, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                    const SizedBox(height: 12),
                    TextButton(onPressed: () => storeCtrl.loadProducts(reset: true), child: Text(l10n.retry)),
                  ]),
                );
              }
              if (storeCtrl.products.isEmpty) {
                return Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.search_off_rounded, size: 60, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(l10n.noProductsFound,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
                  ]),
                );
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n is ScrollEndNotification && n.metrics.extentAfter < 200) {
                    storeCtrl.loadMore();
                  }
                  return false;
                },
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.58,
                  ),
                  itemCount: storeCtrl.products.length + (storeCtrl.isLoadingMore.value ? 1 : 0),
                  itemBuilder: (context, i) {
                    if (i == storeCtrl.products.length) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.orange));
                    }
                    final product = storeCtrl.products[i];
                    return Obx(() => ProductCard(
                          product: product,
                          isInCart: cartCtrl.isInCart(product.id),
                          onAddToCart: () {
                            // Navigate to detail to pick variant
                            Get.toNamed(AppRoutes.productDetail, arguments: product.id);
                          },
                          onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: product.id),
                        ));
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        if (cartCtrl.isEmpty) return const SizedBox.shrink();
        return FloatingActionButton.extended(
          onPressed: () => Get.toNamed(AppRoutes.cart),
          backgroundColor: AppColors.orange,
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          label: Text(
            '${cartCtrl.itemCount} item${cartCtrl.itemCount > 1 ? 's' : ''}',            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        );
      }),
    );
  }
}