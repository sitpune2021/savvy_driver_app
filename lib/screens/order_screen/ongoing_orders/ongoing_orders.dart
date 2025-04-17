import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/model/order_model.dart';
import 'package:savvy_aqua_delivery/screens/all_orders_map_screen/all_orders_map_screen.dart';
import 'package:savvy_aqua_delivery/screens/order_screen/widget/order_card.dart';
import 'package:savvy_aqua_delivery/screens/track_order_screen/track_order.dart';
import 'package:savvy_aqua_delivery/services/auth.dart';

class OngoingOrders extends StatefulWidget {
  const OngoingOrders({super.key});

  @override
  State<OngoingOrders> createState() => _OngoingOrdersState();
}

class _OngoingOrdersState extends State<OngoingOrders> {
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
      List<OrderModel> list = await Auth.orderList();
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
                                            child: TrackOrder(
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
