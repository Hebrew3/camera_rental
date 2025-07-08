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

class PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E3A8A).withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF1E3A8A) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF1E3A8A) : null),
            const SizedBox(width: 10),
            Text(title, style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF1E3A8A) : null,
            )),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF1E3A8A)),
          ],
        ),
      ),
    );
  }
}

class PaymentScreen extends StatefulWidget {
  final CameraEquipment equipment;
  final Booking bookingDetails;

  const PaymentScreen({
    super.key,
    required this.equipment,
    required this.bookingDetails,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'card';
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            PaymentMethodCard(
              icon: Icons.credit_card,
              title: 'Credit/Debit Card',
              isSelected: _selectedPaymentMethod == 'card',
              onTap: () => setState(() => _selectedPaymentMethod = 'card'),
            ),
            const SizedBox(height: 10),
            PaymentMethodCard(
              icon: Icons.account_balance_wallet,
              title: 'UPI Payment',
              isSelected: _selectedPaymentMethod == 'upi',
              onTap: () => setState(() => _selectedPaymentMethod = 'upi'),
            ),
            const SizedBox(height: 10),
            PaymentMethodCard(
              icon: Icons.account_balance,
              title: 'Net Banking',
              isSelected: _selectedPaymentMethod == 'netbanking',
              onTap: () => setState(() => _selectedPaymentMethod = 'netbanking'),
            ),
            const SizedBox(height: 10),
            PaymentMethodCard(
              icon: Icons.wallet,
              title: 'Wallet',
              isSelected: _selectedPaymentMethod == 'wallet',
              onTap: () => setState(() => _selectedPaymentMethod = 'wallet'),
            ),
            const SizedBox(height: 20),
            if (_selectedPaymentMethod == 'card') ...[
              const Text(
                'Card Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _cardController,
                decoration: InputDecoration(
                  labelText: 'Card Number',
                  hintText: '1234 5678 9012 3456',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _expiryController,
                      decoration: InputDecoration(
                        labelText: 'Expiry Date',
                        hintText: 'MM/YY',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _cvvController,
                      decoration: InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                    ),
                  ),
                ],
              ),
            ] else if (_selectedPaymentMethod == 'upi') ...[
              const Text(
                'UPI ID',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Enter UPI ID',
                  hintText: 'yourname@upi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
            const SizedBox(height: 20),
            const Text(
              'Order Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        color: Colors.grey.shade200,
                        width: 60,
                        height: 60,
                        child: Icon(
                          widget.equipment.icon,
                          color: const Color(0xFF1E3A8A),
                          size: 30,
                        ),
                      ),
                    ),
                    title: Text(widget.equipment.name),
                    subtitle: Text(widget.bookingDetails.rentalPeriod.format()),
                    trailing: Text(
                      '\$${widget.bookingDetails.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total'),
                      Text(
                        '\$${widget.bookingDetails.totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A8A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            CheckboxListTile(
              title: const Text('I agree to the terms and conditions'),
              value: true,
              onChanged: (value) {},
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          onPressed: () {
            // Process payment
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookingConfirmationScreen(
                  booking: widget.bookingDetails,
                  equipment: widget.equipment,
                ),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Pay Now'),
        ),
      ),
    );
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