import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/model/order_model.dart';
import 'package:savvy_aqua_delivery/screens/order_confirmation_screen/order_confirmation.dart';

class TrackOrder extends StatefulWidget {
  final OrderModel order;

  const TrackOrder({super.key, required this.order});
  @override
  _TrackOrderState createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  GoogleMapController? mapController; // Nullable now to check initialization
  final LatLng pickupLocation = const LatLng(18.448442, 73.858468);
  LatLng? deliveryLocation;

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  bool isMapReady = false; // Flag to check if the map is ready

  @override
  void initState() {
    super.initState();
    fetchLocation(widget.order.customerAddress);
  }

  Future<LatLng?> getLatLngFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
    return null;
  }

  void fetchLocation(String address) async {
    LatLng? location = await getLatLngFromAddress(address);
    if (location != null) {
      setState(() {
        deliveryLocation = location;
        _addMarkers();
        // _createCurvedPolyline();
      });

      // Ensure the map is ready before moving the camera
      if (isMapReady && mapController != null) {
        mapController!
            .animateCamera(CameraUpdate.newLatLngZoom(deliveryLocation!, 14));
      }
    }
  }

  void _addMarkers() {
    markers.clear();
    // markers.add(
    //   Marker(
    //     markerId: const MarkerId("pickup"),
    //     position: pickupLocation,
    //     infoWindow: const InfoWindow(title: "Pickup Location"),
    //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    //   ),
    // );

    if (deliveryLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("delivery"),
          position: deliveryLocation!,
          infoWindow: const InfoWindow(title: "Delivery Location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    setState(() {});
  }

  void _createCurvedPolyline() {
    if (deliveryLocation == null) return;

    LatLng control = LatLng(
      (pickupLocation.latitude + deliveryLocation!.latitude) / 2 + 0.01,
      (pickupLocation.longitude + deliveryLocation!.longitude) / 2,
    );

    List<LatLng> curvedPath =
        _generateBezierPoints(pickupLocation, control, deliveryLocation!);

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
    DateTime orderDate = DateFormat("yyyy-MM-dd").parse(widget.order.createdAt);
    String date = "${orderDate.day}-${orderDate.month}-${orderDate.year}";

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.grey,
        elevation: 5,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          "Track Order",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                        setState(() {
                          isMapReady = true;
                        });

                        // If delivery location is already fetched, move the camera
                        if (deliveryLocation != null) {
                          controller.animateCamera(CameraUpdate.newLatLngZoom(
                              deliveryLocation!, 14));
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.white,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.order.orderId,
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.order.customerName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(date,
                                  style: const TextStyle(color: Colors.black)),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.blue, size: 18),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(widget.order.customerAddress,
                                    style:
                                        const TextStyle(color: Colors.black54)),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Quantity",
                                  style: TextStyle(color: Colors.black54)),
                              Text("${widget.order.qty} Bottles",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: OrderConfirmation(
                                orderId: widget.order.orderId,
                              )));
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
      ),
    );
  }
}
