import 'package:get/get.dart';
import 'package:petapp/features/store/models/cart_item_model.dart';
import 'package:petapp/features/store/models/product_model.dart';

class CartController extends GetxController {
  final RxList<CartItemModel> _items = <CartItemModel>[].obs;

  List<CartItemModel> get items => _items;
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.fold(0, (sum, e) => sum + e.quantity);

  double get subtotal => _items.fold(0.0, (sum, e) => sum + e.totalPrice);
  double get discount => 0.0;
  double get total => subtotal - discount;

  void addProduct(ProductModel product) {
    final idx = _items.indexWhere((e) => e.product.id == product.id);
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(quantity: _items[idx].quantity + 1);
    } else {
      _items.add(CartItemModel(product: product, quantity: 1));
    }
  }

  void removeProduct(String productId) {
    _items.removeWhere((e) => e.product.id == productId);
  }

  void increment(String productId) {
    final idx = _items.indexWhere((e) => e.product.id == productId);
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(quantity: _items[idx].quantity + 1);
    }
  }

  void decrement(String productId) {
    final idx = _items.indexWhere((e) => e.product.id == productId);
    if (idx < 0) return;
    if (_items[idx].quantity <= 1) {
      _items.removeAt(idx);
    } else {
      _items[idx] = _items[idx].copyWith(quantity: _items[idx].quantity - 1);
    }
  }

  int quantityOf(String productId) {
    final item = _items.firstWhereOrNull((e) => e.product.id == productId);
    return item?.quantity ?? 0;
  }

  bool isInCart(String productId) => _items.any((e) => e.product.id == productId);

  void clear() => _items.clear();
}
