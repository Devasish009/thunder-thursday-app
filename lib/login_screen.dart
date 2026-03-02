import 'package:flutter/material.dart';
import 'signup_screen.dart';
import 'services/firebase_service.dart';
import 'forgot_password_screen.dart'; 

class LoginScreen extends StatefulWidget {
  final Function(String) onLoginSuccess;

  const LoginScreen({
    super.key,
    required this.onLoginSuccess,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
  if (emailController.text.trim().isEmpty ||
      passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please enter email and password'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  setState(() => isLoading = true);

  final result = await FirebaseService.login(
    email: emailController.text.trim(),
    password: passwordController.text,
  );

  if (result['success'] == true) {
    final String name = await FirebaseService.getUserDisplayName();
    setState(() => isLoading = false);
    if (mounted) {
      widget.onLoginSuccess(name);
    }
  } else {
    setState(() => isLoading = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Login failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            /// ⚡ TOP BOLT
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/images/bolt_top.png',
                width: w * 0.25,
              ),
            ),

            /// ⚡ BOTTOM BOLT
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                'assets/images/bolt_bottom.png',
                width: w * 0.30,
              ),
            ),

            /// 🔥 MAIN CONTENT
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.10),
                child: Column(
                  children: [
                    SizedBox(height: h * 0.04),

                    /// 🟠 ADITYA LOGO
                    Image.asset(
                      'assets/images/aditya_logo.png',
                      width: w * 0.8,
                    ),

                    /// ⚡ THUNDER THURSDAY
                    Transform.translate(
                      offset: Offset(0, -h * 0.12),
                      child: Image.asset(
                        'assets/images/thunder_thursday_logo.png',
                        width: w * 0.8,
                      ),
                    ),

                    /// 🖼 TAGLINE
                    Transform.translate(
                      offset: Offset(0, -h * 0.25),
                      child: Image.asset(
                        'assets/images/tagline_dark.png',
                        width: w * 0.5,
                      ),
                    ),

                    /// 🔐 LOGIN BOX
                    Transform.translate(
                      offset: Offset(0, -h * 0.23),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.35),
                                  blurRadius: 22,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _inputField('Email',
                                    controller: emailController),
                                const SizedBox(height: 12),
                                _inputField('Password',
                                    obscure: true,
                                    controller: passwordController),
                                const SizedBox(height: 8),

                                /// ✅ REMEMBER + FORGOT
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: rememberMe,
                                          activeColor: Colors.blue,
                                          onChanged: (value) {
                                            setState(() {
                                              rememberMe = value ?? false;
                                            });
                                          },
                                        ),
                                        const Text(
                                          "Remember Me",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const ForgotPasswordScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                /// 🔥 LOGIN BUTTON
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color(0xFFFBC02D),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                    ),
                                    onPressed:
                                        isLoading ? null : _handleLogin,
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            'Login',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 14),

                                /// 🆕 REGISTER NOW
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Don't have an account? ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const SignupScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Register Now",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          /// ⚡ BOLT ON LOGIN BOX
                          Positioned(
                            top: -45,
                            right: -20,
                            child: Image.asset(
                              'assets/images/bolt_middle.png',
                              width: w * 0.20,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// 🔽 PRESENTED BY
                    Transform.translate(
                      offset: Offset(0, -h * 0.20),
                      child: Column(
                        children: [
                          Text(
                            'PRESENTED BY',
                            style: TextStyle(
                              fontSize: w * 0.03,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                              color: Colors.amber,
                            ),
                          ),
                          SizedBox(height: h * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/sac_logo_dark.png',
                                width: w * 0.22,
                              ),
                              SizedBox(width: w * 0.08),
                              Image.asset(
                                'assets/images/abhinaya_club_logo_dark.png',
                                width: w * 0.22,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Loading overlay
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFFBC02D),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String hint,
      {bool obscure = false, TextEditingController? controller}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
        filled: true,
        fillColor: const Color(0xFFEEEEEE),
        border: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}
