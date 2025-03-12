import 'package:flutter/material.dart';

class CompletedOrderDetails extends StatefulWidget {
  @override
  _CompletedOrderDetailsState createState() => _CompletedOrderDetailsState();
}

class _CompletedOrderDetailsState extends State<CompletedOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Order Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Completed Order",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "#ORD97",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "17 Feb 2025",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Prajwal Punekar",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue, size: 18),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            "Santosh Nagar, Chinchwad, Pune",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        itemCard(
                            "Delivered Item", "assets/images/bottle.png", 20),
                        itemCard(
                            "Returned Item", "assets/images/bottle.png", 40),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemCard(String title, String imagePath, int count) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Image.asset(imagePath, width: 100, height: 100),
        ),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
