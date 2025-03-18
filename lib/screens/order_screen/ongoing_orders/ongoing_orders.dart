import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/model/order_model.dart';
import 'package:savvy_aqua_delivery/screens/all_orders_map_screen/all_orders_map_screen.dart';
import 'package:savvy_aqua_delivery/screens/order_screen/widget/order_card.dart';
import 'package:savvy_aqua_delivery/screens/track_order_screen/track_order.dart';
import 'package:savvy_aqua_delivery/services/auth.dart';
import 'package:shimmer/shimmer.dart';

class OngoingOrders extends StatefulWidget {
  const OngoingOrders({super.key});

  @override
  State<OngoingOrders> createState() => _OngoingOrdersState();
}

class _OngoingOrdersState extends State<OngoingOrders> {
  Future<void> _refreshData() async {
    // Refresh the appointments

    // Call setState to rebuild the widget tree with updated data
    setState(() {});
    print(
        "*******************************************************REFRESHED*******************************");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        tooltip: "Map",
        backgroundColor: Colors.blue,
        onPressed: () async {
          bool? result = await Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 200),
                  reverseDuration: const Duration(milliseconds: 200),
                  child: const AllOrdersMapScreen()));

          if (result == true) {
            // _fetchMaintenanceList();
          }
        },
        child: const Icon(Icons.map_outlined, color: Colors.white),
      ),
      body: RefreshIndicator(
          color: Colors.blue,
          backgroundColor: Colors.white,
          onRefresh: _refreshData,
          child: FutureBuilder<List<OrderModel>>(
            future: Auth.orderList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show shimmer effect while fetching data
                return ListView.builder(
                  itemCount: 15, // Display shimmer for 6 placeholder items
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 12),
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error loading data"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No Data Available"));
              }
              final orders = snapshot.data!;
              return ListView.builder(
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
                                reverseDuration:
                                    const Duration(milliseconds: 200),
                                child: TrackOrder(order: orders[index])));
                      },
                      child: OrderCard(order: orders[index]));
                },
              );
            },
          )),
    );
  }
}
