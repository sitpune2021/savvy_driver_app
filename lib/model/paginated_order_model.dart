import 'package:savvy_aqua_delivery/model/order_model.dart';

class PaginatedOrderModel {
  final List<OrderModel> orders;
  final int currentPage;
  final int lastPage;

  PaginatedOrderModel({
    required this.orders,
    required this.currentPage,
    required this.lastPage,
  });

  factory PaginatedOrderModel.fromJson(Map<String, dynamic> json) {
    return PaginatedOrderModel(
      orders: (json["data"] as List<dynamic>)
          .map((e) => OrderModel.fromJson(e))
          .toList(),
      currentPage: json["pagination"]["current_page"],
      lastPage: json["pagination"]["last_page"],
    );
  }
}
