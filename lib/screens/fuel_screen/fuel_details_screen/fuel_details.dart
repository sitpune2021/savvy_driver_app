import 'package:flutter/material.dart';

class FuelDetails extends StatefulWidget {
  const FuelDetails({super.key});

  @override
  State<FuelDetails> createState() => _FuelDetailsState();
}

class _FuelDetailsState extends State<FuelDetails> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _vehicleNumberController =
      TextEditingController();
  final TextEditingController _fuelController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          "Fueling Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Date"),
              _buildTextField(_dateController, "Date"),
              _buildLabel("Vehicle Number"),
              _buildTextField(_vehicleNumberController, "Vehicle Number"),
              _buildLabel("Total Fuel"),
              _buildTextField(_fuelController, "Total Fuel"),
              _buildLabel("Price"),
              _buildTextField(_priceController, "Price"),
              _buildLabel("Receipt"),
              _buildImageContainer(),
              _buildLabel("Meter Photo"),
              _buildImageContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      enabled: false,
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        // hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      height: 120,
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Image.asset(
          "assets/images/document.png", // Replace with actual image asset or network image
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
