import 'package:get/get.dart';
import 'package:petapp/features/store/data/repositories/product_repository.dart';
import 'package:petapp/features/store/models/product_summary_model.dart';

class StoreController extends GetxController {
  final ProductRepository _repo = ProductRepository();

  final RxList<ProductSummaryModel> _products = <ProductSummaryModel>[].obs;
  final RxList<String> _categories = <String>['All'].obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString searchQuery = ''.obs;
  final RxString sortOption = 'created_desc'.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString error = ''.obs;

  int _page = 1;
  bool _hasNext = true;

  List<ProductSummaryModel> get products => _products;
  List<String> get categories => _categories;

  @override
  void onInit() {
    super.onInit();
    _loadCategories();
    loadProducts(reset: true);
    debounce(searchQuery, (_) => loadProducts(reset: true),
        time: const Duration(milliseconds: 400));
    ever(selectedCategory, (_) => loadProducts(reset: true));
    ever(sortOption, (_) => loadProducts(reset: true));
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await _repo.getCategories();
      _categories.assignAll(['All', ...cats]);
    } catch (_) {}
  }

  Future<void> loadProducts({bool reset = false}) async {
    if (reset) {
      _page = 1;
      _hasNext = true;
      _products.clear();
    }
    if (!_hasNext) return;
    if (isLoading.value || isLoadingMore.value) return;

    if (_page == 1) {
      isLoading.value = true;
    } else {
      isLoadingMore.value = true;
    }
    error.value = '';

    try {
      final cat = selectedCategory.value == 'All' ? null : selectedCategory.value;
      final result = await _repo.getProducts(
        search: searchQuery.value.trim().isEmpty ? null : searchQuery.value.trim(),
        category: cat,
        sort: sortOption.value,
        page: _page,
      );
      _products.addAll(result.items);
      _hasNext = result.hasNext;
      _page++;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void loadMore() => loadProducts();
  void selectCategory(String cat) => selectedCategory.value = cat;
  void setSearch(String q) => searchQuery.value = q;
  void setSort(String s) => sortOption.value = s;
}