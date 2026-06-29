# Store Feature — Full Implementation Plan

## Overview

Migrate the existing **mock-only** store feature to a fully API-backed implementation that matches the provided screenshots. The feature covers:

1. Product browsing & detail
2. Cart (API-backed)
3. Delivery address selection + schedule order
4. Checkout (shipping options, payment method, order notes, promo code)
5. Orders list, order detail, order tracking, confirm delivery, payment proof upload
6. Product reviews (post-delivery)

All amounts are in **EGP**. Auth is `Bearer <token>` for protected routes.

---

## Current Problems

- `StoreController` / `CartController` use **mock data only** — no API calls.
- `DeliveryScreen` uses a hardcoded mock address with a toggle hack (`_hasAddress = false`).
- There is **no Schedule Order screen** (screenshots show Today / Tomorrow / Schedule tabs with time slots and a calendar).
- `CheckoutScreen` hardcodes address, payment method, and shipping fee; it never calls `POST /checkout/initiate`.
- **No orders feature** — no `OrdersScreen`, `OrderDetailScreen`, or `OrderTrackingScreen`.
- **No payment proof upload** screen.
- **No product detail screen** with variants, reviews, and related products.
- **No reviews feature.**
- `ProductModel` is flat and does not reflect the API shape (`ProductSummary` / `ProductDetail` / `ProductVariant`).
- `CartItemModel` wraps `ProductModel` instead of the API `CartItem` shape (`variantId`, `unitPrice`, `lineTotal`).

---

## Architecture (Clean / GetX)

```
lib/features/store/
  data/
    repositories/
      product_repository.dart        ← GET /products, /products/:id, etc.
      cart_repository.dart           ← GET/POST/PATCH/DELETE /cart
      checkout_repository.dart       ← GET /checkout/shipping-options, POST /checkout/initiate
      order_repository.dart          ← GET/POST /orders*
      review_repository.dart         ← GET/POST /products/:id/reviews
  models/
    product_summary_model.dart       ← ProductSummary
    product_detail_model.dart        ← ProductDetail + ProductVariant + ProductImage
    cart_model.dart                  ← Cart + CartItem (API shape)
    shipping_address_model.dart      ← ShippingAddress
    shipping_option_model.dart       ← ShippingOption
    checkout_summary_model.dart      ← CheckoutSummary + InitiateCheckoutResult
    order_model.dart                 ← OrderListItem + OrderDetail + OrderItem + OrderTrackingEvent
    review_model.dart                ← Review + ProductReviewsAggregate
  controllers/
    store_controller.dart            ← updated: API products, categories, search, sort
    cart_controller.dart             ← updated: API-backed add/update/remove/clear
    checkout_controller.dart         ← new: shipping options, address, schedule, payment, initiate
    order_controller.dart            ← new: list, detail, tracking, confirm delivery
    review_controller.dart           ← new: list + create
  screens/
    store_screen.dart                ← updated: use real products + variants
    product_detail_screen.dart       ← new: images, variants, add to cart, reviews
    cart_screen.dart                 ← updated: use API cart items
    delivery_screen.dart             ← updated: real address list + "Add Address" form
    schedule_order_screen.dart       ← new: Today/Tomorrow/Schedule tabs + time slots
    add_address_screen.dart          ← new: form → ShippingAddress
    checkout_screen.dart             ← updated: real summary, payment picker, promo, notes, Pay Now
    order_confirmation_screen.dart   ← new: success screen after POST /checkout/initiate
    orders_screen.dart               ← new: paginated order list
    order_detail_screen.dart         ← new: line items, status badge, action buttons
    order_tracking_screen.dart       ← new: timeline of OrderTrackingEvent
    payment_proof_screen.dart        ← new: image picker → POST /orders/:id/payment-proof
    review_form_screen.dart          ← new: rating + title + body → POST /products/:id/reviews
  widgets/
    product_card.dart                ← updated: use ProductSummary
    quantity_stepper.dart            ← keep as-is
    category_chip.dart               ← keep as-is
    payment_summary_widget.dart      ← updated: add shipping amount from API
    order_status_badge.dart          ← new: colored badge for OrderStatus
    tracking_timeline.dart           ← new: vertical timeline widget
    star_rating_widget.dart          ← new: interactive star picker
    payment_method_tile.dart         ← new: radio tile for payment method selection
```

