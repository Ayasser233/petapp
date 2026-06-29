import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/features/store/controllers/cart_controller.dart';
import 'package:petapp/features/store/controllers/review_controller.dart';
import 'package:petapp/features/store/data/repositories/product_repository.dart';
import 'package:petapp/features/store/models/product_detail_model.dart';
import 'package:petapp/features/store/models/product_summary_model.dart';
import 'package:petapp/features/store/widgets/product_card.dart';
import 'package:petapp/features/store/widgets/star_rating_widget.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _repo = ProductRepository();
  final _pageCtrl = PageController();

  ProductDetailModel? _product;
  List<ProductSummaryModel> _related = [];
  bool _loading = true;
  String? _selectedVariantId;
  int _imageIndex = 0;
  bool _descExpanded = false;
  late String _productId;

  @override
  void initState() {
    super.initState();
    _productId = Get.arguments as String;
    _load();
    try {
      Get.find<ReviewController>().loadReviews(_productId);
    } catch (_) {}
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final p = await _repo.getProductDetail(_productId);
      final rel = await _repo.getRelatedProducts(_productId);
      if (!mounted) return;
      setState(() {
        _product = p;
        _related = rel;
        if (p.variants.isNotEmpty) _selectedVariantId = p.variants.first.id;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  ProductVariantModel? get _selectedVariant =>
      _product?.variants.firstWhereOrNull((v) => v.id == _selectedVariantId);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartCtrl = Get.find<CartController>();

    if (_loading) {
      return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: const Center(child: CircularProgressIndicator(color: AppColors.orange)),
      );
    }
    final p = _product;
    final l10n = AppLocalizations.of(context);
    if (p == null) {
      return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: AppBar(leading: const BackButton()),
        body: Center(child: Text(l10n.productNotFound)),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: CustomScrollView(
        slivers: [
          // Image carousel app bar
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: isDark ? Colors.black : Colors.white,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.8), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.black87),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  p.images.isEmpty
                      ? Container(color: AppColors.storeCardBg,
                          child: const Center(child: Icon(Icons.pets, size: 80, color: AppColors.lightorange)))
                      : PageView.builder(
                          controller: _pageCtrl,
                          itemCount: p.images.length,
                          onPageChanged: (i) => setState(() => _imageIndex = i),
                          itemBuilder: (context, i) => Image.network(
                            p.images[i].src,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.storeCardBg,
                              child: const Center(child: Icon(Icons.pets, size: 80, color: AppColors.lightorange)),
                            ),
                          ),
                        ),
                  // Page indicator
                  if (p.images.length > 1)
                    Positioned(
                      bottom: 12,
                      left: 0, right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(p.images.length, (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _imageIndex ? 16 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == _imageIndex ? AppColors.orange : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        )),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + vendor
                  Text(p.title ?? '', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  if (p.vendor != null) ...[
                    const SizedBox(height: 4),
                    Text(p.vendor!, style: TextStyle(color: AppColors.orange, fontWeight: FontWeight.w500)),
                  ],
                  // Rating
                  if (p.reviews != null && p.reviews!.approvedCount > 0) ...[
                    const SizedBox(height: 8),
                    Row(children: [
                      StarRatingWidget(
                        rating: (p.reviews!.averageRating ?? 0).round(),
                        onChanged: (_) {},
                        readOnly: true,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text('${p.reviews!.averageRating?.toStringAsFixed(1) ?? '—'} (${p.reviews!.approvedCount} reviews)',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ]),
                  ],

                  // Price
                  const SizedBox(height: 12),
                  if (_selectedVariant != null) ...[
                    Row(children: [
                      Text('${_selectedVariant!.price.toStringAsFixed(0)} EGP',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold, color: AppColors.orange)),
                      if (_selectedVariant!.compareAtPrice != null) ...[
                        const SizedBox(width: 10),
                        Text('${_selectedVariant!.compareAtPrice!.toStringAsFixed(0)} EGP',
                            style: const TextStyle(
                                decoration: TextDecoration.lineThrough, color: Colors.grey, fontSize: 14)),
                      ],
                    ]),
                    // Stock indicator
                    const SizedBox(height: 4),
                    Text(
                      _selectedVariant!.isInStock ? l10n.inStock : l10n.outOfStock,
                      style: TextStyle(
                        color: _selectedVariant!.isInStock ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w500, fontSize: 13,
                      ),
                    ),
                  ],

                  // Variants
                  if (p.variants.length > 1) ...[
                    const SizedBox(height: 16),
                    Text(l10n.options, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8, runSpacing: 8,
                      children: p.variants.map((v) {
                        final sel = v.id == _selectedVariantId;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedVariantId = v.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: sel ? AppColors.orange : Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: sel ? AppColors.orange : (isDark ? Colors.grey.shade600 : Colors.grey.shade300)),
                            ),
                            child: Text(v.title ?? '',
                                style: TextStyle(
                                    color: sel ? Colors.white : (isDark ? Colors.white : Colors.black87),
                                    fontWeight: sel ? FontWeight.bold : FontWeight.normal)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  // Description
                  if (p.description != null && p.description!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(l10n.description, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      p.description!,
                      maxLines: _descExpanded ? null : 3,
                      overflow: _descExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                      style: TextStyle(color: isDark ? Colors.grey.shade300 : Colors.grey.shade700, height: 1.5),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _descExpanded = !_descExpanded),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                      child: Text(_descExpanded ? l10n.showLess : l10n.readMore,
                          style: const TextStyle(color: AppColors.orange)),
                    ),
                  ],

                  // Reviews section
                  const SizedBox(height: 20),
                  _ReviewsSection(productId: _productId),

                  // Related products
                  if (_related.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(l10n.relatedProducts,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 240,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _related.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final rp = _related[i];
                          return Obx(() => ProductCard(
                                product: rp,
                                isInCart: cartCtrl.isInCart(rp.id),
                                width: 140,
                                onAddToCart: () => Get.toNamed(AppRoutes.productDetail, arguments: rp.id),
                                onTap: () => Get.toNamed(AppRoutes.productDetail, arguments: rp.id),
                              ));
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(() {
        final variant = _selectedVariant;
        final inCart = variant != null && cartCtrl.isInCart(variant.id);
        final l10n = AppLocalizations.of(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
          child: ElevatedButton(
            onPressed: (variant == null || !variant.isInStock)
                ? null
                : () => cartCtrl.addItem(variantId: variant.id, productId: p.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: inCart ? Colors.green : AppColors.orange,
              disabledBackgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              elevation: 0,
            ),
            child: Text(
              inCart ? l10n.addedToCart : (variant?.isInStock == false ? l10n.outOfStock : l10n.addToCart),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        );
      }),
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  final String productId;
  const _ReviewsSection({required this.productId});

  @override
  Widget build(BuildContext context) {
    ReviewController ctrl;
    try {
      ctrl = Get.find<ReviewController>();
    } catch (_) {
      return const SizedBox.shrink();
    }
    return Obx(() {
      if (ctrl.isLoading.value) return const SizedBox.shrink();
      if (ctrl.reviews.isEmpty) return const SizedBox.shrink();
      final l10n = AppLocalizations.of(context);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${l10n.reviews} (${ctrl.aggregate.value?.totalCount ?? 0})',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ...ctrl.reviews.take(3).map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      StarRatingWidget(rating: r.rating, onChanged: (_) {}, readOnly: true, size: 14),
                      const SizedBox(width: 6),
                      Text(r.title,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                    ]),
                    if (r.body != null && r.body!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(r.body!, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ],
                  ],
                ),
              )),
        ],
      );
    });
  }
}
