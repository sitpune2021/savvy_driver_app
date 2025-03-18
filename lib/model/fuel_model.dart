class FuelModel {
  final String id;
  final String driverId;
  final String date;
  final String vehicleNo;
  final String price;
  final String totalFuel;
  final String isDeleted;
  final String createdAt;
  final String filepath1;
  final String filepath2;

  FuelModel({
    required this.id,
    required this.driverId,
    required this.date,
    required this.vehicleNo,
    required this.price,
    required this.totalFuel,
    required this.isDeleted,
    required this.createdAt,
    required this.filepath1,
    required this.filepath2,
  });

  // Factory method to create a FuelModel from a JSON map
  factory FuelModel.fromJson(Map<String, dynamic> json) {
    return FuelModel(
      id: json['id'] ?? '',
      driverId: json['driver_id'] ?? '',
      date: json['date'] ?? '',
      vehicleNo: json['vehical_no'] ?? '',
      price: json['price'] ?? '',
      totalFuel: json['total_fule'] ?? '',
      isDeleted: json['isdeleted'] ?? '',
      createdAt: json['created_at'] ?? '',
      filepath1: json['filepath1'] ?? '',
      filepath2: json['filepath2'] ?? '',
    );
  }

  // Method to convert FuelModel instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'date': date,
      'vehical_no': vehicleNo,
      'price': price,
      'total_fule': totalFuel,
      'isdeleted': isDeleted,
      'created_at': createdAt,
      'filepath1': filepath1,
      'filepath2': filepath2,
    };
  }

  @override
  String toString() {
    return 'FuelModel(id: $id, driverId: $driverId, date: $date, vehicleNo: $vehicleNo, price: $price, totalFuel: $totalFuel, isDeleted: $isDeleted, createdAt: $createdAt filepath2: $filepath2,filepath1: $filepath1)';
  }
}
