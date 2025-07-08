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
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      type: EquipmentType.values.firstWhere(
        (e) => e.toString().split('.').last == map['type'],
        orElse: () => EquipmentType.MIRRORLESS,
      ),
      dailyPrice: (map['dailyPrice'] ?? 0.0).toDouble(),
      ownerId: map['ownerId'] ?? '',
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

enum EquipmentType { MIRRORLESS, DSLR, LENS, TRIPOD }