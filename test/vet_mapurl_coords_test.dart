import 'package:flutter_test/flutter_test.dart';
import 'package:petapp/features/vets/models/vet_model.dart';

void main() {
  group('VetModel mapUrl coordinate parsing', () {
    test('parses q=lat,lng', () {
      final vet = VetModel.fromJson({
        'id': '1',
        'name': 'V',
        'specialization': 'Pets',
        'bio': '',
        'experience': 1,
        'rating': 0,
        'consultationFee': 10,
        'distance': '1km',
        'images': [],
        'location': {'address': 'x'},
        'mapUrl': 'https://www.google.com/maps?q=30.1,31.2',
      });

      expect(vet.latitude, closeTo(30.1, 1e-9));
      expect(vet.longitude, closeTo(31.2, 1e-9));
    });

    test('parses search query=lat,lng', () {
      final vet = VetModel.fromJson({
        'id': '1',
        'name': 'V',
        'specialization': 'Pets',
        'bio': '',
        'experience': 1,
        'rating': 0,
        'consultationFee': 10,
        'distance': '1km',
        'images': [],
        'location': {'address': 'x'},
        'mapUrl': 'https://www.google.com/maps/search/?api=1&query=30.123,31.456',
      });

      expect(vet.latitude, closeTo(30.123, 1e-9));
      expect(vet.longitude, closeTo(31.456, 1e-9));
    });

    test('parses /@lat,lng,zoom', () {
      final vet = VetModel.fromJson({
        'id': '1',
        'name': 'V',
        'specialization': 'Pets',
        'bio': '',
        'experience': 1,
        'rating': 0,
        'consultationFee': 10,
        'distance': '1km',
        'images': [],
        'location': {'address': 'x'},
        'mapUrl': 'https://www.google.com/maps/@30.111,31.222,15z',
      });

      expect(vet.latitude, closeTo(30.111, 1e-9));
      expect(vet.longitude, closeTo(31.222, 1e-9));
    });

    test('returns null when no coordinates exist in url', () {
      final vet = VetModel.fromJson({
        'id': '1',
        'name': 'V',
        'specialization': 'Pets',
        'bio': '',
        'experience': 1,
        'rating': 0,
        'consultationFee': 10,
        'distance': '1km',
        'images': [],
        'location': {'address': 'x'},
        'mapUrl': 'https://maps.app.goo.gl/JdhyQ25JpUzDMaXE7',
      });

      expect(vet.latitude, isNull);
      expect(vet.longitude, isNull);
    });
  });
}
