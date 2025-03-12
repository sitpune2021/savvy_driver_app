import 'package:flutter/material.dart';

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
              Text(
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
                  onPressed: () {},
                  child: const Text("See All",
                      style: TextStyle(color: Colors.blue))),
            ],
          ),
        ),
        Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: const Text("#ORD97",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            subtitle: Text(itemCount,
                style: const TextStyle(fontSize: 14, color: Colors.black54)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.blue),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
