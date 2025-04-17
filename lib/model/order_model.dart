class OrderModel {
  final String id;
  final String driverId;
  final String orderId;
  final String customerId;
  final String customerName;
  final String customerAddress;
  final String qty;
  final String status;

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
    required this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'].toString(),
      driverId: json['driver_id'].toString(),
      orderId: json['id'].toString(),
      customerId: json['customer_id'].toString(),
      customerName: json['customer_name'].toString(),
      customerAddress: json['shipping_address'].toString(),
      qty: json['develivered_qty'].toString(),
      status: json['status'].toString(),
      createdAt: json['created_at'].toString(),
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
      'created_at': createdAt,
    };
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, driverId: $driverId, orderId: $orderId, customerId: $customerId, customerName: $customerName, customerAddress: $customerAddress, qty: $qty, status: $status, createdAt: $createdAt)';
  }
}
