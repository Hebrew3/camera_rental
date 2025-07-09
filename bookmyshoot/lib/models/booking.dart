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
    try {
      // Parse rental period from nested map
      final rentalPeriodMap = map['rentalPeriod'] as Map<String, dynamic>;
      final start = DateTime.parse(rentalPeriodMap['start'] as String);
      final end = DateTime.parse(rentalPeriodMap['end'] as String);
      
      return Booking(
        id: map['id'] as String? ?? '',
        equipmentId: map['equipmentId'] as String? ?? '',
        userId: map['userId'] as String? ?? '',
        rentalPeriod: DateTimeRange(start: start, end: end),
        totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0.0,
        status: BookingStatus.values.firstWhere(
          (e) => e.toString().split('.').last == map['status'],
          orElse: () => BookingStatus.CONFIRMED,
        ),
      );
    } catch (e) {
      throw FormatException('Failed to parse Booking from map: $e');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'equipmentId': equipmentId,
      'userId': userId,
      'rentalPeriod': {
        'start': rentalPeriod.start.toIso8601String(),
        'end': rentalPeriod.end.toIso8601String(),
      },
      'totalPrice': totalPrice,
      'status': status.toString().split('.').last,
    };
  }
}

enum BookingStatus { CONFIRMED, PENDING, CANCELLED }