import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/screens/dashboard_screen/dashboard_screen.dart';
import 'package:savvy_aqua_delivery/screens/order_screen/order_screen.dart';
import 'package:savvy_aqua_delivery/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderConfirmation extends StatefulWidget {
  final String orderId;

  const OrderConfirmation({super.key, required this.orderId});
  @override
  _OrderConfirmationState createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  final TextEditingController _deliveredItem = TextEditingController();
  final TextEditingController _returnedItem = TextEditingController();

  List<String> deliveredImages = [
    'assets/images/bottle.png',
    'assets/images/bottle.png',
  ];
  List<String> returnedImages = [
    'assets/images/bottle.png',
    'assets/images/bottle.png',
  ];

  void _submitForm() async {
    String returnedItem = _returnedItem.text.trim();
    String deliveredItem = _deliveredItem.text.trim();

    if (returnedItem.isEmpty || deliveredItem.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    } else {
      bool result = await Auth.orderConfirmation(
          widget.orderId, returnedItem, deliveredItem);

      if (result) {
        _returnedItem.clear();
        _deliveredItem.clear();
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // Add a delay of 1 second before navigating
        Future.delayed(const Duration(milliseconds: 500), () {
          prefs.setString("navTwo", "true");
          Navigator.pushAndRemoveUntil(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: DashboardScreen()),
            (route) => false,
          );
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order submitted Successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server Error please try again later!')),
        );
      }
    }

    // Handle form submission logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Order Confirmation",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildSection(
                        "Delivered Items", deliveredImages, 20, _deliveredItem),
                  )),
              const SizedBox(height: 20),
              Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildSection(
                        "Returned Bottles", returnedImages, 40, _returnedItem),
                  )),
              const SizedBox(
                height: 20,
              ),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> images, int count,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 80, // Set a fixed width
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  label: const Text(
                    "count",
                    style: TextStyle(color: Colors.blue),
                  ),
                  hintText: "count", // Use count as initial value
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: Colors.blue), // Default border color
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                        color: Colors.blue, width: 2), // Blue when focused
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(10),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ...images.map((image) => _buildImageCard(image)).toList(),
              _buildAddPhotoButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageCard(String imagePath) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () {
              setState(() {
                deliveredImages.remove(imagePath);
                returnedImages.remove(imagePath);
              });
            },
            child: const CircleAvatar(
              radius: 12,
              backgroundColor: Colors.white,
              child: Icon(Icons.close, size: 16, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotoButton() {
    return GestureDetector(
      onTap: () {
        // Handle photo upload action
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: const Icon(Icons.add, size: 30, color: Colors.grey),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Handle submit action
          _submitForm();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: const Size(double.infinity, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: const Text("Submit",
            style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
