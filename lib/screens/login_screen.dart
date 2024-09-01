import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/auth_provider.dart';
import 'package:seeds_ai_callmate_web_app/screens/home_screen.dart';
import 'package:seeds_ai_callmate_web_app/services/auth_service.dart';
import 'package:seeds_ai_callmate_web_app/widgets/custom_text.dart';
import 'package:seeds_ai_callmate_web_app/widgets/forgot_password.dart';
import 'package:seeds_ai_callmate_web_app/widgets/sign_up.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Make sure to import your provider

class LoginScreen extends StatefulWidget {
  final VoidCallback onForgotPassword;
  final VoidCallback onSignUp;

  const LoginScreen({
    super.key,
    required this.onForgotPassword,
    required this.onSignUp,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    bool passwordVisible = true;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: "Login to SeedsAI",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18),
                ),
                const SizedBox(height: 5),
                CustomText(
                    text: "Please enter your mobile number & password.",
                    style: const TextStyle(fontSize: 13)),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "Mobile Number"),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IntlPhoneField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            hintText: 'Enter phone number',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(),
                            ),
                          ),
                          initialCountryCode: 'IN',
                          onChanged: (phone) {},
                          validator: (value) {
                            if (value == null) {
                              return 'Phone number is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          CustomText(text: "Password"),
                          const Spacer(),
                          InkWell(
                            onTap: widget.onForgotPassword,
                            child: CustomText(
                              text: "Forgot password?",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _passwordVisible,
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Consumer<AuthenticationProvider>(
                        builder: (context, authProvider, child) {
                          return Column(
                            children: [
                              SizedBox(
                                width: double
                                    .infinity, // Ensures the button is as wide as its parent
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      String phone = _phoneController.text;
                                      String password =
                                          _passwordController.text;

                                      User? user = await AuthService()
                                          .signInWithEmailAndPassword(
                                        phone.replaceAll("+91", "") +
                                            "@gmail.com",
                                        password,
                                      );

                                      if (user == null) {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text("Error"),
                                              content: const Text(
                                                  "Invalid Credentials"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("OK"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.blue, // Button color
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ), // Text color
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 25,
                                        horizontal:
                                            20), // Adjust the vertical padding
                                    textStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  child: const Text('Sign In',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              if (authProvider.statusMessage.isNotEmpty)
                                Text(
                                  authProvider.statusMessage,
                                  style: const TextStyle(color: Colors.red),
                                ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          CustomText(text: "New to SeedsAI?"),
                          const SizedBox(width: 5),
                          InkWell(
                            onTap: widget.onSignUp,
                            child: CustomText(
                              text: "Sign Up",
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      CustomText(text: "By clicking on Login, I accept the"),
                      Row(
                        children: [
                          InkWell(
                              child: CustomText(
                            text: "Terms & Conditions",
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                          const SizedBox(width: 4),
                          CustomText(text: "&"),
                          const SizedBox(width: 4),
                          InkWell(
                              child: CustomText(
                            text: "Privacy Policy",
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )),
                        ],
                      ),
                    ],
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

/////////////////////////

class LoginBuild extends StatefulWidget {
  const LoginBuild({super.key});

  @override
  State<LoginBuild> createState() => _LoginBuildState();
}

class _LoginBuildState extends State<LoginBuild> {
  bool showForgotPassword = false;
  bool showSignUp = false;

  void toggleForgotPasswordScreen() {
    setState(() {
      showForgotPassword = !showForgotPassword;
      showSignUp = false;
    });
  }

  void toggleSignUpScreen() {
    setState(() {
      showSignUp = !showSignUp;
      showForgotPassword = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const MyHomePage();
          } else {
            return Scaffold(
              backgroundColor: const Color(0xffFDFBF9),
              body: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(padding: EdgeInsets.only(left: 20)),
                        Image.asset(
                          "assets/images/logo.png", // Add your logo image in the assets folder
                          height: 30.0,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: screenWidth > 800 ? 800 : screenWidth * 0.9,
                        height: screenHeight > 600 ? 500 : screenHeight * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          border: Border.all(color: Colors.blue, width: 0.3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: showForgotPassword
                                          ? ForgotPassword(
                                              onGoBack:
                                                  toggleForgotPasswordScreen)
                                          : showSignUp
                                              ? SignUp(
                                                  onSignIn: toggleSignUpScreen)
                                              : LoginScreen(
                                                  onForgotPassword:
                                                      toggleForgotPasswordScreen,
                                                  onSignUp: toggleSignUpScreen,
                                                ),
                                    ),
                                    const SizedBox(width: 20),
                                    const Expanded(
                                      flex: 1,
                                      child: LogImage(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CustomText(
                        text: "\u00a9 2024, Seeds AI. All Rights Reserved",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
//////////////////////////////

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LogImage extends StatefulWidget {
  const LogImage({super.key});

  @override
  State<LogImage> createState() => _LogImageState();
}

class _LogImageState extends State<LogImage> {
  final PageController _controller = PageController();
  Timer? _autoScrollTimer;

  final List<PageItem> _pages = [
    PageItem(
      imagePath: 'assets/svg/mobile_login.svg',
      title: 'Mobile Login',
      description:
          'An overlay window, with brief details about the customer before the conversation starts.',
    ),
    PageItem(
      imagePath: 'assets/svg/access_account.svg',
      title: 'Access Account',
      description:
          'An overlay window, with brief details about the customer before the conversation starts.',
    ),
    PageItem(
      imagePath: 'assets/svg/forgot_password.svg',
      title: 'Forgot Password',
      description:
          'An overlay window, with brief details about the customer before the conversation starts.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer =
        Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_controller.hasClients) {
        int nextPage = _controller.page!.round() + 1;
        if (nextPage == _pages.length) {
          nextPage = 0;
        }
        _controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6F9),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildPage(
                      _pages[index].imagePath,
                      _pages[index].title,
                      _pages[index].description,
                      constraints.maxWidth,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SmoothPageIndicator(
                  axisDirection: Axis.horizontal,
                  controller: _controller,
                  count: _pages.length,
                  effect: const WormEffect(
                    dotHeight: 8,
                    dotWidth: 16,
                    spacing: 10,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.blue,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPage(
      String imagePath, String title, String description, double maxWidth) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xffF5F6F9),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              imagePath,
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class PageItem {
  final String imagePath;
  final String title;
  final String description;

  PageItem({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}
