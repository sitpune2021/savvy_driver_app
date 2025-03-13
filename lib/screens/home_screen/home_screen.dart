import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/screens/order_screen/ongoing_orders/ongoing_orders.dart';
import 'package:savvy_aqua_delivery/screens/order_screen/order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Light blue background
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          "Dashboard",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              _buildStatisticsGrid(),
              const SizedBox(height: 20),
              _buildOrderSection(context, "New Orders Request", "2 item"),
              // _buildOrderSection(context, "Today's Dispatch Order", "25 item"),
              // _buildOrderSection(context, "Today's Ongoing Order", "25 item"),
            ],
          ),
        ),
      ),
    );
  }

  // Order Statistics Grid
  Widget _buildStatisticsGrid() {
    List<Map<String, String>> stats = [
      {"count": "40", "label": "Today's Orders"},
      {"count": "15", "label": "Today's Pending"},
      {"count": "25", "label": "Today's Completed"},
      // {"count": "24", "label": "Total Drivers Assigned"},
      // {"count": "20", "label": "Total Route"},
      // {"count": "40", "label": "Total Customer"},
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

  // Order List Section
  Widget _buildOrderSection(
      BuildContext context, String title, String itemCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType
                            .rightToLeft, // Choose appropriate transition
                        duration: const Duration(
                            milliseconds: 200), // Adjust as needed
                        reverseDuration: const Duration(milliseconds: 200),
                        child: OrderScreen(),
                      ),
                    );
                  },
                  child: const Text("See All",
                      style: TextStyle(color: Colors.blue))),
            ],
          ),
        ),
        Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("#ORD97",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("John Washington",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("12-03-2025", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue, size: 18),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text("Wakad,Pune",
                          style: TextStyle(color: Colors.black54)),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Quantity", style: TextStyle(color: Colors.black54)),
                    Text("10", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Delivery Status",
                        style: TextStyle(color: Colors.black54)),
                    Row(
                      children: [
                        Icon(Icons.circle, color: Colors.orange, size: 12),
                        SizedBox(width: 5),
                        Text("Pending", style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
