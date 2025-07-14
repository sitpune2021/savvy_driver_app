import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/model/order_model.dart';
import 'package:savvy_aqua_delivery/model/paginated_order_model.dart';
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
        await Auth.orderListPaginated("pending", page: _currentPage);

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
            _refreshData();
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
                                                child:
                                                    TrackOrder(order: order)));
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
