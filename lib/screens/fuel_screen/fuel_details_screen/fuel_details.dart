import 'package:flutter/material.dart';

class FuelDetails extends StatefulWidget {
  final String date;
  final String vehicleNo;
  final String price;
  final String totalFuel;

  const FuelDetails(
      {super.key,
      required this.date,
      required this.vehicleNo,
      required this.price,
      required this.totalFuel});

  @override
  State<FuelDetails> createState() => _FuelDetailsState();
}

class _FuelDetailsState extends State<FuelDetails> {
  late TextEditingController _dateController;
  late TextEditingController _vehicleNumberController;
  late TextEditingController _fuelController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(text: widget.date);
    _vehicleNumberController = TextEditingController(text: widget.vehicleNo);
    _fuelController = TextEditingController(text: widget.totalFuel);
    _priceController = TextEditingController(text: widget.price);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _vehicleNumberController.dispose();
    _fuelController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
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
      style: TextStyle(color: Colors.black),
      enabled: false,
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        // hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        disabledBorder: OutlineInputBorder(
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
