import 'package:flutter/material.dart';
import 'services/firebase_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController rollNumberController = TextEditingController();
  final TextEditingController campusController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    rollNumberController.dispose();
    campusController.dispose();
    branchController.dispose();
    departmentController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final result = await FirebaseService.signup(
      email: emailController.text.trim(),
      password: passwordController.text,
      fullName: fullNameController.text.trim(),
      rollNumber: rollNumberController.text.trim(),
      campus: campusController.text.trim(),
      branch: branchController.text.trim(),
      department: departmentController.text.trim(),
      phone: phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
    );

    setState(() => isLoading = false);

    if (mounted) {
      if (result['success'] == true) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('📧 Verify Your Email'),
            content: Text(
              'Verification email sent to:\n\n${emailController.text}\n\nPlease check inbox and click the link, then login!',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text(
                  'OK - Go to Login',
                  style: TextStyle(color: Color(0xFFFBC02D)),
                ),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Signup failed'),
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
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset('assets/images/bolt_top.png', width: w * 0.25),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset('assets/images/bolt_bottom.png', width: w * 0.30),
            ),

            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: h * 0.04),

                      Image.asset('assets/images/aditya_logo.png', width: w * 0.8),

                      Transform.translate(
                        offset: Offset(0, -h * 0.04),
                        child: Image.asset('assets/images/thunder_thursday_logo.png', width: w * 0.5),
                      ),

                      Transform.translate(
                        offset: Offset(0, -h * 0.08),
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
                                  _inputField('Full Name', controller: fullNameController,
                                    validator: (v) => v!.isEmpty ? "Name required" : null),
                                  const SizedBox(height: 12),

                                  _inputField('Email', controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (v) {
                                      if (v!.isEmpty) return "Email required";
                                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) return "Enter valid email";
                                      return null;
                                    }),
                                  const SizedBox(height: 12),

                                  _inputField('Phone Number', controller: phoneController,
                                    keyboardType: TextInputType.phone),
                                  const SizedBox(height: 12),

                                  _inputField('Roll Number', controller: rollNumberController,
                                    validator: (v) => v!.isEmpty ? "Roll number required" : null),
                                  const SizedBox(height: 12),

                                  _inputField('Campus', controller: campusController,
                                    validator: (v) => v!.isEmpty ? "Campus required" : null),
                                  const SizedBox(height: 12),

                                  _inputField('Branch', controller: branchController,
                                    validator: (v) => v!.isEmpty ? "Branch required" : null),
                                  const SizedBox(height: 12),

                                  _inputField('Department', controller: departmentController,
                                    validator: (v) => v!.isEmpty ? "Department required" : null),
                                  const SizedBox(height: 12),

                                  _inputField('Password', controller: passwordController,
                                    obscure: true,
                                    validator: (v) => v!.length < 6 ? "Minimum 6 characters" : null),
                                  const SizedBox(height: 12),

                                  _inputField('Confirm Password', controller: confirmPasswordController,
                                    obscure: true,
                                    validator: (v) {
                                      if (v!.isEmpty) return "Confirm password";
                                      if (v != passwordController.text) return "Passwords do not match";
                                      return null;
                                    }),
                                  const SizedBox(height: 12),

                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFBC02D),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                      ),
                                      onPressed: isLoading ? null : handleSignup,
                                      child: isLoading
                                          ? const SizedBox(
                                              height: 20, width: 20,
                                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                          : const Text("Register",
                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Already have an account? ", style: TextStyle(fontSize: 12, color: Colors.black)),
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: const Text("Login",
                                          style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            Positioned(
                              top: -45,
                              right: -20,
                              child: Image.asset('assets/images/bolt_middle.png', width: w * 0.20),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator(color: Color(0xFFFBC02D))),
              ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String hint, {
    bool obscure = false,
    TextInputType? keyboardType,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.black, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: const Color(0xFFEEEEEE),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }
}
