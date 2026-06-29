import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/utils/api_constants.dart';
import 'package:petapp/features/store/models/order_model.dart';
import 'package:get/get.dart';

class OrderRepository {
  ApiClient get _client => Get.find<ApiClient>();

  Future<({List<OrderListItemModel> items, bool hasNext, int total})> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    final params = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (status != null) 'status': status,
    };
    final res = await _client.get(ApiConstants.ordersEndpoint, queryParameters: params);
    final data = res.data['data'] as List<dynamic>? ?? [];
    final meta = res.data['meta'] as Map<String, dynamic>?;
    return (
      items: data.map((e) => OrderListItemModel.fromJson(e as Map<String, dynamic>)).toList(),
      hasNext: meta?['hasNextPage'] as bool? ?? false,
      total: meta?['total'] as int? ?? data.length,
    );
  }

  Future<OrderDetailModel> getOrderDetail(String id) async {
    final res = await _client.get(ApiConstants.orderDetailEndpoint(id));
    return OrderDetailModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<List<OrderTrackingEventModel>> getOrderTracking(String id) async {
    final res = await _client.get(ApiConstants.orderTrackingEndpoint(id));
    final data = res.data['data'] as List<dynamic>? ?? [];
    return data.map((e) => OrderTrackingEventModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<OrderDetailModel> confirmDelivery(String id) async {
    final res = await _client.post(ApiConstants.orderConfirmDeliveryEndpoint(id));
    return OrderDetailModel.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> uploadPaymentProof(String id, List<File> images) async {
    final formData = dio.FormData.fromMap({
      'images': await Future.wait(
        images.map((f) async => await dio.MultipartFile.fromFile(
          f.path,
          filename: f.path.split('/').last,
        )),
      ),
    });
    await _client.post(
      ApiConstants.orderPaymentProofEndpoint(id),
      data: formData,
      options: dio.Options(contentType: 'multipart/form-data'),
    );
  }
}
