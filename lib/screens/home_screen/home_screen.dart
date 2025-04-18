import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/constants/Constant.dart';
import 'package:savvy_aqua_delivery/model/order_model.dart';
import 'package:savvy_aqua_delivery/screens/login_screen/login_screen.dart';
import 'package:savvy_aqua_delivery/screens/order_screen/order_screen.dart';
import 'package:savvy_aqua_delivery/screens/order_screen/widget/order_card.dart';
import 'package:savvy_aqua_delivery/services/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int todaysOrder = 0;
  int todaysPending = 0;
  int todaysCompleted = 0;
  int totalDeliveryCount = 0;
  int totalDeliveredCount = 0;
  bool isLoading = true;
  bool isSessionOut = false;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? driverId = prefs.getString("userid");
      String? token = prefs.getString("token");
      if (kDebugMode) {
        print("--------------------------token: $token");
      }
      if (kDebugMode) {
        print("--------------------------driverid: $driverId");
      }
      final response = await http.get(
        Uri.parse(
            "${Constant.orderStatistics}order?driver_id=$driverId&count=true"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("--------------------------dashboard statistics $data");
        if (data['status'] == true) {
          setState(() {
            todaysOrder = data['data']['todays_orders'];
            todaysPending = data['data']['todays_pending_orders'];
            todaysCompleted = data['data']['todays_completed_orders'];
            totalDeliveryCount = data['data']['total_delivery_count'];
            totalDeliveredCount = data['data']['total_deliverd_count'];
            isLoading = false;
          });
        }
      } else if (response.statusCode == 401) {
        final data = jsonDecode(response.body);
        print("--------------------------dashboard statistics $data");
        if (data['status'] == false) {
          setState(() {
            isSessionOut = true;
          });
          print("--------------------------session statistics $isSessionOut");
        }
      }
    } catch (e) {
      print("Error fetching dashboard data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    // Refresh the appointments

    // Call setState to rebuild the widget tree with updated data
    setState(() {});
    print(
        "******************************************************REFRESHED*******************************");
    fetchDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    if (isSessionOut) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => _checkSession(),
          );
        }
      });
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        shadowColor: Colors.grey,
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Dashboard",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
            onPressed: () {
              _refreshData();
            },
          ),
        ],
        centerTitle: false,
      ),
      body: RefreshIndicator(
        color: Colors.blue,
        backgroundColor: Colors.white,
        onRefresh: _refreshData,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Today's Order Statistics",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black),
              ),
              isLoading ? _buildLoadingIndicator() : _buildStatisticsGrid(),
              const SizedBox(height: 10),
              Card(
                color: const Color.fromARGB(255, 208, 230, 249),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total bottles",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$totalDeliveredCount/$totalDeliveryCount",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildOrderSection(context, "New Orders Request"),
              Expanded(
                child: FutureBuilder<List<OrderModel>>(
                  future: Auth.orderList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show shimmer effect while fetching data
                      return const Center(
                          child: CircularProgressIndicator(
                        color: Colors.blue,
                      ));
                    } else if (snapshot.hasError) {
                      return const Center(child: Text("Error loading data"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text(
                        "No any order yet",
                        style: TextStyle(color: Colors.red),
                      ));
                    }
                    final orders = snapshot.data!;
                    // List<OrderModel> order = [];

                    // int length = orders.length;
                    // order.add(orders[length - 1]);

                    // print(
                    //     "--------------------------dashboard last order list $order");

                    return ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     PageTransition(
                              //         type: PageTransitionType.rightToLeft,
                              //         duration: const Duration(milliseconds: 200),
                              //         reverseDuration:
                              //             const Duration(milliseconds: 200),
                              //         child: CompletedOrderDetails(
                              //             order: orders[index])));
                            },
                            child: OrderCard(order: orders[index]));
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid() {
    List<Map<String, String>> stats = [
      {"count": "$todaysOrder", "label": "Today's \nOrders"},
      {"count": "$todaysPending", "label": "Today's \nPending"},
      {"count": "$todaysCompleted", "label": "Today's \nCompleted"},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        return Card(
          color: const Color.fromARGB(255, 208, 230, 249),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                stats[index]["count"]!,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 4),
              Text(
                stats[index]["label"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _checkSession() {
    // showDialog(
    //   context: context,
    //   barrierDismissible: true,
    //   builder: (BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Session Time Out\nPlease login again",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Delete Account Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  // Handle Delete Action
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  final driverId = preferences.getString("userid");
                  print(
                      "******************************logout driverID $driverId");
                  // final result = await Auth.logout();
                  // bool result = true;
                  // if (result) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged out successfully')),
                  );
                  Navigator.pop(context);

                  preferences.clear();
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 200),
                          reverseDuration: const Duration(milliseconds: 200),
                          child: const LoginScreen()));
                  // }
                  // else {
                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(
                  //         content:
                  //             Text('Server Error please try again later!')),
                  //   );
                  // }
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    //   },
    // );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: CircularProgressIndicator(
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildOrderSection(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 200),
                    reverseDuration: const Duration(milliseconds: 200),
                    child: OrderScreen(),
                  ),
                );
              },
              child:
                  const Text("See All", style: TextStyle(color: Colors.blue))),
        ],
      ),
    );
  }
}
