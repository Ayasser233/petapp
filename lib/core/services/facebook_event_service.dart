import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';

class FacebookEventService {
  FacebookEventService._();

  static final FacebookAppEvents _fb = FacebookAppEvents();

  static Future<void> logContact() async {
    try {
      await _fb.logEvent(name: 'Contact');
    } catch (e) {
      debugPrint('FB logContact error: $e');
    }
  }

  static Future<void> logSearch({
    required String searchString,
    String? contentType,
  }) async {
    try {
      await _fb.logEvent(
        name: 'fb_mobile_search',
        parameters: {
          'search_string': searchString,
          if (contentType != null) 'content_type': contentType,
        },
      );
    } catch (e) {
      debugPrint('FB logSearch error: $e');
    }
  }

  static Future<void> logCompleteRegistration({
    required String registrationMethod,
  }) async {
    try {
      await _fb.logCompletedRegistration(
        registrationMethod: registrationMethod,
      );
    } catch (e) {
      debugPrint('FB logCompleteRegistration error: $e');
    }
  }

  static Future<void> logViewContent({
    required String contentId,
    required String contentType,
  }) async {
    try {
      await _fb.logEvent(
        name: 'fb_mobile_content_view',
        parameters: {
          'content_id': contentId,
          'content_type': contentType,
        },
      );
    } catch (e) {
      debugPrint('FB logViewContent error: $e');
    }
  }

  static Future<void> logSubscribe() async {
    try {
      await _fb.logEvent(name: 'Subscribe');
    } catch (e) {
      debugPrint('FB logSubscribe error: $e');
    }
  }

  static Future<void> logInitiateCheckout({
    required String contentId,
    required String contentType,
    required String currency,
    required double value,
  }) async {
    try {
      await _fb.logEvent(
        name: 'fb_mobile_initiated_checkout',
        parameters: {
          'content_id': contentId,
          'content_type': contentType,
          'currency': currency,
          'total_price': value,
        },
      );
    } catch (e) {
      debugPrint('FB logInitiateCheckout error: $e');
    }
  }

  static Future<void> logStartTrial() async {
    try {
      await _fb.logEvent(name: 'StartTrial');
    } catch (e) {
      debugPrint('FB logStartTrial error: $e');
    }
  }

  static Future<void> logRate({
    required int maxRatingValue,
    required String contentType,
    required double valueToSum,
  }) async {
    try {
      await _fb.logEvent(
        name: 'Rate',
        parameters: {
          'max_rating_value': maxRatingValue,
          'content_type': contentType,
          'valueToSum': valueToSum,
        },
      );
    } catch (e) {
      debugPrint('FB logRate error: $e');
    }
  }

  static Future<void> logPurchase({
    required String contentId,
    required String contentType,
    required String currency,
    required double value,
  }) async {
    try {
      await _fb.logPurchase(
        amount: value,
        currency: currency,
        parameters: {
          'content_id': contentId,
          'content_type': contentType,
        },
      );
    } catch (e) {
      debugPrint('FB logPurchase error: $e');
    }
  }

  static Future<void> logAddPaymentInfo({required bool success}) async {
    try {
      await _fb.logEvent(
        name: 'AddPaymentInfo',
        parameters: {
          'success': success,
        },
      );
    } catch (e) {
      debugPrint('FB logAddPaymentInfo error: $e');
    }
  }
}