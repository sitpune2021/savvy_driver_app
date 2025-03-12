import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/screens/order_confirmation_screen/order_confirmation.dart';

class TrackOrder extends StatefulWidget {
  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  late GoogleMapController mapController;

  final LatLng pickupLocation = const LatLng(18.448442, 73.858468);
  final LatLng deliveryLocation = const LatLng(18.503567, 73.919690);

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();

    _addMarkers();
    _createCurvedPolyline();
  }

  void _addMarkers() {
    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId("pickup"),
          position: pickupLocation,
          infoWindow: const InfoWindow(title: "Pickup Location"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );

      markers.add(
        Marker(
          markerId: const MarkerId("delivery"),
          position: deliveryLocation,
          infoWindow: const InfoWindow(title: "Delivery Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }

  void _createCurvedPolyline() {
    LatLng control = LatLng(
      (pickupLocation.latitude + deliveryLocation.latitude) / 2 +
          0.01, // Adjust curve height
      (pickupLocation.longitude + deliveryLocation.longitude) / 2,
    );

    List<LatLng> curvedPath =
        _generateBezierPoints(pickupLocation, control, deliveryLocation);

    Polyline curvedPolyline = Polyline(
      polylineId: const PolylineId("curvedRoute"),
      points: curvedPath,
      color: Colors.black,
      width: 2,
      patterns: [PatternItem.dash(20), PatternItem.gap(10)], // Dashed effect
      jointType: JointType.round,
    );

    setState(() {
      polylines.add(curvedPolyline);
    });
  }

  List<LatLng> _generateBezierPoints(LatLng start, LatLng control, LatLng end) {
    List<LatLng> points = [];
    for (double t = 0; t <= 1; t += 0.05) {
      double lat = pow(1 - t, 2) * start.latitude +
          2 * (1 - t) * t * control.latitude +
          pow(t, 2) * end.latitude;
      double lng = pow(1 - t, 2) * start.longitude +
          2 * (1 - t) * t * control.longitude +
          pow(t, 2) * end.longitude;
      points.add(LatLng(lat, lng));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          "Track Order",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
              ),
              height: 300,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: pickupLocation,
                  zoom: 12,
                ),
                markers: markers,
                polylines: polylines,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
              ),
            ),
            // _buildDeliveryInfoCard(),

            const SizedBox(height: 20),

            // Order Details Card
            Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              child: const Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("#ORD97",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Prajwal Punekar",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        Text("17 Feb 2025",
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.blue, size: 18),
                        SizedBox(width: 5),
                        Expanded(
                            child: Text("Santosh Nagar, Chinchwad Pune",
                                style: TextStyle(color: Colors.black54))),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Quantity", style: TextStyle(color: Colors.black)),
                        Text("20 Bottles",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Next Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: OrderConfirmation()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Next",
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryInfoCard() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: const Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(Icons.delivery_dining, color: Colors.green, size: 30),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "I'm [Driver Name],",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Completed 600+ five-star deliveries",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              Spacer(),
              Icon(Icons.phone, color: Colors.blue, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
