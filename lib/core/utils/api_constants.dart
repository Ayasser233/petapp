class ApiConstants {
  // API URLs - Environment based
  static String get apiBaseUrl {
    const environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'prod');

    if (environment == 'dev') {
      // Development API
      return 'https://api-dev.aleefy-app.com/api/v1';
    } else {
      // Production API
      return 'https://api.aleefy-app.com/api/v1';
    }
  }

  static const String prodApiBaseUrl = 'https://api.aleefy-app.com/api/v1';
  static const String devApiBaseUrl = 'https://api-dev.aleefy-app.com/api/v1';
  static const String fallbackApiBaseUrl = 'https://api.aleefy-app.com/api/v1';

  // Media / CDN
  /// MinIO object storage — where product images are actually served from.
  static const String mediaBaseUrl = 'https://minio-api.aleefy-app.com/uploads';

  /// Rewrites any image URL that incorrectly points at the API server to the
  /// real MinIO CDN.  Safe to call with `null` or already-correct URLs.
  ///
  /// Example:
  ///   https://api.aleefy-app.com/products/abc.jpg
  ///   → https://minio-api.aleefy-app.com/uploads/products/abc.jpg
  static String? fixImageUrl(String? url) {
    if (url == null || url.isEmpty) return url;
    // Already pointing at MinIO — nothing to do
    if (url.contains('minio-api.aleefy-app.com')) return url;
    // Replace the API origin with the MinIO origin + /uploads prefix
    return url.replaceFirst(
      RegExp(r'https?://api\.aleefy-app\.com'),
      '$mediaBaseUrl',
    );
  }

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // API Health Check
  static const String healthEndpoint = '/health';

  // Auth Endpoints
  static const String authEndpoint = '/auth';
  static const String registerEndpoint = '/auth/register';
  static const String loginEndpoint = '/auth/login';
  static const String logoutEndpoint = '/auth/logout';
  static const String completeProfileEndpoint = '/auth/complete-profile';
  static const String profileEndpoint = '/auth/profile';
  static const String confirmEndpoint = '/auth/confirm';
  static const String resendOtpEndpoint = '/auth/resend-otp';
  static const String confirmNewEmailEndpoint = '/auth/confirm/new';
  static const String forgotPasswordEndpoint = '/auth/forgot/password';
  static const String verifyResetOtpEndpoint = '/auth/verify-reset-otp';
  static const String resendResetOtpEndpoint =
      '/auth/forgot/password'; // Resend uses same endpoint as forgot password
  static const String resetPasswordEndpoint = '/auth/reset/password';
  static const String changePasswordEndpoint = '/auth/change-password';
  static const String refreshTokenEndpoint = '/auth/refresh';
  static String updateProfileEndpoint(String userId) => '/users/$userId';
  static const String googleLoginEndpoint = '/auth/google/login';
  static const String appleLoginEndpoint = '/auth/apple/login';
  static const String changeMyDataEndpoint = '/users/profile';
  static const String notificationTokenEndpoint = '/push-tokens';
  static const String deleteAccountEndpoint = '/users/account'; // Soft delete user account

  // Pet Endpoints
  static const String petsEndpoint = '/pets';
  static const String petSpeciesAllowedEndpoint = '/pets/species/allowed';
  static String petDetailEndpoint(String id) => '/pets/$id';
  static String petUpdateEndpoint(String id) => '/pets/$id';
  static String petDeleteEndpoint(String id) => '/pets/$id';
  static String petRestoreEndpoint(String id) => '/pets/$id/restore';
  static String petHardDeleteEndpoint(String id) => '/pets/$id/hard';
  static String petAppointmentsEndpoint(String id) => '/pets/$id/appointments';
  static String medicalRecordsEndpoint(String petId) => '/pets/$petId/medical-records';
  static String shareLinkEndpoint(String petId) => '/pets/$petId/medical-records/share-link';

  // Symptoms Endpoints
  static const String symptomsEndpoint = '/api/symptoms';
  static String petTypeSymptomEndpoint(String petType) =>
      '/api/symptoms/$petType';

  // Vet Endpoints
  static const String vetsEndpoint = '/vets';
  static String vetDetailEndpoint(String id) => '/vets/$id';
  static String vetScheduleEndpoint(String id) => '/vets/$id/schedule';
  static String vetReviewsEndpoint(String id) => '/appointments/reviews/$id';

   // Appointment Endpoints
   static const String appointmentsEndpoint = '/appointments';
   static String appointmentDetailEndpoint(String id) => '/appointments/$id';
   static String appointmentCancelEndpoint(String id) =>
       '/appointments/$id/cancel';
   static String appointmentCompleteEndpoint(String id) =>
       '/appointments/$id/complete';
   static String appointmentReviewEndpoint(String id) =>
       '/appointments/$id/review';

   // Discounts Endpoints
   static const String globalDiscountUsageEndpoint = '/discounts/global/completed-usage';

  // Points Endpoints
  static const String pointsBalanceEndpoint = '/points/my/balance';
  static const String pointsTransactionsEndpoint = '/points/my/transactions';
  static const String pointsRedeemValidateEndpoint = '/points/validate';

  // Vaccination Endpoints
  static const String vaccinationEligibleCategoriesEndpoint =
      '/vaccination/eligible-categories';
  static const String vaccinationSeriesEndpoint = '/vaccination/series';
  static String vaccinationMarkDoseCompleteEndpoint(String seriesId) =>
      '/vaccination/series/$seriesId/mark-dose-complete';
  static String vaccinationMarkAnnualBoosterCompleteEndpoint(String seriesId) =>
      '/vaccination/series/$seriesId/mark-annual-booster-complete';
  static String vaccinationDeleteSeriesEndpoint(String seriesId) =>
      '/vaccination/series/$seriesId';
  static String vaccinationMedicalSheetEndpoint(String petId) =>
      '/vaccination/schedules/pet/$petId/medical-sheet';

  // Store — Products
  static const String productsEndpoint = '/products';
  static const String productCategoriesEndpoint = '/products/categories';
  static const String productNewArrivalsEndpoint = '/products/new-arrivals';
  static const String productBestSellingEndpoint = '/products/best-selling';
  static const String productTopRatedEndpoint = '/products/top-rated';
  static const String productMostPurchasedEndpoint = '/products/me/most-purchased';
  static String productDetailEndpoint(String id) => '/products/$id';
  static String productRelatedEndpoint(String id) => '/products/$id/related';
  static String productBoughtTogetherEndpoint(String id) => '/products/$id/bought-together';
  static String productReviewsEndpoint(String productId) => '/products/$productId/reviews';

  // Store — Cart
  static const String cartEndpoint = '/cart';
  static const String cartItemsEndpoint = '/cart/items';
  static String cartItemEndpoint(String variantId) => '/cart/items/$variantId';

  // Store — Checkout
  static const String shippingOptionsEndpoint = '/checkout/shipping-options';
  static const String checkoutInitiateEndpoint = '/checkout/initiate';

  // Store — Orders
  static const String ordersEndpoint = '/orders';
  static String orderDetailEndpoint(String id) => '/orders/$id';
  static String orderTrackingEndpoint(String id) => '/orders/$id/tracking';
  static String orderConfirmDeliveryEndpoint(String id) => '/orders/$id/confirm-delivery';
  static String orderPaymentProofEndpoint(String id) => '/orders/$id/payment-proof';

  // Media Endpoints
  static const String uploadsEndpoint = '/api/uploads';
  static const String petModelsEndpoint = '/api/models';

  // User Endpoints
  static const String usersEndpoint = '/api/users';
  static String userDetailEndpoint(String id) => '/api/users/$id';

  // Cache durations
  static const Duration shortCacheDuration = Duration(minutes: 5);
  static const Duration mediumCacheDuration = Duration(hours: 1);
  static const Duration longCacheDuration = Duration(days: 1);
}