---

## New Routes to Add

| Constant | Path | Screen |
|---|---|---|
| `productDetail` | `/product-detail` | `ProductDetailScreen` (arg: productId) |
| `scheduleOrder` | `/schedule-order` | `ScheduleOrderScreen` |
| `addAddress` | `/add-address` | `AddAddressScreen` |
| `orderConfirmation` | `/order-confirmation` | `OrderConfirmationScreen` (arg: `InitiateCheckoutResult`) |
| `orders` | `/orders` | `OrdersScreen` |
| `orderDetail` | `/order-detail` | `OrderDetailScreen` (arg: orderId) |
| `orderTracking` | `/order-tracking` | `OrderTrackingScreen` (arg: orderId) |
| `paymentProof` | `/payment-proof` | `PaymentProofScreen` (arg: orderId) |
| `reviewForm` | `/review-form` | `ReviewFormScreen` (arg: `{productId, orderId}`) |

---

## Models

### `ProductSummaryModel`
Maps to `ProductSummary` from the API:
```
id, title, handle, status, vendor, productType, tags, minPrice, imageUrl
```

### `ProductDetailModel`
Maps to `ProductDetail`:
```
id, title, description, vendor, productType, handle, status, tags, options,
variants: List<ProductVariantModel>, images: List<ProductImageModel>
reviews: { averageRating, approvedCount }
```

### `ProductVariantModel`
```
id, title, price, compareAtPrice, sku, option1/2/3,
inventoryQuantity, inventoryPolicy (deny|continue), weight, weightUnit
```

### `CartModel` (API shape)
```
cartId, items: List<CartItemApiModel>, subtotal, updatedAt
```

### `CartItemApiModel`
```
variantId, productId, quantity, unitPrice, lineTotal, product (enriched)
```

### `ShippingAddressModel`
```
fullName, phone, country, city, addressLine1, addressLine2?, postalCode?
```

### `ShippingOptionModel`
```
methodId, title, description, price
```

### `CheckoutSummaryModel`
```
items, subtotal, shippingAmount, discountAmount, totalAmount,
warnings: List<CheckoutPriceWarning>
```

### `InitiateCheckoutResultModel`
```
summary, orderId, orderName, paymentMethod, financialStatus
```

### `OrderListItemModel`
```
id, status, paymentStatus, paymentMethod, subtotal, shippingAmount,
discountAmount, totalAmount, itemCount, createdAt
```

### `OrderDetailModel`
```
id, status, paymentStatus, paymentMethod, subtotal, shippingAmount,
discountAmount, totalAmount, shippingAddress, createdAt, items: List<OrderItemModel>
```

### `OrderTrackingEventModel`
```
id, status, description, location, createdAt
```

### `ReviewModel`
```
id, userId, orderId, productId, rating, title, body, isApproved, createdAt
```

---

## Repositories

### `ProductRepository`
```
Future<List<ProductSummaryModel>> getProducts({search, category, sort, minPrice, maxPrice, page, limit})
Future<List<String>> getCategories()
Future<List<ProductSummaryModel>> getNewArrivals({page, limit})
Future<List<ProductSummaryModel>> getBestSelling({page, limit})
Future<List<ProductSummaryModel>> getTopRated({page, limit})
Future<(ProductDetailModel, ReviewsAggregate)> getProductDetail(String id)
Future<List<ProductSummaryModel>> getRelatedProducts(String id, {limit})
Future<List<ProductSummaryModel>> getBoughtTogether(String id, {limit})
```

