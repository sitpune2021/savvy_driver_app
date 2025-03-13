import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:savvy_aqua_delivery/screens/home_screen/home_screen.dart';
import 'package:savvy_aqua_delivery/screens/order_screen/order_screen.dart';
import 'package:savvy_aqua_delivery/screens/profile_screen/profile_screen.dart';
import 'package:savvy_aqua_delivery/screens/vehicle_maintenance_screen/vehicle_maintenance.dart';
import 'package:savvy_aqua_delivery/utils/no_internet_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  String _name = "";
  String _mobileNo = "";
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  List<dynamic> get _screens => [
        const HomeScreen(),
        // const AppointmentScreen(i: 0),
        OrderScreen(),
        VehicleMaintenance(),
        ProfileScreen()
      ];

  void _onDestinationSelected(int index) async {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? returnIndex = prefs.getString("navTwo");
    setState(() {
      if (returnIndex == "true") {
        _currentIndex = 1;
      }
    });
    await prefs.remove("navTwo");
  }

  @override
  void initState() {
    super.initState();
    _navigation();
    _loadUserData();
    _checkConnectivity(); // Check initial connectivity status
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _connectionStatus = result;
      });
    });
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? "Guest";
      _mobileNo = prefs.getString('userMobile') ?? "Not Available";
    });
  }

  Future<void> _checkConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _connectionStatus == ConnectivityResult.none
          ? const NoInternetScreen()
          : _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onItemSelected: _onDestinationSelected,
      ),
    );
  }
}

// Custom Bottom Navigation Bar Widget
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 70,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem(
              icon: Icons.home,
              label: "Home",
              index: 0,
            ),
            // _buildNavItem(
            //   icon: Icons.laptop,
            //   label: "Appointment",
            //   index: 1,
            // ),
            _buildNavItem(
              icon: Icons.add_task_sharp,
              label: "Orders",
              index: 1,
            ),
            _buildNavItem(
              icon: Icons.car_crash_outlined,
              label: "Maintenance",
              index: 2,
            ),
            _buildNavItem(
              icon: Icons.person,
              label: "Profile",
              index: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.blue : Colors.black,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.blue : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
