import 'package:dio/dio.dart';
import '../../../../core/services/api_client.dart';
import '../../../../core/utils/api_constants.dart';
import '../models/vaccination_category_model.dart';
import '../models/vaccination_series_model.dart';
import '../models/medical_sheet_model.dart';

/// Vaccination API Service
///
/// Handles all HTTP calls to the vaccination endpoints
class VaccinationApiService {
  final ApiClient apiClient;

  VaccinationApiService({required this.apiClient});

  /// Get eligible vaccine categories for a pet
  ///
  /// GET /vaccination/eligible-categories?petId=X
  Future<List<VaccinationCategoryModel>> getEligibleVaccines(
      String petId) async {
    try {
      final response = await apiClient.get(
        ApiConstants.vaccinationEligibleCategoriesEndpoint,
        queryParameters: {'petId': petId},
      );

      // Backend response format:
      // {
      //   "success": true,
      //   "message": "...",
      //   "data": {
      //     "petId": "...",
      //     "species": "Dog",
      //     "ageInDays": 2116,
      //     "eligibleCategories": [...]
      //   }
      // }

      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        if (data != null && data['eligibleCategories'] is List) {
          return (data['eligibleCategories'] as List)
              .map((json) => VaccinationCategoryModel.fromJson(json))
              .toList();
        }
      }

      throw DioException(
        requestOptions: RequestOptions(
            path: ApiConstants.vaccinationEligibleCategoriesEndpoint),
        error:
            'Invalid response format: expected data.eligibleCategories array',
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Create a new vaccination series
  ///
  /// POST /vaccination/series
  Future<VaccinationSeriesModel> createVaccineSeries({
    required String petId,
    required String vaccineType,
    required List<Map<String, dynamic>> doses,
  }) async {
    try {
      final response = await apiClient.post(
        ApiConstants.vaccinationSeriesEndpoint,
        data: {
          'petId': petId,
          'vaccineType': vaccineType,
          'doses': doses,
        },
      );

      return VaccinationSeriesModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Mark a dose as complete in a vaccination series
  ///
  /// POST /vaccination/series/:seriesId/mark-dose-complete
  Future<VaccinationSeriesModel> markDoseComplete({
    required String seriesId,
    required int doseNumber,
    required DateTime administeredAt,
    String? administeredBy,
    String? batchNumber,
    String? notes,
  }) async {
    try {
      final response = await apiClient.patch(
        ApiConstants.vaccinationMarkDoseCompleteEndpoint(seriesId),
        data: {
          'doseNumber': doseNumber,
          'administeredAt': administeredAt
              .toIso8601String()
              .split('T')[0], // Format as YYYY-MM-DD
          if (administeredBy != null) 'administeredBy': administeredBy,
          if (batchNumber != null) 'batchNumber': batchNumber,
          if (notes != null) 'notes': notes,
        },
      );

      return VaccinationSeriesModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Mark annual booster as complete in a vaccination series
  ///
  /// PATCH /vaccination/series/:seriesId/mark-annual-booster-complete
  Future<VaccinationSeriesModel> markAnnualBoosterComplete({
    required String seriesId,
    required DateTime completedDate,
    String? administeredBy,
    String? batchNumber,
    String? notes,
  }) async {
    try {
      final response = await apiClient.patch(
        ApiConstants.vaccinationMarkAnnualBoosterCompleteEndpoint(seriesId),
        data: {
          'administeredAt': completedDate
              .toIso8601String()
              .split('T')[0], // Format as YYYY-MM-DD to match backend expectation
          if (administeredBy != null) 'administeredBy': administeredBy,
          if (batchNumber != null) 'batchNumber': batchNumber,
          if (notes != null) 'notes': notes,
        },
      );

      return VaccinationSeriesModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete a vaccination series
  ///
  /// DELETE /vaccination/series/:seriesId
  Future<void> deleteVaccinationSeries({
    required String seriesId,
  }) async {
    try {
      await apiClient.delete(
        ApiConstants.vaccinationDeleteSeriesEndpoint(seriesId),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get complete medical sheet for a pet
  ///
  /// GET /vaccination/schedules/pet/:petId/medical-sheet
  /// Backend response format:
  /// {
  ///   "success": true,
  ///   "message": "Medical sheet retrieved successfully",
  ///   "data": { ... }
  /// }
  Future<MedicalSheetModel> getMedicalSheet(String petId) async {
    try {
      final response = await apiClient.get(
        ApiConstants.vaccinationMedicalSheetEndpoint(petId),
      );

      // Extract data from wrapped response
      if (response.data is Map<String, dynamic>) {
        final data = response.data['data'];
        if (data != null) {
          return MedicalSheetModel.fromJson(data);
        }
      }

      throw DioException(
        requestOptions: RequestOptions(
          path: ApiConstants.vaccinationMedicalSheetEndpoint(petId),
        ),
        error: 'Invalid response format: expected data object',
      );
    } catch (e) {
      rethrow;
    }
  }
}
