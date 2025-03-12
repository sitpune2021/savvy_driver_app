import 'package:flutter/material.dart';

class OrderConfirmation extends StatefulWidget {
  @override
  _OrderConfirmationState createState() => _OrderConfirmationState();
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  List<String> deliveredImages = [
    'assets/images/bottle.png',
    'assets/images/bottle.png',
  ];
  List<String> returnedImages = [
    'assets/images/bottle.png',
    'assets/images/bottle.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Order Confirmation",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
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
                  child: _buildSection("Delivered Items", deliveredImages, 20),
                )),
            SizedBox(height: 20),
            Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildSection("Returned Bottles", returnedImages, 40),
                )),
            Spacer(),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> images, int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count.toString(),
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.all(10),
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
            child: CircleAvatar(
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
        child: Icon(Icons.add, size: 30, color: Colors.grey),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Handle submit action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: Size(double.infinity, 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child:
            Text("Submit", style: TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
