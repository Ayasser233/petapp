import 'package:get/get.dart';
import 'package:petapp/features/store/data/mock_products.dart';
import 'package:petapp/features/store/models/product_model.dart';

class StoreController extends GetxController {
  final RxList<ProductModel> _products = <ProductModel>[].obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;

  List<String> get categories => MockProducts.categories;

  List<ProductModel> get filteredProducts {
    var list = _products.toList();
    if (selectedCategory.value != 'All') {
      list = list.where((p) => p.category == selectedCategory.value).toList();
    }
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              p.brand.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  @override
  void onInit() {
    super.onInit();
    _products.assignAll(MockProducts.all);
  }

  void selectCategory(String category) => selectedCategory.value = category;

  void setSearch(String query) => searchQuery.value = query;

  void toggleFavorite(String productId) {
    final idx = _products.indexWhere((p) => p.id == productId);
    if (idx < 0) return;
    _products[idx] = _products[idx].copyWith(isFavorite: !_products[idx].isFavorite);
  }
}