### `CartRepository`
```
Future<CartModel> getCart()
Future<CartModel> addItem({variantId, productId?, quantity})
Future<CartModel> updateItem(String variantId, {required int quantity})
Future<CartModel> removeItem(String variantId)
Future<CartModel> clearCart()
```

### `CheckoutRepository`
```
Future<List<ShippingOptionModel>> getShippingOptions()
Future<InitiateCheckoutResultModel> initiateCheckout({
  paymentMethod, shippingMethodId, shippingAddress,
  customerEmail?, customerNote?
})
```

### `OrderRepository`
```
Future<List<OrderListItemModel>> getOrders({page, limit, status?})
Future<OrderDetailModel> getOrderDetail(String id)
Future<List<OrderTrackingEventModel>> getOrderTracking(String id)
Future<OrderDetailModel> confirmDelivery(String id)
Future<PaymentProofResult> uploadPaymentProof(String id, List<File> images)
```

### `ReviewRepository`
```
Future<(List<ReviewModel>, ReviewsAggregate, bool)> getReviews(String productId, {page, limit})
Future<ReviewModel> createReview(String productId, {orderId, rating, title, body?})
```

---

## Controllers

### `StoreController` (updated)
- Remove mock data, call `ProductRepository.getProducts()` with pagination.
- Load categories from `ProductRepository.getCategories()`.
- Support filter params: `search`, `category`, `sort`, `minPrice`, `maxPrice`.
- Expose `RxBool isLoading`, `RxString error`.

### `CartController` (updated)
- On init: call `CartRepository.getCart()` to load persisted cart.
- `addItem(variantId, productId?, quantity)` → `CartRepository.addItem()`.
- `updateItem(variantId, quantity)` → `CartRepository.updateItem()`.
- `removeItem(variantId)` → `CartRepository.removeItem()`.
- `clear()` → `CartRepository.clearCart()`.
- Handle `409 cart.stockInsufficient` → show snackbar.
- `itemCount` → sum of `item.quantity` from `CartModel.items`.

### `CheckoutController` (new)
State:
- `RxList<ShippingOptionModel> shippingOptions`
- `Rx<ShippingOptionModel?> selectedShippingOption`
- `Rx<ShippingAddressModel?> selectedAddress`
- `RxList<ShippingAddressModel> savedAddresses` (local persistence)
- `RxString selectedPaymentMethod` (default: `cash_on_delivery`)
- `RxString selectedDeliverySlot` (Today/Tomorrow/Schedule + time)
- `RxString customerNote`
- `RxString promoCode` (UI only — no coupon API yet)
- `RxBool isLoading`

Methods:
- `loadShippingOptions()` → `CheckoutRepository.getShippingOptions()`
- `initiateCheckout()` → `CheckoutRepository.initiateCheckout()` → navigate to `OrderConfirmationScreen`
- `addAddress(ShippingAddressModel)` → persist to local list

### `OrderController` (new)
- `loadOrders({status?})`, `loadMore()`
- `loadOrderDetail(String id)`
- `loadTracking(String id)`
- `confirmDelivery(String id)` → on success navigate to `ReviewFormScreen` if applicable
- `uploadPaymentProof(String id, List<File> images)`

### `ReviewController` (new)
- `loadReviews(String productId)`
- `submitReview({productId, orderId, rating, title, body?})`

---

## Screens Detail

### `DeliveryScreen` (updated)
- Show saved addresses list (from `CheckoutController.savedAddresses`).
- "Add Address" → navigate to `AddAddressScreen`.
- On address select → set `CheckoutController.selectedAddress`.
- "Continue" → navigate to `ScheduleOrderScreen`.

### `AddAddressScreen` (new)
Form fields matching `ShippingAddress`:
- Full Name, Phone, Country, City, Address Line 1, Address Line 2 (optional), Postal Code (optional).
- On save → `CheckoutController.addAddress()` → pop.

