import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:petapp/core/services/api_client.dart';
import 'package:petapp/core/utils/api_constants.dart';
import 'package:petapp/core/utils/file_utils.dart';
import 'package:path/path.dart' as p;
import '../models/medical_record_model.dart';
import '../models/medical_record_list_response.dart';
import '../../domain/entities/medical_record_entity.dart';

abstract class MedicalRecordRemoteDataSource {
  Future<MedicalRecordListResponse> getMedicalRecords({
    required String petId,
    int page = 1,
    int limit = 10,
    MedicalRecordEventType? eventType,
    MedicalRecordSource? source,
    DateTime? from,
    DateTime? to,
  });

  Future<MedicalRecordModel> createMedicalRecord({
    required String petId,
    required MedicalRecordEventType eventType,
    required Map<String, dynamic> payload,
    DateTime? occurredAt,
    String? appointmentId,
    String? vaccinationScheduleId,
    List<String>? files,
  });

  Future<Map<String, dynamic>> getShareLink(String petId);
}

class MedicalRecordRemoteDataSourceImpl implements MedicalRecordRemoteDataSource {
  final ApiClient apiClient;

  MedicalRecordRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<MedicalRecordListResponse> getMedicalRecords({
    required String petId,
    int page = 1,
    int limit = 10,
    MedicalRecordEventType? eventType,
    MedicalRecordSource? source,
    DateTime? from,
    DateTime? to,
  }) async {
    final Map<String, dynamic> queryParams = {
      'page': page,
      'limit': limit,
    };

    if (eventType != null) queryParams['eventType'] = eventType.name;
    if (source != null) queryParams['source'] = source.name;
    if (from != null) queryParams['from'] = from.toIso8601String();
    if (to != null) queryParams['to'] = to.toIso8601String();

    final response = await apiClient.get(
      ApiConstants.medicalRecordsEndpoint(petId),
      queryParameters: queryParams,
    );

    if (response.data != null && response.data['success'] == true) {
      return MedicalRecordListResponse.fromJson(response.data['data']);
    } else {
      throw Exception(response.data?['message'] ?? 'Failed to load medical records');
    }
  }

  @override
  Future<MedicalRecordModel> createMedicalRecord({
    required String petId,
    required MedicalRecordEventType eventType,
    required Map<String, dynamic> payload,
    DateTime? occurredAt,
    String? appointmentId,
    String? vaccinationScheduleId,
    List<String>? files,
  }) async {
    final Map<String, dynamic> dataJson = {
      'eventType': eventType.name,
      'payload': payload,
    };

    if (occurredAt != null) dataJson['occurredAt'] = occurredAt.toIso8601String();
    if (appointmentId != null) dataJson['appointmentId'] = appointmentId;
    if (vaccinationScheduleId != null) dataJson['vaccinationScheduleId'] = vaccinationScheduleId;

    dynamic requestData;

    if (files != null && files.isNotEmpty) {
      final List<MultipartFile> multipartFiles = [];
      for (String filePath in files) {
        // Compress images before uploading to avoid 413 Payload Too Large
        final File originalFile = File(filePath);
        final File processedFile = await FileUtils.compressImage(originalFile);

        multipartFiles.add(await MultipartFile.fromFile(
          processedFile.path,
          filename: p.basename(filePath),
        ));
      }

      requestData = FormData.fromMap({
        'data': jsonEncode(dataJson),
        'files': multipartFiles,
      });
    } else {
      requestData = dataJson;
    }

    final response = await apiClient.post(
      ApiConstants.medicalRecordsEndpoint(petId),
      data: requestData,
      queryParameters: {'eventType': eventType.name},
    );

    if (response.data != null && response.data['success'] == true) {
      return MedicalRecordModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data?['message'] ?? 'Failed to create medical record');
    }
  }

  @override
  Future<Map<String, dynamic>> getShareLink(String petId) async {
    final response = await apiClient.get(
      ApiConstants.shareLinkEndpoint(petId),
    );

    if (response.data != null && response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw Exception(response.data?['message'] ?? 'Failed to get share link');
    }
  }
}
