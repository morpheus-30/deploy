import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:seeds_ai_callmate_web_app/services/auth_service.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_button.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_textfield.dart';

class SignUp extends StatelessWidget {
  final VoidCallback onSignIn;

  const SignUp({super.key, required this.onSignIn});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController companyController = TextEditingController();
    final TextEditingController teamController = TextEditingController();
    final TextEditingController salesController = TextEditingController();
    final TextEditingController mobilenumberController =
        TextEditingController();
    final TextEditingController smsCodeController = TextEditingController();
    bool passwordVisible = true;

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
                  text: "Sign up with SeedsAI",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18),
                ),
                const SizedBox(height: 5),
                CustomText(
                    text:
                        "Create your account with SeedsAI to experiance the best.",
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 30),
                Row(
                  children: [
                    CustomText(text: "Name"),
                    CustomText(
                      text: "*",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                CustomFormField(
                  inputType: TextInputType.text,
                  controller: nameController,
                  hintText: 'Name',
                  onChanged: (value) {},
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CustomText(text: "Mobile Number"),
                    CustomText(
                      text: "*",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IntlPhoneField(
                    controller: mobilenumberController,
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
                Row(
                  children: [
                    CustomText(text: "Email ID"),
                    CustomText(
                      text: "*",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                CustomFormField(
                  inputType: TextInputType.emailAddress,
                  controller: emailController,
                  hintText: 'Your email address',
                  onChanged: (value) {},
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CustomText(text: "Password"),
                    CustomText(
                      text: "*",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                CustomFormField(
                  obscureText: passwordVisible,
                  inputType: TextInputType.text,
                  controller: passwordController,
                  hintText: 'Enter password',
                  onChanged: (value) {},
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CustomText(text: "Company Name"),
                    CustomText(
                      text: "*",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                CustomFormField(
                  inputType: TextInputType.text,
                  controller: companyController,
                  hintText: 'Company name',
                  onChanged: (value) {},
                ),
                const SizedBox(height: 10),
                CustomText(text: "Sales Code (Optional)"),
                CustomFormField(
                  inputType: TextInputType.text,
                  controller: salesController,
                  hintText: 'ABC-1234-999',
                  onChanged: (value) {},
                ),
                const SizedBox(height: 10),
                CustomButton(
                  elevatedButtonText: 'Sign Up',
                  elevatedButtonCallback: () async {
                    // Print to check the start of the callback
                    print('Sign Up button clicked');

                  final String email =
                        mobilenumberController.text.replaceAll("+91", "") +
                            "@gmail.com";
                    final String password = passwordController.text;
                    print('Email: $email');
                    print('Password: $password');

                    // Check if the user is valid
                    if (await AuthService().checkIfValidUser(email)) {
                      print('User is valid');

                      // Register the user with email and password
                      await AuthService()
                          .registerWithEmailAndPassword(email, password);
                      print('User registered successfully');

                      // Get the organization ID
                      String organizationId =
                          await FirestoreService().getOrgId(email);
                      print('Organization ID: $organizationId');

                      // Add organization details to Firestore
                      await FirestoreService().addOrgDetails({
                        'companyName': companyController.text,
                        'email': emailController.text,
                        'mobileNumber': mobilenumberController.text,
                        'name': nameController.text,
                        'salesCode': salesController.text,
                      }, organizationId);
                      print('Organization details added successfully');
                    } else {
                      // Print if the user is invalid
                      print('Invalid User');
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text('Invalid User'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      onSignIn;
                    }
                  },
                  elevatedButtonStyle: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CustomText(text: "Already have an account?"),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: onSignIn,
                      child: CustomText(
                        text: "Sign In",
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                CustomText(text: "By clicking on Sign up, I accept the"),
                Row(
                  children: [
                    InkWell(
                        child: CustomText(
                      text: "Terms & Conditions",
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    )),
                    const SizedBox(width: 4),
                    CustomText(text: "&"),
                    const SizedBox(width: 4),
                    InkWell(
                        child: CustomText(
                      text: "Privacy Policy",
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
