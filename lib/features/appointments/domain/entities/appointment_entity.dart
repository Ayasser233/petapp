import 'package:equatable/equatable.dart';

/// Pure domain entity representing an appointment
///
/// This is independent of any framework or external library
/// No JSON serialization logic here
class AppointmentEntity extends Equatable {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final String status;
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
  final AppointmentPetEntity? pet;
  final AppointmentVetEntity? vet;

  const AppointmentEntity({
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

  @override
  List<Object?> get props => [
        id,
        startTime,
        endTime,
        status,
        reasonForVisit,
        consultationFee,
        discount,
        finalAmount,
        pointsUsed,
        pointsEarned,
        rating,
        reviewComment,
        reviewedAt,
        coupons,
        couponDiscount,
        pointsDiscount,
        hash,
        pet,
        vet,
      ];
}

/// Vet information in appointment
class AppointmentVetEntity extends Equatable {
  final String id;
  final String branchName;
  final String? description;
  final String? location;
  final double? latitude;
  final double? longitude;

  const AppointmentVetEntity({
    required this.id,
    required this.branchName,
    this.description,
    this.location,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
        id,
        branchName,
        description,
        location,
        latitude,
        longitude,
      ];
}

/// Pet information in appointment
class AppointmentPetEntity extends Equatable {
  final String id;
  final String name;
  final String? image;

  const AppointmentPetEntity({
    required this.id,
    required this.name,
    this.image,
  });

  @override
  List<Object?> get props => [id, name, image];
}
