class MaintenanceModel {
  final String id;
  final String driverId;
  final String vehicleNo;
  final String maintenanceType;
  final String maintenanceDescription;
  final String totalAmount;
  final String isDeleted;
  final String createdAt;

  MaintenanceModel({
    required this.id,
    required this.driverId,
    required this.vehicleNo,
    required this.maintenanceType,
    required this.maintenanceDescription,
    required this.totalAmount,
    required this.isDeleted,
    required this.createdAt,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json['id'],
      driverId: json['driver_id'],
      vehicleNo: json['vehical_no'],
      maintenanceType: json['maintenance_type'],
      maintenanceDescription: json['maintenance_desciption'],
      totalAmount: json['total_amount'],
      isDeleted: json['isdeleted'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'vehical_no': vehicleNo,
      'maintenance_type': maintenanceType,
      'maintenance_desciption': maintenanceDescription,
      'total_amount': totalAmount,
      'isdeleted': isDeleted,
      'created_at': createdAt,
    };
  }
}
