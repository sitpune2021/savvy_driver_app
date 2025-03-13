import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:savvy_aqua_delivery/model/order_model.dart';
import 'package:savvy_aqua_delivery/services/auth.dart';

class AllOrdersMapScreen extends StatefulWidget {
  const AllOrdersMapScreen({super.key});

  @override
  State<AllOrdersMapScreen> createState() => _AllOrdersMapScreenState();
}

class _AllOrdersMapScreenState extends State<AllOrdersMapScreen> {
  late GoogleMapController _mapController;
  Set<Marker> markers = {};
  List<OrderModel> allOrders = [];
  LatLng?
      _firstOrderLocation; // Stores first order location for camera position

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  /// Fetch orders and convert addresses to LatLng markers
  void fetchOrders() async {
    List<OrderModel> list = await Auth.orderList();
    if (list.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No orders available!")));
      return;
      // No orders, no markers
    }

    setState(() {
      allOrders = list; // Store orders for bottom sheet reference
    });

    LatLngBounds? bounds;
    for (int i = 0; i < list.length; i++) {
      OrderModel order = list[i];
      String address = order.customerAddress;
      LatLng? location = await getLatLngFromAddress(address);
      if (location != null) {
        _addMarker(location, order);

        if (i == 0) {
          _firstOrderLocation = location; // Set first order location
        }

        bounds = bounds == null
            ? LatLngBounds(southwest: location, northeast: location)
            : LatLngBounds(
                southwest: LatLng(
                  location.latitude < bounds.southwest.latitude
                      ? location.latitude
                      : bounds.southwest.latitude,
                  location.longitude < bounds.southwest.longitude
                      ? location.longitude
                      : bounds.southwest.longitude,
                ),
                northeast: LatLng(
                  location.latitude > bounds.northeast.latitude
                      ? location.latitude
                      : bounds.northeast.latitude,
                  location.longitude > bounds.northeast.longitude
                      ? location.longitude
                      : bounds.northeast.longitude,
                ),
              );
      }
    }

    if (bounds != null) {
      _moveCameraToBounds(bounds);
    }
  }

  /// Convert address into LatLng
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

  /// Add marker to the map with bottom sheet on tap
  void _addMarker(LatLng location, OrderModel order) {
    setState(() {
      markers.add(
        Marker(
          markerId: MarkerId(order.orderId),
          position: location,
          infoWindow: InfoWindow(title: "Order: ${order.orderId}"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () => _showOrderDetails(order),
        ),
      );
    });
  }

  /// Show Bottom Sheet with Order Details
  void _showOrderDetails(OrderModel order) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        DateTime orderDate = DateFormat("yyyy-MM-dd").parse(order.createdAt);
        String date = "${orderDate.day}-${orderDate.month}-${orderDate.year}";
        return Container(
          height: 300,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0))),
          child: Column(
            children: [
              Card(
                color: Colors.white,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.orderId,
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(order.customerName,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
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
                            child: Text(order.customerAddress,
                                style: const TextStyle(color: Colors.black54)),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Quantity",
                              style: TextStyle(color: Colors.black54)),
                          Text("${order.qty} Bottles",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     const Text("Delivery Status",
                      //         style: TextStyle(color: Colors.black54)),
                      //     Row(
                      //       children: [
                      //         const Icon(Icons.circle, color: Colors.orange, size: 12),
                      //         const SizedBox(width: 5),
                      //         Text(order.status,
                      //             style: const TextStyle(color: Colors.black)),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Move camera to fit all markers
  void _moveCameraToBounds(LatLngBounds bounds) {
    Future.delayed(const Duration(milliseconds: 500), () {
      _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("All Orders", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _firstOrderLocation ??
              const LatLng(0, 0), // Default to 0,0 if no orders
          zoom: _firstOrderLocation == null ? 2 : 12, // Zoom out if no orders
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        markers: markers,
      ),
    );
  }
}
