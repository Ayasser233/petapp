import 'medical_record_model.dart';

class MedicalRecordListResponse {
  final List<MedicalRecordModel> records;
  final bool hasNextPage;

  MedicalRecordListResponse({
    required this.records,
    required this.hasNextPage,
  });

  factory MedicalRecordListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> data = json['data'] ?? [];
    return MedicalRecordListResponse(
      records: data.map((item) => MedicalRecordModel.fromJson(item)).toList(),
      hasNextPage: json['hasNextPage'] ?? false,
    );
  }
}
