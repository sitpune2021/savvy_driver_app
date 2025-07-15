import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/model/order_model.dart';
import 'package:savvy_aqua_delivery/screens/all_orders_map_screen/all_orders_map_screen.dart';
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
  bool _isFetchingMore = false;
  bool _hasMore = true;

  int _currentPage = 1;
  int _lastPage = 1;

  List<OrderModel> allOrderList = [];
  List<OrderModel> filteredOrderList = [];
  String searchQuery = "";

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchOrderList(isInitial: true);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 300 &&
          !_isFetchingMore &&
          _hasMore &&
          !isLoading) {
        _fetchOrderList();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    await _fetchOrderList(isInitial: true);
  }

  Future<void> _fetchOrderList({bool isInitial = false}) async {
    if (isInitial) {
      setState(() {
        isLoading = true;
        _currentPage = 1;
        _hasMore = true;
        allOrderList.clear();
        filteredOrderList.clear();
      });
    } else {
      setState(() {
        _isFetchingMore = true;
      });
    }

    final response =
        await Auth.orderListPaginated("completed", page: _currentPage);

    if (response != null) {
      setState(() {
        if (isInitial) {
          allOrderList = response.orders;
        } else {
          allOrderList.addAll(response.orders);
        }

        _lastPage = response.lastPage;
        filteredOrderList = allOrderList;
        _currentPage++;
        _hasMore = _currentPage <= _lastPage;

        isLoading = false;
        _isFetchingMore = false;
      });
    } else {
      setState(() {
        isLoading = false;
        _isFetchingMore = false;
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
                order.orderId.toLowerCase().contains(query.toLowerCase()) ||
                order.createdAt.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
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
                  prefixIcon: const Icon(Icons.search, color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    )
                  : filteredOrderList.isEmpty
                      ? const Center(child: Text("No Data Available"))
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(10),
                          itemCount:
                              filteredOrderList.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == filteredOrderList.length) {
                              return const Padding(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.blue),
                                ),
                              );
                            }

                            final order = filteredOrderList[index];
                            return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 400),
                                delay: const Duration(milliseconds: 5),
                                child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                        child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                reverseDuration: const Duration(
                                                    milliseconds: 200),
                                                child: CompletedOrderDetails(
                                                    order: filteredOrderList[
                                                        index])));
                                      },
                                      child: OrderCard(order: order),
                                    ))));
                          },
                        ),
            ),
          ],
        ),
      ),
    );
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
            Text("Order ID: ${order.orderId}",
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