### `ScheduleOrderScreen` (new)
Matches screenshots exactly:
- Three tabs: **Today** / **Tomorrow** / **Schedule**.
  - Today: show only remaining time slots for today (e.g. only 9 PM if late in day).
  - Tomorrow: show all time slots (9 AM, 11 AM, 1 PM, 3 PM, 5 PM, 7 PM, 9 PM).
  - Schedule: show a calendar (`TableCalendar` or custom) + time slot chips below.
- Time slots displayed as outlined pill chips; selected chip gets filled border.
- "Next" button (outlined, black border) → save slot to `CheckoutController.selectedDeliverySlot` → navigate to `CheckoutScreen`.

### `CheckoutScreen` (updated to match screenshots)
Layout (scrollable):
1. **"Deliver to" card** — shows selected address label + full address + delivery time (from schedule).
2. **Payment method** — radio tiles: Cash On Delivery / Card On Delivery (maps to `cash_on_delivery` / `vodafone_cash`).
3. **Items section** — horizontal scroll of item image + name + description + price.
4. **Price breakdown** — Subtotal (N items), Shipping Fee, Total Amount, "Inclusive Of VAT" note.
5. **Promo code row** — text field + "Apply" button (UI only for now).
6. **Order Notes** — multiline text area.
7. **"Pay Now" button** (yellow, sticky bottom) → calls `CheckoutController.initiateCheckout()`.

Price warning: if `summary.warnings` is non-empty, show a yellow banner "Some prices changed since you added items to cart."

### `OrderConfirmationScreen` (new)
- Shows order name (e.g. "#1042"), total amount, payment method.
- If `paymentMethod !== cash_on_delivery` → "Upload Payment Proof" button → `PaymentProofScreen`.
- "Track Order" button → `OrderTrackingScreen`.
- "Back to Home" button.

### `OrdersScreen` (new)
- Paginated list of `OrderListItemModel`.
- Filter tabs: All / Pending / Confirmed / Processing / Shipped / Delivered / Cancelled.
- Each tile: order name, date, status badge, total, item count.
- Tap → `OrderDetailScreen`.

### `OrderDetailScreen` (new)
- Header: order name, date, status badge.
- Line items list: image, title, variant, quantity, price.
- Shipping address card.
- Price breakdown: subtotal, shipping, total.
- **Action buttons** (conditional):
  - `paymentStatus === pending && paymentMethod !== cash_on_delivery` → "Upload Payment Proof".
  - `status === shipped` → "Confirm Delivery".
  - "Track Order" → `OrderTrackingScreen`.

### `OrderTrackingScreen` (new)
- Vertical timeline of `OrderTrackingEvent` items.
- Each event: status label (bold), description, location, formatted date.
- Current status highlighted.

### `PaymentProofScreen` (new)
- Image picker (1–5 images).
- Preview grid of selected images.
- "Submit" → `OrderController.uploadPaymentProof()`.

### `ReviewFormScreen` (new)
- Star rating widget (1–5).
- Title text field (max 255).
- Body text area (optional, max 5000).
- "Submit Review" → `ReviewController.submitReview()`.
- On success → show confirmation snackbar + pop.

### `ProductDetailScreen` (new)
- Image carousel (`PageView` with dot indicators).
- Title, vendor, average rating + review count.
- Variant selector (option1/option2/option3 as chip groups).
- Price (and compare-at-price if set).
- Stock check: if `inventory_policy === deny && inventory_quantity <= 0` → show "Out of Stock".
- Description (collapsible).
- "Add to Cart" button → `CartController.addItem(variantId)`.
- Related products horizontal scroll.
- Reviews section (first 5, "See All" → full reviews list).
- If `isReviewedByMe === false` and user has a delivered order with this product → show "Write a Review" button.

---

## API Client Notes

