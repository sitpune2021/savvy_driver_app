import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:savvy_aqua_delivery/constants/color_constants.dart';
import 'package:savvy_aqua_delivery/screens/dashboard_screen/dashboard_screen.dart';
import 'package:savvy_aqua_delivery/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool resetOtp = false;
  late TextEditingController otpController;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
  }

  // @override
  // void dispose() {
  //   otpController.dispose(); // Dispose only when the widget is destroyed
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false, // Prevent background shifting
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/background.png"), // Background Image
              fit: BoxFit.cover,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight, // Ensures full height
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Verification",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "We sent a code to your Mobile Number",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/SavyLogo.png", // Ensure this image exists
                            height: 250,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Enter the code to continue",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // OTP Input Field Using Pin Code Fields
                        PinCodeTextField(
                          appContext: context,
                          length: 6,
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          textStyle: const TextStyle(fontSize: 20),
                          cursorColor: Colors.blue,
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(8),
                            fieldHeight: 50,
                            fieldWidth: 50,
                            activeFillColor: Colors.white,
                            activeColor: ColorConstants.blueBorder,
                            selectedColor: Colors.blue.shade700,
                            inactiveColor: Colors.grey.shade400,
                          ),
                          onCompleted: (v) async {
                            if (resetOtp == false) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              final otp = prefs.getString("otp");

                              if (otp == v) {
                                otpController.clear();
                                prefs.setBool("isLoggedIn", true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Login Successful")));
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardScreen()),
                                  (route) =>
                                      false, // This removes all previous routes
                                );
                              } else {
                                otpController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Incorrect OTP! Please enter a valid OTP")));
                              }
                            } else {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              // final phone = prefs.getString("phone");

                              // bool result = await Auth.login(phone!);

                              // print(
                              //     "--------------------------------------login result: $result");

                              // if (result) {
                              final otp = prefs.getString("otp");
                              if (otp == v) {
                                otpController.clear();
                                prefs.setBool("isLoggedIn", true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Login Successful")));
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DashboardScreen()),
                                  (route) =>
                                      false, // This removes all previous routes
                                );
                                setState(() {
                                  resetOtp = false;
                                });
                              } else {
                                otpController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            "Incorrect OTP! Please enter a valid OTP")));
                                setState(() {
                                  resetOtp = false;
                                });
                              }
                              // } else {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //       const SnackBar(
                              //           content: Text(
                              //               "Something went wrong please check internet connection")));
                              // }
                            }
                          },
                        ),

                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Didn’t receive the code?"),
                            TextButton(
                              onPressed: () async {
                                setState(() {
                                  resetOtp = true;
                                });
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                final phone = prefs.getString("phone");

                                bool result = await Auth.login(phone!);

                                print(
                                    "--------------------------------------login result: $result");
                              },
                              child: const Text("Send Again",
                                  style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.check, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Log In Successfull!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Set the background color
                    foregroundColor: Colors.white, // Set text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  onPressed: () {},
                  child: const Text("OK"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
