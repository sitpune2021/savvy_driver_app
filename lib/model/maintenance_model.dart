class MaintenanceModel {
  final String id;
  final String driverId;
  final String vehicleNo;
  final String maintenanceType;
  final String maintenanceDescription;
  final String totalAmount;
  final String status;
  final String createdAt;
  final String filepath;

  MaintenanceModel({
    required this.id,
    required this.driverId,
    required this.vehicleNo,
    required this.maintenanceType,
    required this.maintenanceDescription,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    required this.filepath,
  });

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) {
    return MaintenanceModel(
      id: json['id'].toString(),
      driverId: json['driver_id'].toString(),
      vehicleNo: json['vehicle_no'].toString(),
      maintenanceType: json['maintenance_type'].toString(),
      maintenanceDescription: json['description'].toString(),
      totalAmount: json['amount'].toString(),
      status: json['status'].toString(),
      createdAt: json['created_at'].toString(),
      filepath: json['bill'].toString(),
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
      // 'isdeleted': isDeleted,
      'created_at': createdAt,
      'bill': filepath
    };
  }
}
