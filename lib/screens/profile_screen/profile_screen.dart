import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:savvy_aqua_delivery/constants/color_constants.dart';
import 'package:savvy_aqua_delivery/screens/digital_card/digital_card.dart';
import 'package:savvy_aqua_delivery/screens/fuel_screen/fuel_screen.dart';
import 'package:savvy_aqua_delivery/screens/login_screen/login_screen.dart';
import 'package:savvy_aqua_delivery/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _appVersion = "";
  String? _name;
  String? _phone;
  String? _email;

  @override
  initState() {
    super.initState();
    _loadAppVersion();
    userDetails();
  }

  Future<void> userDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name = prefs.getString("name");
    _email = prefs.getString("email");
    _phone = prefs.getString("phone");
  }

  Future<void> _loadAppVersion() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = packageInfo.version;
      });
      print("App version: $_appVersion");
    } catch (e) {
      print("Error fetching app version: $e"); // ✅ Log errors for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E90FF),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        shadowColor: Colors.grey,
        elevation: 5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(80)),
                        border: Border.all(
                            width: 1.0, color: ColorConstants.blueBorder)),
                    child: const SizedBox(
                      height: 120,
                      width: 120,
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person,
                            size: 80, color: Color(0xFF1E90FF)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    _name ?? "",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow("Phone No:", _phone ?? ""),
                        _buildInfoRow("Email:", _email ?? ""),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Menu Options
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                children: [
                  // _buildMenuItem(FontAwesome.edit, "Update Profile"),
                  GestureDetector(
                    child: _buildMenuItem(Icons.local_gas_station, "Fuel"),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType
                              .rightToLeft, // Choose appropriate transition
                          duration: const Duration(
                              milliseconds: 200), // Adjust as needed
                          reverseDuration: const Duration(milliseconds: 200),
                          child: const FuelScreen(),
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    child: _buildMenuItem(Icons.book, "Digital Card"),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType
                              .rightToLeft, // Choose appropriate transition
                          duration: const Duration(
                              milliseconds: 200), // Adjust as needed
                          reverseDuration: const Duration(milliseconds: 200),
                          child: DigitalCard(),
                        ),
                      );
                    },
                  ),
                  GestureDetector(
                    child: _buildMenuItem(
                      FontAwesome.trash,
                      "Delete Account",
                    ),
                    onTap: () {
                      //  / showDeleteDialog(context);
                      showDeleteDialog(context);
                    },
                  ),
                  _buildMenuItemAppVersion(
                      FontAwesome.info_circle, "App Version"),
                  GestureDetector(
                    child: _buildMenuItem(FontAwesome.sign_out, "Log Out"),
                    onTap: () {
                      showLogOutDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Menu Item Builder
  Widget _buildMenuItemold(IconData icon, String text,
      {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF22AEF2), size: 24),
              const SizedBox(width: 16),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text,
      {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: const Color(0xFF22AEF2), size: 24),
            title: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 16,
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildMenuItemAppVersionold(IconData icon, String text,
      {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF22AEF2), size: 24),
              const SizedBox(width: 16),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                _appVersion,
                style: TextStyle(
                  color: color,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildMenuItemAppVersion(IconData icon, String text,
      {Color color = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon, color: const Color(0xFF22AEF2), size: 24),
            title: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 16,
              ),
            ),
            trailing: Text(
              _appVersion,
              style: TextStyle(
                color: color,
                fontSize: 16,
              ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  // Info Row Builder
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black, fontSize: 16),
          children: [
            TextSpan(
                text: "$label ",
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  // Widget delete(BuildContext context){
  Future<void> showDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Are You Sure\nWant to Delete?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Delete Account Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      // Handle Delete Action

                      bool result = await Auth.deleteAccount();
                      if (result) {
                        Navigator.pop(context);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Your account deleted successfully!")));
                        Navigator.pushReplacement(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                duration: const Duration(milliseconds: 200),
                                reverseDuration:
                                    const Duration(milliseconds: 200),
                                child: const LoginScreen()));
                      } else {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Account not deleted, please try again!")));
                      }
                    },
                    child: const Text(
                      "Delete Account",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Not Now Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Not Now",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showLogOutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Are You Sure\nWant to Log Out?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                // Delete Account Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      // Handle Delete Action
                      Navigator.pop(context);
                      SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      preferences.clear();
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              duration: const Duration(milliseconds: 200),
                              reverseDuration:
                                  const Duration(milliseconds: 200),
                              child: const LoginScreen()));
                    },
                    child: const Text(
                      "Log Out",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Not Now Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Not Now",
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
