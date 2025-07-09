// camera_equipment.dart
enum EquipmentType { MIRRORLESS, DSLR, LENS, TRIPOD }

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

  factory CameraEquipment.fromMap(Map<String, dynamic> map) {
    return CameraEquipment(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      type: EquipmentType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => EquipmentType.MIRRORLESS,
      ),
      dailyPrice: (map['dailyPrice'] as num?)?.toDouble() ?? 0.0,
      ownerId: map['ownerId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'dailyPrice': dailyPrice,
      'ownerId': ownerId,
    };
  }
}