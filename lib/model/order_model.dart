class OrderModel {
  final String id;
  final String driverId;
  final String orderId;
  final String customerId;
  final String customerName;
  final String customerAddress;
  final String qty;
  final String status;
  final String isDeleted;
  final String createdAt;

  OrderModel({
    required this.id,
    required this.driverId,
    required this.orderId,
    required this.customerId,
    required this.customerName,
    required this.customerAddress,
    required this.qty,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      driverId: json['driver_id'],
      orderId: json['order_id'],
      customerId: json['customer_id'],
      customerName: json['customer_name'],
      customerAddress: json['customer_address'],
      qty: json['qty'],
      status: json['status'],
      isDeleted: json['isdeleted'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driver_id': driverId,
      'order_id': orderId,
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_address': customerAddress,
      'qty': qty,
      'status': status,
      'isdeleted': isDeleted,
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, driverId: $driverId, orderId: $orderId, customerId: $customerId, customerName: $customerName, customerAddress: $customerAddress, qty: $qty, status: $status, isDeleted: $isDeleted, createdAt: $createdAt)';
  }
}
