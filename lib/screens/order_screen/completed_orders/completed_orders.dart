import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/screens/order_screen/completed_order_details/completed_order_details.dart';
import 'package:savvy_aqua_delivery/screens/track_order_screen/track_order.dart';

class CompletedOrders extends StatefulWidget {
  const CompletedOrders({super.key});

  @override
  State<CompletedOrders> createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {
  Future<void> _refreshData() async {
    // Refresh the appointments

    // Call setState to rebuild the widget tree with updated data
    setState(() {});
    print(
        "*******************************************************REFRESHED*******************************");
  }

  final List<Map<String, String>> orders = [
    {
      "id": "#ORD97",
      "name": "Prajwal Punekar",
      "address": "Santosh Nagar, Chinchwad Pune",
      "date": "17 Feb 2025",
      "quantity": "20 Bottles",
      "status": "Completed",
    },
    {
      "id": "#ORD98",
      "name": "Rahul Sharma",
      "address": "Wakad, Pune",
      "date": "18 Feb 2025",
      "quantity": "15 Bottles",
      "status": "Completed",
    },
    {
      "id": "#ORD99",
      "name": "Neha Verma",
      "address": "Hinjewadi, Pune",
      "date": "19 Feb 2025",
      "quantity": "25 Bottles",
      "status": "Completed",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: _refreshData,
        child: ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 200),
                          reverseDuration: const Duration(milliseconds: 200),
                          child: CompletedOrderDetails()));
                },
                child: OrderCard(order: orders[index]));
          },
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Map<String, String> order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order["id"]!,
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order["name"]!,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(order["date"]!,
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue, size: 18),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(order["address"]!,
                      style: const TextStyle(color: Colors.black54)),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Quantity", style: TextStyle(color: Colors.black54)),
                Text(order["quantity"]!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Delivery Status",
                    style: TextStyle(color: Colors.black54)),
                Row(
                  children: [
                    const Icon(Icons.circle, color: Colors.green, size: 12),
                    const SizedBox(width: 5),
                    Text(order["status"]!,
                        style: const TextStyle(color: Colors.black)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
