import 'package:flutter/material.dart';

class Booking {
  final String id;
  final String equipmentId;
  final String userId;
  final DateTimeRange rentalPeriod;
  final double totalPrice;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.equipmentId,
    required this.userId,
    required this.rentalPeriod,
    required this.totalPrice,
    required this.status,
  });

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'] ?? '',
      equipmentId: map['equipmentId'] ?? '',
      userId: map['userId'] ?? '',
      rentalPeriod: map['rentalPeriod'] as DateTimeRange,
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => BookingStatus.CONFIRMED,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'equipmentId': equipmentId,
      'userId': userId,
      'rentalPeriod': rentalPeriod,
      'totalPrice': totalPrice,
      'status': status.toString().split('.').last,
    };
  }
}

enum BookingStatus { CONFIRMED, PENDING, CANCELLED }