import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum BookingStatus { CONFIRMED, PENDING, CANCELLED }
enum EquipmentType { MIRRORLESS, DSLR, LENS, TRIPOD }

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
}

class CameraEquipment {
  final String id;
  final String name;
  final EquipmentType type;
  final double dailyPrice;
  final String ownerId;

  const CameraEquipment({
    required this.id,
    required this.name,
    required this.type,
    required this.dailyPrice,
    required this.ownerId,
  });

  IconData get icon {
    switch (type) {
      case EquipmentType.MIRRORLESS:
      case EquipmentType.DSLR:
        return Icons.camera_alt;
      case EquipmentType.LENS:
        return Icons.camera;
      case EquipmentType.TRIPOD:
        return Icons.stay_current_portrait;
    }
  }
}

extension DateTimeRangeExtension on DateTimeRange {
  String format() {
    final startFormat = DateFormat('MMM d, y');
    final endFormat = DateFormat('MMM d, y');
    return '${startFormat.format(start)} - ${endFormat.format(end)}';
  }
}

class BookingConfirmationScreen extends StatelessWidget {
  final Booking booking;
  final CameraEquipment equipment;

  const BookingConfirmationScreen({
    super.key,
    required this.booking,
    required this.equipment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF1E3A8A),
                size: 80,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your booking ID: ${booking.id}',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booking Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        color: Colors.grey.shade100,
                        width: 60,
                        height: 60,
                        child: Icon(
                          equipment.icon,
                          color: const Color(0xFF1E3A8A),
                          size: 30,
                        ),
                      ),
                    ),
                    title: Text(equipment.name),
                    subtitle: Text(equipment.type.name),
                  ),
                  const Divider(),
                  _buildDetailRow('Booking Dates', booking.rentalPeriod.format()),
                  _buildDetailRow('Pickup Location', 'John\'s Camera Studio, NYC'),
                  _buildDetailRow('Total Payment', '\$${booking.totalPrice.toStringAsFixed(2)}'),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.credit_card, color: Colors.green),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Payment completed',
                            style: TextStyle(
                              color: Colors.green.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'What\'s next?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            _buildNextStep(
              icon: Icons.calendar_today,
              title: 'Add to calendar',
              subtitle: 'Get reminders for your booking',
            ),
            _buildNextStep(
              icon: Icons.directions,
              title: 'Get directions',
              subtitle: 'Navigate to pickup location',
            ),
            _buildNextStep(
              icon: Icons.message,
              title: 'Contact owner',
              subtitle: 'Ask questions about the equipment',
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/bookings',
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('View My Bookings'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
                child: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStep({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF1E3A8A).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF1E3A8A)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }
}