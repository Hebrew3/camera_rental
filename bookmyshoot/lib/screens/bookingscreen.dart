import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> equipment;

  const BookingScreen({super.key, required this.equipment});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTimeRange? _selectedDates;
  bool _includeInsurance = true;
  String _deliveryOption = 'pickup';
  final _notesController = TextEditingController();

  Future<void> _selectDates(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _selectedDates ??
          DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 1)),
          ),
    );
    if (picked != null) {
      setState(() {
        _selectedDates = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final days = _selectedDates != null
        ? _selectedDates!.end.difference(_selectedDates!.start).inDays
        : 1;

    final basePrice = widget.equipment['price_day'] * days;
    final discount = days > 7 ? basePrice * 0.1 : 0;
    final insurance = _includeInsurance ? 15.0 : 0;
    final deliveryFee = _deliveryOption == 'delivery' ? 10.0 : 0;
    final total = basePrice - discount + insurance + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Dates',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => _selectDates(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDates != null
                          ? '${DateFormat('MMM d').format(_selectedDates!.start)} - ${DateFormat('MMM d, y').format(_selectedDates!.end)} ($days days)'
                          : 'Select rental dates',
                    ),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Delivery Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Pickup from studio'),
                    selected: _deliveryOption == 'pickup',
                    onSelected: (selected) {
                      setState(() {
                        _deliveryOption = 'pickup';
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Delivery (+ \$10)'),
                    selected: _deliveryOption == 'delivery',
                    onSelected: (selected) {
                      setState(() {
                        _deliveryOption = 'delivery';
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Add-ons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            CheckboxListTile(
              title: const Text('Equipment Insurance (\$15)'),
              subtitle: const Text('Covers accidental damage'),
              value: _includeInsurance,
              onChanged: (value) {
                setState(() {
                  _includeInsurance = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 20),
            const Text(
              'Special Requests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: 'Any special instructions...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 3,
            ),
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
                  _buildSummaryRow('Base Price (${days} days)', '\$${basePrice.toStringAsFixed(2)}'),
                  if (discount > 0)
                    _buildSummaryRow('Weekly Discount', '-\$${discount.toStringAsFixed(2)}'),
                  _buildSummaryRow('Insurance', '\$${insurance.toStringAsFixed(2)}'),
                  _buildSummaryRow('Delivery Fee', '\$${deliveryFee.toStringAsFixed(2)}'),
                  const Divider(),
                  _buildSummaryRow(
                    'Total',
                    '\$${total.toStringAsFixed(2)}',
                    isBold: true,
                    isPrimary: true,
                  ),
                ],
              ),
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

          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Proceed to Payment'),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, bool isPrimary = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isPrimary ? const Color(0xFF1E3A8A) : null,
            ),
          ),
        ],
      ),
    );
  }
}