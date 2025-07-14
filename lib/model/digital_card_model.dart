class DigitalCardModel {
  final String id;
  final String orderId;
  final String balance;
  final String acceptById;
  final String acceptByName;
  final String deletedAt;
  final String createdAt;
  final String updatedAt;
  final Order order;

  DigitalCardModel({
    required this.id,
    required this.orderId,
    required this.balance,
    required this.acceptById,
    required this.acceptByName,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.order,
  });

  factory DigitalCardModel.fromJson(Map<String, dynamic> json) {
    return DigitalCardModel(
      id: json['id']?.toString() ?? '',
      orderId: json['order_id']?.toString() ?? '',
      balance: json['balance']?.toString() ?? '',
      acceptById: json['accept_by']['id']?.toString() ?? '',
      acceptByName: json['accept_by']['name']?.toString() ?? '',
      deletedAt: json['deleted_at']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      order: Order.fromJson(json['order'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'balance': balance,
      'accept_by': acceptById,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'order': order.toJson(),
    };
  }

  @override
  String toString() {
    return 'DigitalCardModel(id: $id, orderId: $orderId, balance: $balance, acceptBy: $acceptById, createdAt: $createdAt, updatedAt: $updatedAt, order: $order)';
  }
}

class Order {
  final String id;
  final String routeId;
  final String shippingId;
  final String customerId;
  final String contractId;
  final String driverId;
  final String driverName;
  final String customerName;
  final String shippingAddress;
  final String status;
  final String deliveredQty;
  final String returnQty;
  final String deliveredCardImg;
  final String returnCardImg;
  final String deletedAt;
  final String createdAt;
  final String updatedAt;
  final String type;

  Order({
    required this.id,
    required this.routeId,
    required this.shippingId,
    required this.customerId,
    required this.contractId,
    required this.driverId,
    required this.driverName,
    required this.customerName,
    required this.shippingAddress,
    required this.status,
    required this.deliveredQty,
    required this.returnQty,
    required this.deliveredCardImg,
    required this.returnCardImg,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.type,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id']?.toString() ?? '',
      routeId: json['route_id']?.toString() ?? '',
      shippingId: json['shipping']['id']?.toString() ?? '',
      customerId: json['customers']['id']?.toString() ?? '',
      contractId: json['contract_id']?.toString() ?? '',
      driverId: json['drivers']['id']?.toString() ?? '',
      driverName: json['drivers']['name']?.toString() ?? '',
      customerName: json['customers']['name']?.toString() ?? '',
      shippingAddress: json['shipping']['shipping_address']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      deliveredQty: json['develivered_qty']?.toString() ?? '',
      returnQty: json['return_qty']?.toString() ?? '',
      deliveredCardImg: json['delevered_card_img']?.toString() ?? '',
      returnCardImg: json['return_card_img']?.toString() ?? '',
      deletedAt: json['deleted_at']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
      updatedAt: json['updated_at']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'route_id': routeId,
      'shipping_id': shippingId,
      'customer_id': customerId,
      'contract_id': contractId,
      'driver_id': driverId,
      'status': status,
      'develivered_qty': deliveredQty,
      'return_qty': returnQty,
      'delevered_card_img': deliveredCardImg,
      'return_card_img': returnCardImg,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'type': type,
    };
  }

  @override
  String toString() {
    return 'Order(id: $id, routeId: $routeId, shippingId: $shippingId, customerId: $customerId, driverId: $driverId, status: $status)';
  }
}
