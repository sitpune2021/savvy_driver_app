class DigitalCardModel {
  final String id;
  final String driverId;
  final String orderId;
  final String customerName;
  final String deliverQty;
  final String returnQty;
  final String isDeleted;
  final DateTime createdAt;

  DigitalCardModel({
    required this.id,
    required this.driverId,
    required this.orderId,
    required this.customerName,
    required this.deliverQty,
    required this.returnQty,
    required this.isDeleted,
    required this.createdAt,
  });

  factory DigitalCardModel.fromJson(Map<String, dynamic> json) {
    return DigitalCardModel(
      id: json['id'].toString(),
      driverId: json['driver_id'].toString(),
      orderId: json['order_id'].toString(),
      customerName: json['customer_name'].toString(),
      deliverQty: json['develivered_qty'].toString(),
      returnQty: json['return_qty'].toString(),
      isDeleted: json['isdeleted'].toString(),
      createdAt: DateTime.parse(json['created_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'order_id': orderId,
      'customer_name': customerName,
      'delever_qty': deliverQty,
      'return_qty': returnQty,
      'isdeleted': isDeleted,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'DigitalCardModel(id: $id, driverId: $driverId, orderId: $orderId, deliverQty: $deliverQty, returnQty: $returnQty, isDeleted: $isDeleted, createdAt: $createdAt)';
  }
}
