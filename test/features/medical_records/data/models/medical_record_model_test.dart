import 'package:flutter_test/flutter_test.dart';
import 'package:petapp/features/medical_records/data/models/medical_record_model.dart';
import 'package:petapp/features/medical_records/domain/entities/medical_record_entity.dart';

void main() {
  group('MedicalRecordModel', () {
    final tJson = {
      "id": "1",
      "petId": "pet123",
      "source": "OWNER",
      "eventType": "HEALTH_EVENT",
      "occurredAt": "2026-03-24T09:15:00.000Z",
      "payload": {
        "eventName": "Digestive Issue",
        "notes": "Symptoms: Lethargy, loss of appetite."
      },
      "appointmentId": null,
      "vaccinationScheduleId": null,
      "createdByUserId": "user1",
      "vetId": null,
      "createdAt": "2026-03-24T10:00:00.000Z",
      "updatedAt": "2026-03-24T10:00:00.000Z",
      "deletedAt": null
    };

    test('should return a valid model from JSON', () {
      final result = MedicalRecordModel.fromJson(tJson);

      expect(result.id, "1");
      expect(result.eventType, MedicalRecordEventType.HEALTH_EVENT);
      expect(result.source, MedicalRecordSource.OWNER);
      expect(result.payload['eventName'], "Digestive Issue");
    });

    test('should return a JSON map containing proper data', () {
      final model = MedicalRecordModel.fromJson(tJson);
      final result = model.toJson();

      expect(result['id'], "1");
      expect(result['eventType'], "HEALTH_EVENT");
      expect(result['source'], "OWNER");
    });
  });
}
