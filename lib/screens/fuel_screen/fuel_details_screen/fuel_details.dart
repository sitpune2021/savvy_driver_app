import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FuelDetails extends StatefulWidget {
  final String date;
  final String vehicleNo;
  final String price;
  final String totalFuel;
  final String filepath1;
  final String filepath2;

  const FuelDetails({
    super.key,
    required this.date,
    required this.vehicleNo,
    required this.price,
    required this.totalFuel,
    required this.filepath1,
    required this.filepath2,
  });

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
    DateTime orderDate = DateFormat("yyyy-MM-dd").parse(widget.date);
    String date = "${orderDate.day}-${orderDate.month}-${orderDate.year}";
    _dateController = TextEditingController(text: date);
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
        shadowColor: Colors.grey,
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
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

              // Receipt Image
              _buildLabel("Receipt"),
              _buildImageContainer(widget.filepath1),

              // Meter Photo
              _buildLabel("Meter Photo"),
              _buildImageContainer(widget.filepath2),
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
      style: const TextStyle(color: Colors.black),
      enabled: false,
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
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

  Widget _buildImageContainer(String imageUrl) {
    return GestureDetector(
      onTap: () => _showFullImage(context, imageUrl),
      child: Container(
        height: 120,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                  child:
                      CircularProgressIndicator()); // Show loader while image is loading
            },
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.broken_image, color: Colors.red, size: 40),
                    SizedBox(height: 5),
                    Text(
                      "Failed to load image",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ); // Show error if image fails
            },
          ),
        ),
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
