import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/services/connectivity_service.dart';
import 'package:petapp/core/services/error_handler_service.dart';
import 'package:petapp/core/services/token_service.dart';
import 'package:petapp/core/utils/api_constants.dart';

class PointsService {
  final ApiClient _apiClient;

  PointsService({
    required ErrorHandlerService errorHandler,
    required TokenService tokenService,
    required ConnectivityService connectivityService,
  }) : _apiClient = ApiClient(
          errorHandler: errorHandler,
          tokenService: tokenService,
          connectivityService: connectivityService,
        );

  /// Get user's points balance
  Future<Map<String, dynamic>> getPointsBalance() async {
    try {
      final response = await _apiClient.get(
        ApiConstants.pointsBalanceEndpoint,
      );

      if (response.data['success'] == true && response.data['data'] != null) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        throw Exception(
            response.data['message'] ?? 'Failed to fetch points balance');
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Get user's points transactions history
  Future<List<Map<String, dynamic>>> getPointsTransactions({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiConstants.pointsTransactionsEndpoint,
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.data['success'] == true && response.data['data'] != null) {
        final data = response.data['data'];

        // Handle both array and paginated responses
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data['transactions'] != null) {
          return List<Map<String, dynamic>>.from(data['transactions']);
        } else {
          return [];
        }
      } else {
        throw Exception(
            response.data['message'] ?? 'Failed to fetch points transactions');
      }
    } catch (e) {
      rethrow;
    }
  }
}
