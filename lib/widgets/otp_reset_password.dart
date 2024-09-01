import 'package:flutter/material.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_textfield.dart';

class OtpScreen extends StatefulWidget {
  final VoidCallback onGoBack;

  const OtpScreen({super.key, required this.onGoBack});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Column(
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
                CustomText(text: "OTP"),
                CustomFormField(
                  // obscureText: passwordVisible,
                  inputType: TextInputType.text,
                  controller: otpController,
                  hintText: 'Enter OTP', onChanged: (value) {},
                ),
                CustomText(text: "4 digit OTP has sent to +91123456789"),
                const SizedBox(height: 10),
                CustomText(text: "Password"),
                CustomFormField(
                  obscureText: passwordVisible,
                  inputType: TextInputType.text,
                  controller: passwordController,
                  hintText: 'Enter password',
                  onChanged: (value) {},
                ),
                const SizedBox(height: 10),
                CustomText(text: "Confirm Password"),
                CustomFormField(
                  obscureText: passwordVisible,
                  inputType: TextInputType.text,
                  controller: confirmpasswordController,
                  hintText: 'Re enter password',
                  onChanged: (value) {},
                ),
                const SizedBox(height: 10),
                CustomButton(
                  elevatedButtonText: 'Save Password',
                  elevatedButtonCallback: () {
                    // Handle OTP verification and password reset
                  },
                  elevatedButtonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Circular border
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
      ),
    );
  }
}
