import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/auth_provider.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/otp_reset_password.dart';
// Import the OTP screen

class ForgotPassword extends StatefulWidget {
  final VoidCallback onGoBack;

  ForgotPassword({super.key, required this.onGoBack});

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController mobileController = TextEditingController();
  bool showOTPScreen = false;

  void toggleOTPScreen() {
    setState(() {
      showOTPScreen = !showOTPScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: showOTPScreen
              ? OtpScreen(onGoBack: toggleOTPScreen)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Forgot your password?",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    CustomText(
                        text:
                            "Please enter your mobile number to reset your password.",
                        style: const TextStyle(fontSize: 13)),
                    const SizedBox(height: 30),
                    CustomText(text: "Mobile Number"),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IntlPhoneField(
                        controller: mobileController,
                        decoration: const InputDecoration(
                          hintText: 'Enter phone number',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                        initialCountryCode: 'IN',
                        onChanged: (phone) {
                          print(phone.completeNumber);
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    // CustomButton(
                    //   elevatedButtonText: 'Send OTP',
                    //   elevatedButtonCallback: toggleOTPScreen,
                    //   elevatedButtonStyle: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.blue,
                    //     foregroundColor: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius:
                    //           BorderRadius.circular(8), // Circular border
                    //     ),
                    //     textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    //   ),
                    // ),

                    Consumer<AuthenticationProvider>(
                      builder: (context, authProvider, child) {
                        return CustomButton(
                          elevatedButtonText: 'Send OTP',
                          elevatedButtonCallback: () async {
                            if (mobileController.text.isNotEmpty) {
                              await authProvider
                                  .verifyPhoneNumber(mobileController.text);
                            }
                          },
                          elevatedButtonStyle: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            textStyle:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: widget.onGoBack,
                      child: CustomText(
                        text: "Go back",
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
