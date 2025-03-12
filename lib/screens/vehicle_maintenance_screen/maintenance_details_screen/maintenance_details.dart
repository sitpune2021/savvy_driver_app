import 'package:flutter/material.dart';

class MaintenanceDetails extends StatefulWidget {
  const MaintenanceDetails({super.key});

  @override
  State<MaintenanceDetails> createState() => _MaintenanceDetailsState();
}

class _MaintenanceDetailsState extends State<MaintenanceDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        elevation: 0,
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
                _buildDetailText("Vehicle Number", "MH 12 6977"),
                _buildDetailText("Maintenance Type", "Break Failed"),
                _buildDetailText("Date", "25-02-2025"),
                const SizedBox(height: 10),
                const Text(
                  "Description",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Damage can occur due to brake failure from worn pads or low fluid, engine overheating, transmission issues, or electrical faults like a dead battery. Suspension problems, tire wear, and external factors like accidents or water damage also impact performance. Regular maintenance prevents major issues.",
                  style: TextStyle(color: Colors.black87),
                ),
                const Divider(height: 30),
                _buildTotalAmount(),
                const SizedBox(height: 10),
                _buildBillSection(),
                const SizedBox(height: 20),
                _buildStatus(),
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

  Widget _buildTotalAmount() {
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
          child: const Text(
            "1000",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildBillSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Bill",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.circular(8),
          ),
          child:
              const Icon(Icons.insert_drive_file, color: Colors.blue, size: 40),
        ),
      ],
    );
  }

  Widget _buildStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Status",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const Text(
          "Approved",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
