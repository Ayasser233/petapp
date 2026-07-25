import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/utils/api_constants.dart';
import 'package:petapp/features/store/models/product_summary_model.dart';
import 'package:petapp/features/store/models/product_detail_model.dart';
import 'package:get/get.dart';

class ProductRepository {
  ApiClient get _client => Get.find<ApiClient>();

  Future<List<String>> getCategories() async {
    final res = await _client.get(ApiConstants.productCategoriesEndpoint);
    final data = res.data['data'];
    if (data is List) return data.map((e) => e.toString()).toList();
    return [];
  }

  Future<({List<ProductSummaryModel> items, int total, bool hasNext})> getProducts({
    String? search,
    String? category,
    String? sort,
    double? minPrice,
    double? maxPrice,
    int page = 1,
    int limit = 20,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (search != null && search.isNotEmpty) 'search': search,
      if (category != null && category.isNotEmpty) 'category': category,
      if (sort != null) 'sort': sort,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
    };
    final res = await _client.get(ApiConstants.productsEndpoint, queryParameters: params);
    return _parseList(res.data);
  }

  Future<({List<ProductSummaryModel> items, int total, bool hasNext})> getNewArrivals({int page = 1, int limit = 20}) async {
    final res = await _client.get(ApiConstants.productNewArrivalsEndpoint,
        queryParameters: {'page': page, 'limit': limit});
    return _parseList(res.data);
  }

  Future<({List<ProductSummaryModel> items, int total, bool hasNext})> getBestSelling({int page = 1, int limit = 20}) async {
    final res = await _client.get(ApiConstants.productBestSellingEndpoint,
        queryParameters: {'page': page, 'limit': limit});
    return _parseList(res.data);
  }

  Future<({List<ProductSummaryModel> items, int total, bool hasNext})> getTopRated({int page = 1, int limit = 20}) async {
    final res = await _client.get(ApiConstants.productTopRatedEndpoint,
        queryParameters: {'page': page, 'limit': limit});
    return _parseList(res.data);
  }

  Future<ProductDetailModel> getProductDetail(String id) async {
    final res = await _client.get(ApiConstants.productDetailEndpoint(id));
    final data = res.data['data'] as Map<String, dynamic>;
    if (kDebugMode) {
      debugPrint('═══════════════════════════════════════════');
      debugPrint('[ProductRepo] DETAIL raw JSON:');
      debugPrint(const JsonEncoder.withIndent('  ').convert(data));
      debugPrint('═══════════════════════════════════════════');
    }
    return ProductDetailModel.fromJson(data);
  }

  Future<List<ProductSummaryModel>> getRelatedProducts(String id, {int limit = 8}) async {
    final res = await _client.get(ApiConstants.productRelatedEndpoint(id),
        queryParameters: {'limit': limit});
    final data = res.data['data'];
    if (data is List) return data.map((e) => ProductSummaryModel.fromJson(e as Map<String, dynamic>)).toList();
    return [];
  }

  Future<List<ProductSummaryModel>> getBoughtTogether(String id, {int limit = 5}) async {
    final res = await _client.get(ApiConstants.productBoughtTogetherEndpoint(id),
        queryParameters: {'limit': limit});
    final data = res.data['data'];
    if (data is List) return data.map((e) => ProductSummaryModel.fromJson(e as Map<String, dynamic>)).toList();
    return [];
  }

  ({List<ProductSummaryModel> items, int total, bool hasNext}) _parseList(dynamic responseData) {
    final data = responseData['data'];
    final meta = responseData['meta'] as Map<String, dynamic>?;
    final rawList = data as List<dynamic>? ?? [];

    if (kDebugMode && rawList.isNotEmpty) {
      final first = rawList.first as Map<String, dynamic>;
      debugPrint('═══════════════════════════════════════════');
      debugPrint('[ProductRepo] LIST — first product full raw JSON:');
      debugPrint(const JsonEncoder.withIndent('  ').convert(first));
      debugPrint('───────────────────────────────────────────');
      final parsed = ProductSummaryModel.fromJson(first);
      debugPrint('[ProductRepo] Parsed imageUrl → "${parsed.imageUrl}"');
      debugPrint('═══════════════════════════════════════════');
    }

    final items = rawList
            .map((e) => ProductSummaryModel.fromJson(e as Map<String, dynamic>))
            .toList();
    final total = meta?['total'] as int? ?? items.length;
    final hasNext = meta?['hasNextPage'] as bool? ?? false;
    return (items: items, total: total, hasNext: hasNext);
  }
}
