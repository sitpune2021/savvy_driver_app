import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/model/order_model.dart';
import 'package:savvy_aqua_delivery/screens/order_screen/completed_order_details/completed_order_details.dart';
import 'package:savvy_aqua_delivery/screens/track_order_screen/track_order.dart';
import 'package:savvy_aqua_delivery/services/auth.dart';
import 'package:shimmer/shimmer.dart';

class CompletedOrders extends StatefulWidget {
  const CompletedOrders({super.key});

  @override
  State<CompletedOrders> createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {
  bool isLoading = true;
  List<OrderModel> allOrderList = [];
  List<OrderModel> filteredOrderList = []; // Stores filtered data
  String searchQuery = ""; // for searching
  Future<void> _refreshData() async {
    // Refresh the appointments

    // Call setState to rebuild the widget tree with updated data
    setState(() {
      _fetchOrderList();
    });
    print(
        "*******************************************************REFRESHED*******************************");
  }

  Future<void> _fetchOrderList() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<OrderModel> list = await Auth.completedOrderList();
      setState(() {
        allOrderList = list;
        filteredOrderList = allOrderList;
        isLoading = false;
      });
      print(
          "**************************refershed filteredOrderList $filteredOrderList");
    } catch (e) {
      print("Error fetching maintenance list: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterOrders(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredOrderList = allOrderList;
      } else {
        filteredOrderList = allOrderList
            .where((order) =>
                order.customerName
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                order.createdAt.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
          color: Colors.blue,
          backgroundColor: Colors.white,
          onRefresh: _refreshData,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, right: 16.0, top: 12.0, bottom: 5.0),
                child: TextField(
                  onChanged: _filterOrders,
                  decoration: InputDecoration(
                    labelText: "Search",
                    floatingLabelStyle: const TextStyle(color: Colors.blue),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                    border: OutlineInputBorder(
                      // Use OutlineInputBorder instead of BoxDecoration
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: Colors.blue), // Default border color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                          color: Colors.blue, width: 2), // Blue when focused
                    ),
                  ),
                ),
              ),
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                        color: Colors.blue,
                      )) // <-- Show loading spinner
                    : filteredOrderList.isEmpty
                        ? const Center(child: Text("No Data Available"))
                        : ListView.builder(
                            padding: const EdgeInsets.all(10),
                            itemCount: filteredOrderList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.rightToLeft,
                                            duration: const Duration(
                                                milliseconds: 200),
                                            reverseDuration: const Duration(
                                                milliseconds: 200),
                                            child: CompletedOrderDetails(
                                                order:
                                                    filteredOrderList[index])));
                                  },
                                  child: OrderCard(
                                      order: filteredOrderList[index]));
                            },
                          ),
              ),
            ],
          ),
        ));
  }
}

class OrderCard extends StatelessWidget {
  final OrderModel order;

  OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    DateTime orderDate = DateFormat("yyyy-MM-dd").parse(order.createdAt);
    String date = "${orderDate.day}-${orderDate.month}-${orderDate.year}";
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
            Text(order.orderId,
                style: const TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(order.customerName,
            //         style: const TextStyle(
            //             fontSize: 16, fontWeight: FontWeight.bold)),
            //     Text(date, style: const TextStyle(color: Colors.black)),
            //   ],
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    order.customerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(date, style: const TextStyle(color: Colors.black)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.blue, size: 18),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(order.customerAddress,
                      style: const TextStyle(color: Colors.black54)),
                ),
              ],
            ),
            // const Divider(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const Text("Quantity", style: TextStyle(color: Colors.black54)),
            //     Text("${order.qty} Bottles",
            //         style: const TextStyle(fontWeight: FontWeight.bold)),
            //   ],
            // ),
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
                    Text(order.status,
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
