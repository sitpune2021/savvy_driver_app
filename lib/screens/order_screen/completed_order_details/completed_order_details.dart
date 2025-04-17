import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:savvy_aqua_delivery/model/order_model.dart';
import 'package:savvy_aqua_delivery/services/auth.dart';

class CompletedOrderDetails extends StatefulWidget {
  final OrderModel order;

  const CompletedOrderDetails({super.key, required this.order});

  @override
  _CompletedOrderDetailsState createState() => _CompletedOrderDetailsState();
}

class _CompletedOrderDetailsState extends State<CompletedOrderDetails> {
  Map<String, dynamic>? orderDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrderDetails();
  }

  Future<void> fetchOrderDetails() async {
    try {
      Map<String, dynamic>? fetchedDetails =
          await Auth.orderDetails(widget.order.orderId);

      setState(() {
        orderDetails = fetchedDetails;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching order details: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime orderDate = DateFormat("yyyy-MM-dd").parse(widget.order.createdAt);
    String date = "${orderDate.day}-${orderDate.month}-${orderDate.year}";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.grey,
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        title:
            const Text("Order Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.blue))
            : orderDetails == null
                ? const Center(child: Text("No details found"))
                : SingleChildScrollView(
                    // Prevents overflow issue
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Completed Order",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Order ID: ${widget.order.orderId}",
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(date,
                                        style: const TextStyle(
                                            color: Colors.black)),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  widget.order.customerName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Colors.blue, size: 18),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        widget.order.customerAddress,
                                        style: const TextStyle(
                                            color: Colors.black54),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Divider(),
                                SingleChildScrollView(
                                  scrollDirection: Axis
                                      .horizontal, // Prevents horizontal overflow
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      itemCard(
                                        "Delivered Jars",
                                        orderDetails?['deliveredItem'],
                                        int.tryParse(
                                                orderDetails?['develivered_qty']
                                                        ?.toString() ??
                                                    '0') ??
                                            0,
                                      ),
                                      const SizedBox(width: 20),
                                      itemCard(
                                        "Returned Jars",
                                        orderDetails?['reveivedItem'],
                                        int.tryParse(orderDetails?['return_qty']
                                                    ?.toString() ??
                                                '0') ??
                                            0,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget itemCard(String title, String? imagePath, int count) {
    return GestureDetector(
      onTap: () => _showFullImage(context, imagePath ?? ""),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: imagePath != null && imagePath.startsWith("http")
                ? Image.network(
                    imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // Image fully loaded
                      }
                      return SizedBox(
                        width: 100,
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        ),
                      ); // Show loading indicator
                    },
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.broken_image,
                        color: Colors.red,
                        size: 40),
                  )
                : imagePath != null && File(imagePath).existsSync()
                    ? Image.file(File(imagePath),
                        width: 100, height: 100, fit: BoxFit.cover)
                    : const Icon(Icons.image, size: 100, color: Colors.grey),
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
      ),
    );
  }

  // Method to show image in full screen
  void _showFullImage(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              InteractiveViewer(
                minScale: 0.5,
                maxScale: 3.0,
                child: Image.network(
                  image,
                  errorBuilder: (context, error, stackTrace) {
                    print("Error in full screen image: $error");
                    return Container(
                      color: Colors.black,
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.broken_image,
                                size: 100, color: Colors.white),
                            SizedBox(height: 20),
                            Text(
                              "Failed to load image",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Positioned(
                top: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
