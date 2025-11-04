import 'package:petapp/features/appointments/domain/entities/appointment_entity.dart';

class AppointmentModel {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final String status; // PENDING, CONFIRMED, COMPLETED, CANCELLED
  final String? reasonForVisit;
  final double consultationFee;
  final double discount;
  final double finalAmount;
  final int pointsUsed;
  final int pointsEarned;
  final int? rating;
  final String? reviewComment;
  final DateTime? reviewedAt;
  final String? coupons;
  final double couponDiscount;
  final double pointsDiscount;
  final String? hash; // Verification code for vet users
  final AppointmentPet? pet;
  final AppointmentVet? vet;

  AppointmentModel({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.reasonForVisit,
    required this.consultationFee,
    required this.discount,
    required this.finalAmount,
    required this.pointsUsed,
    required this.pointsEarned,
    this.rating,
    this.reviewComment,
    this.reviewedAt,
    this.coupons,
    required this.couponDiscount,
    required this.pointsDiscount,
    this.hash,
    this.pet,
    this.vet,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    // API returns times in UTC, we need to convert to local timezone for display
    final startTimeStr = json['startTime'] as String;
    final endTimeStr = json['endTime'] as String;

    print('🕐 Parsing appointment times:');
    print('   Raw startTime from API: $startTimeStr');
    print('   Raw endTime from API: $endTimeStr');

    // Parse as UTC and convert to local timezone
    final parsedStart = DateTime.parse(startTimeStr).toLocal();
    final parsedEnd = DateTime.parse(endTimeStr).toLocal();

    print('   Parsed startTime (UTC): ${DateTime.parse(startTimeStr)}');
    print('   Converted to local: $parsedStart');
    print('   Parsed endTime (UTC): ${DateTime.parse(endTimeStr)}');
    print('   Converted to local: $parsedEnd');

    return AppointmentModel(
      id: json['id'] ?? '',
      startTime: parsedStart,
      endTime: parsedEnd,
      status: json['status'] ?? 'PENDING',
      reasonForVisit: json['reasonForVisit'],
      consultationFee:
          double.tryParse(json['consultationFee']?.toString() ?? '0') ?? 0.0,
      discount: (json['discount'] ?? 0).toDouble(),
      finalAmount:
          double.tryParse(json['finalAmount']?.toString() ?? '0') ?? 0.0,
      pointsUsed: json['pointsUsed'] ?? 0,
      pointsEarned: json['pointsEarned'] ?? 0,
      rating: json['rating'],
      reviewComment: json['reviewComment'],
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'] as String).toLocal()
          : null,
      coupons: json['coupons'],
      couponDiscount: (json['couponDiscount'] ?? 0).toDouble(),
      pointsDiscount: (json['pointsDiscount'] ?? 0).toDouble(),
      hash: json['hash']?.toString(),
      pet: json['pet'] != null ? AppointmentPet.fromJson(json['pet']) : null,
      vet: json['vet'] != null ? AppointmentVet.fromJson(json['vet']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
      'reasonForVisit': reasonForVisit,
      'consultationFee': consultationFee.toString(),
      'discount': discount,
      'finalAmount': finalAmount.toString(),
      'pointsUsed': pointsUsed,
      'pointsEarned': pointsEarned,
      'rating': rating,
      'reviewComment': reviewComment,
      'reviewedAt': reviewedAt?.toIso8601String(),
      'coupons': coupons,
      'couponDiscount': couponDiscount,
      'pointsDiscount': pointsDiscount,
      'hash': hash,
      'pet': pet?.toJson(),
      'vet': vet?.toJson(),
    };
  }

  // Helper methods for UI display
  String get formattedDate {
    return '${startTime.day}/${startTime.month}/${startTime.year}';
  }

  String get formattedStartTime {
    final hour = startTime.hour > 12
        ? startTime.hour - 12
        : (startTime.hour == 0 ? 12 : startTime.hour);
    final period = startTime.hour >= 12 ? 'PM' : 'AM';
    final minute = startTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  String get formattedEndTime {
    final hour = endTime.hour > 12
        ? endTime.hour - 12
        : (endTime.hour == 0 ? 12 : endTime.hour);
    final period = endTime.hour >= 12 ? 'PM' : 'AM';
    final minute = endTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  String get formattedTimeRange {
    return '$formattedStartTime - $formattedEndTime';
  }

  // Localized time formatting for Arabic/English
  String getLocalizedStartTime(String languageCode) {
    final hour = startTime.hour > 12
        ? startTime.hour - 12
        : (startTime.hour == 0 ? 12 : startTime.hour);
    final period = startTime.hour >= 12
        ? (languageCode == 'ar' ? 'م' : 'PM')
        : (languageCode == 'ar' ? 'ص' : 'AM');
    final minute = startTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  String getLocalizedEndTime(String languageCode) {
    final hour = endTime.hour > 12
        ? endTime.hour - 12
        : (endTime.hour == 0 ? 12 : endTime.hour);
    final period = endTime.hour >= 12
        ? (languageCode == 'ar' ? 'م' : 'PM')
        : (languageCode == 'ar' ? 'ص' : 'AM');
    final minute = endTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  String getLocalizedTimeRange(String languageCode) {
    return '${getLocalizedStartTime(languageCode)} - ${getLocalizedEndTime(languageCode)}';
  }

  // Status helpers
  bool get isPending => status == 'PENDING';
  bool get isConfirmed => status == 'CONFIRMED';
  bool get isCompleted => status == 'COMPLETED';
  bool get isCancelled => status == 'CANCELLED';

  bool get canCancel => isPending || isConfirmed;
  bool get canReview => isCompleted && rating == null;
  bool get canReschedule => isPending || isConfirmed;

  AppointmentModel copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    String? reasonForVisit,
    double? consultationFee,
    double? discount,
    double? finalAmount,
    int? pointsUsed,
    int? pointsEarned,
    int? rating,
    String? reviewComment,
    DateTime? reviewedAt,
    String? coupons,
    double? couponDiscount,
    double? pointsDiscount,
    String? hash,
    AppointmentPet? pet,
    AppointmentVet? vet,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      reasonForVisit: reasonForVisit ?? this.reasonForVisit,
      consultationFee: consultationFee ?? this.consultationFee,
      discount: discount ?? this.discount,
      finalAmount: finalAmount ?? this.finalAmount,
      pointsUsed: pointsUsed ?? this.pointsUsed,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      rating: rating ?? this.rating,
      reviewComment: reviewComment ?? this.reviewComment,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      coupons: coupons ?? this.coupons,
      couponDiscount: couponDiscount ?? this.couponDiscount,
      pointsDiscount: pointsDiscount ?? this.pointsDiscount,
      hash: hash ?? this.hash,
      pet: pet ?? this.pet,
      vet: vet ?? this.vet,
    );
  }

  // Convert model to entity
  AppointmentEntity toEntity() {
    return AppointmentEntity(
      id: id,
      startTime: startTime,
      endTime: endTime,
      status: status,
      reasonForVisit: reasonForVisit,
      consultationFee: consultationFee,
      discount: discount,
      finalAmount: finalAmount,
      pointsUsed: pointsUsed,
      pointsEarned: pointsEarned,
      rating: rating,
      reviewComment: reviewComment,
      reviewedAt: reviewedAt,
      coupons: coupons,
      couponDiscount: couponDiscount,
      pointsDiscount: pointsDiscount,
      hash: hash,
      pet: pet != null
          ? AppointmentPetEntity(
              id: pet!.id,
              name: pet!.name,
              image: pet!.type, // Mapping type to image field
            )
          : null,
      vet: vet != null
          ? AppointmentVetEntity(
              id: vet!.id,
              branchName: vet!.branchName,
              description: vet!.description,
              // Note: location, latitude, longitude not available in model
            )
          : null,
    );
  }

  // Convert entity to model
  static AppointmentModel fromEntity(AppointmentEntity entity) {
    return AppointmentModel(
      id: entity.id,
      startTime: entity.startTime,
      endTime: entity.endTime,
      status: entity.status,
      reasonForVisit: entity.reasonForVisit,
      consultationFee: entity.consultationFee,
      discount: entity.discount,
      finalAmount: entity.finalAmount,
      pointsUsed: entity.pointsUsed,
      pointsEarned: entity.pointsEarned,
      rating: entity.rating,
      reviewComment: entity.reviewComment,
      reviewedAt: entity.reviewedAt,
      coupons: entity.coupons,
      couponDiscount: entity.couponDiscount,
      pointsDiscount: entity.pointsDiscount,
      pet: entity.pet != null
          ? AppointmentPet(
              id: entity.pet!.id,
              name: entity.pet!.name,
              type: entity.pet!.image, // Mapping image back to type field
            )
          : null,
      vet: entity.vet != null
          ? AppointmentVet(
              id: entity.vet!.id,
              branchName: entity.vet!.branchName,
              description: entity.vet!.description,
              rating: 0.0, // Default value as entity doesn't have rating
              consultationFee:
                  entity.consultationFee, // Use appointment's consultationFee
            )
          : null,
    );
  }
}

class AppointmentVet {
  final String id;
  final String branchName;
  final String? description;
  final double rating;
  final double consultationFee;

  AppointmentVet({
    required this.id,
    required this.branchName,
    this.description,
    required this.rating,
    required this.consultationFee,
  });

  factory AppointmentVet.fromJson(Map<String, dynamic> json) {
    return AppointmentVet(
      id: json['id'] ?? '',
      branchName: json['branchName'] ?? '',
      description: json['description'],
      rating: (json['rating'] ?? 0).toDouble(),
      consultationFee: (json['consultationFee'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branchName': branchName,
      'description': description,
      'rating': rating,
      'consultationFee': consultationFee,
    };
  }
}

class AppointmentPet {
  final String id;
  final String name;
  final String? type;
  final String? breed;

  AppointmentPet({
    required this.id,
    required this.name,
    this.type,
    this.breed,
  });

  factory AppointmentPet.fromJson(Map<String, dynamic> json) {
    return AppointmentPet(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: json['type'],
      breed: json['breed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
    };
  }
}
