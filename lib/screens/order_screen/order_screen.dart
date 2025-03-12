import 'package:flutter/material.dart';
import 'package:savvy_aqua_delivery/screens/order_screen/completed_orders/completed_orders.dart';
import 'package:savvy_aqua_delivery/screens/order_screen/ongoing_orders/ongoing_orders.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Orders", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          tabs: const [
            Tab(text: "Ongoing Orders"),
            Tab(text: "Completed Orders"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          OngoingOrders(), // Ongoing Orders
          CompletedOrders() // Placeholder for completed orders
        ],
      ),
    );
  }
}