- Base URL: configured via environment / `ApiConfig`.
- Auth header injected by a `Dio` interceptor using the stored token.
- Error handling: parse `{ success, statusCode, message, errors }` shape; surface translated `message` to user via `Get.snackbar`.
- Specific error keys to handle gracefully:
  - `cart.stockInsufficient` → "Not enough stock available."
  - `checkout.cartEmpty` → redirect to store.
  - `checkout.stockInsufficient` → show which item, redirect to cart.
  - `orders.mustBeShippedFirst`, `orders.alreadyDelivered` → disable button.
  - `reviews.alreadyReviewed` → hide review button.

---

## Checkout Flow (end-to-end)

```
CartScreen
  └─► DeliveryScreen           ← pick/add shipping address
        └─► ScheduleOrderScreen ← pick delivery time slot
              └─► CheckoutScreen ← review + payment + notes + Pay Now
                    └─► POST /checkout/initiate
                          └─► OrderConfirmationScreen
                                ├─► PaymentProofScreen (if non-COD)
                                └─► OrderTrackingScreen
```

---

## File Checklist

### New files
- [ ] `lib/features/store/data/repositories/product_repository.dart`
- [ ] `lib/features/store/data/repositories/cart_repository.dart`
- [ ] `lib/features/store/data/repositories/checkout_repository.dart`
- [ ] `lib/features/store/data/repositories/order_repository.dart`
- [ ] `lib/features/store/data/repositories/review_repository.dart`
- [ ] `lib/features/store/models/product_summary_model.dart`
- [ ] `lib/features/store/models/product_detail_model.dart`
- [ ] `lib/features/store/models/cart_model.dart`
- [ ] `lib/features/store/models/shipping_address_model.dart`
- [ ] `lib/features/store/models/shipping_option_model.dart`
- [ ] `lib/features/store/models/checkout_result_model.dart`
- [ ] `lib/features/store/models/order_model.dart`
- [ ] `lib/features/store/models/review_model.dart`
- [ ] `lib/features/store/controllers/checkout_controller.dart`
- [ ] `lib/features/store/controllers/order_controller.dart`
- [ ] `lib/features/store/controllers/review_controller.dart`
- [ ] `lib/features/store/screens/product_detail_screen.dart`
- [ ] `lib/features/store/screens/schedule_order_screen.dart`
- [ ] `lib/features/store/screens/add_address_screen.dart`
- [ ] `lib/features/store/screens/order_confirmation_screen.dart`
- [ ] `lib/features/store/screens/orders_screen.dart`
- [ ] `lib/features/store/screens/order_detail_screen.dart`
- [ ] `lib/features/store/screens/order_tracking_screen.dart`
- [ ] `lib/features/store/screens/payment_proof_screen.dart`
- [ ] `lib/features/store/screens/review_form_screen.dart`
- [ ] `lib/features/store/widgets/order_status_badge.dart`
- [ ] `lib/features/store/widgets/tracking_timeline.dart`
- [ ] `lib/features/store/widgets/star_rating_widget.dart`
- [ ] `lib/features/store/widgets/payment_method_tile.dart`

### Modified files
- [ ] `lib/features/store/models/product_model.dart` → replace with `ProductSummaryModel`
- [ ] `lib/features/store/models/cart_item_model.dart` → replace with API `CartItemApiModel`
- [ ] `lib/features/store/controllers/store_controller.dart` → API integration
- [ ] `lib/features/store/controllers/cart_controller.dart` → API integration
- [ ] `lib/features/store/screens/store_screen.dart` → use new models + product detail nav
- [ ] `lib/features/store/screens/cart_screen.dart` → use API cart + variant-based items
- [ ] `lib/features/store/screens/delivery_screen.dart` → real addresses + nav to ScheduleOrderScreen
- [ ] `lib/features/store/screens/checkout_screen.dart` → full redesign per screenshots
- [ ] `lib/features/store/widgets/product_card.dart` → use `ProductSummaryModel`
- [ ] `lib/features/store/widgets/payment_summary_widget.dart` → add real shipping amount
- [ ] `lib/core/routes/routes.dart` → add all new routes + bindings
