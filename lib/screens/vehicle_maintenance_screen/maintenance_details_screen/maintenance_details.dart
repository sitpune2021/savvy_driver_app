import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MaintenanceDetails extends StatefulWidget {
  final String vehicleNo;
  final String maintenanceType;
  final String maintenanceDescription;
  final String totalAmount;
  final String createdAt;
  final String filepath;
  final String status;
  const MaintenanceDetails(
      {super.key,
      required this.vehicleNo,
      required this.maintenanceType,
      required this.maintenanceDescription,
      required this.totalAmount,
      required this.createdAt,
      required this.filepath,
      required this.status});

  @override
  State<MaintenanceDetails> createState() => _MaintenanceDetailsState();
}

class _MaintenanceDetailsState extends State<MaintenanceDetails> {
  @override
  Widget build(BuildContext context) {
    DateTime orderDate = DateFormat("yyyy-MM-dd").parse(widget.createdAt);
    String date = "${orderDate.day}-${orderDate.month}-${orderDate.year}";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.grey,
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          "Maintenance Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailText("Vehicle Number", widget.vehicleNo),
                // _buildDetailText("Maintenance Type", widget.maintenanceType),
                _buildDetailText("Date", date),
                const SizedBox(height: 0),
                const Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.maintenanceDescription,
                  style: const TextStyle(color: Colors.black87),
                ),
                const Divider(height: 30),
                _buildTotalAmount(widget.totalAmount),
                const SizedBox(height: 10),
                _buildBillSection(),
                const SizedBox(height: 20),
                _buildStatus(widget.status),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 16),
          children: [
            TextSpan(
              text: "$title – ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalAmount(String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Total",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            amount,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildBillSection() {
    print("***************************8${widget.filepath}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Bill",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            _showFullImage(context, widget.filepath);
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: widget.filepath.isNotEmpty
                ? Image.network(
                    widget.filepath,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
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
                : const Icon(Icons.insert_drive_file,
                    color: Colors.blue, size: 40),
          ),
        ),
      ],
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

  Widget _buildStatus(String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Status",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          status,
          style: status == "pending"
              ? const TextStyle(
                  color: Colors.orange, fontWeight: FontWeight.bold)
              : const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
