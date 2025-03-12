import 'package:flutter/material.dart';
import 'package:savvy_aqua_delivery/constants/color_constants.dart';
import 'package:savvy_aqua_delivery/screens/otp_screen/otp_screen.dart';
import 'package:savvy_aqua_delivery/services/auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _mobileNo = TextEditingController();
  bool _keepLoggedIn = false;

  @override
  void dispose() {
    _mobileNo.dispose(); // Dispose of the controller to prevent memory leaks
    super.dispose();
  }

  String validateData() {
    if (_mobileNo.text.isEmpty) {
      return "Fields must not be empty";
    } else if (_mobileNo.text.length != 10) {
      return "Mobile No must be 10 digits";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: false, // Prevents background image from moving
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                "assets/images/background.png",
                fit: BoxFit.cover,
              ),
            ),

            // Scrollable Content to avoid overflow
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              height:
                  MediaQuery.sizeOf(context).height, // Ensures proper height
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60), // Adjust spacing
                  const Text(
                    "Login Account",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Welcome",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/image.png", height: 250),
                  ),
                  const SizedBox(height: 20),

                  // Mobile Number Label
                  const Text(
                    "Mobile Number",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Mobile Number Input
                  Row(
                    children: [
                      SizedBox(
                        width: 55,
                        child: TextField(
                          readOnly: true,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "+91",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _mobileNo,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            label: const Text("Mobile Number"),
                            hintText: "Enter Mobile Number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (value) {
                            if (value.length == 10) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Keep me logged in Checkbox
                  Row(
                    children: [
                      Checkbox(
                        value: _keepLoggedIn,
                        onChanged: (value) {
                          setState(() {
                            _keepLoggedIn = value!;
                          });
                        },
                      ),
                      const Text("Keep me logged in"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstants.blueBorder,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: () async {
                        String message = validateData();
                        if (message.isEmpty) {
                          bool result = await Auth.login(_mobileNo.text.trim());

                          print(
                              "--------------------------------------login result: $result");

                          if (result) {
                            _mobileNo.clear();
                            // _mobileNo.dispose();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OtpScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      "Please enter registered mobile no")),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        }
                      },
                      child: const Text("Log In",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
