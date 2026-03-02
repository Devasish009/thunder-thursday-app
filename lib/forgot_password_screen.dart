import 'package:flutter/material.dart';
import 'services/firebase_service.dart';

const Color primaryGold = Color(0xFFD9A62E);

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final result = await FirebaseService.resetPassword(
      email: emailController.text.trim(),
    );

    setState(() => isLoading = false);

    if (mounted) {
      if (result['success'] == true) {
        // Show success dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('📧 Email Sent'),
            content: Text(
              'Password reset link has been sent to:\n\n${emailController.text}\n\nPlease check your inbox and follow the instructions.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to login
                },
                child: const Text(
                  'OK - Back to Login',
                  style: TextStyle(color: primaryGold),
                ),
              ),
            ],
          ),
        );
      } else {
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Failed to send email'),
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Top Bolt
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/images/bolt_top.png',
                width: w * 0.25,
              ),
            ),

            // Bottom Bolt
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                'assets/images/bolt_bottom.png',
                width: w * 0.30,
              ),
            ),

            // Main Content
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: h * 0.04),

                      // Back Button
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),

                      SizedBox(height: h * 0.02),

                      // Aditya Logo
                      Image.asset(
                        'assets/images/aditya_logo.png',
                        width: w * 0.8,
                      ),

                      // Thunder Thursday Logo
                      Transform.translate(
                        offset: Offset(0, -h * 0.06),
                        child: Image.asset(
                          'assets/images/thunder_thursday_logo.png',
                          width: w * 0.6,
                        ),
                      ),

                      // Tagline
                      Transform.translate(
                        offset: Offset(0, -h * 0.15),
                        child: Image.asset(
                          'assets/images/tagline_dark.png',
                          width: w * 0.5,
                        ),
                      ),

                      // Forgot Password Box
                      Transform.translate(
                        offset: Offset(0, -h * 0.13),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
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
                                  // Title
                                  const Text(
                                    'Reset Password',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  // Description
                                  const Text(
                                    'Enter your email address and we will send you a link to reset your password.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 24),

                                  // Email Field
                                  TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Email',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                      filled: true,
                                      fillColor: Color(0xFFEEEEEE),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Email required';
                                      }
                                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                          .hasMatch(value)) {
                                        return 'Enter valid email';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 20),

                                  // Send Reset Link Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryGold,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                      onPressed:
                                          isLoading ? null : handleResetPassword,
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
                                              'Send Reset Link',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Back to Login
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Remember password? ",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: const Text(
                                          "Back to Login",
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

                            // Bolt on Box
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

                      // Presented By
                      Transform.translate(
                        offset: Offset(0, -h * 0.1),
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
            ),

            // Loading Overlay
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: primaryGold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}