import 'package:flutter/material.dart';
import 'services/firebase_service.dart';

class EventRegistrationFormScreen extends StatefulWidget {
  final String schoolName;
  final String? subDepartment;
  final bool isDark;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  const EventRegistrationFormScreen({
    super.key,
    required this.schoolName,
    this.subDepartment,
    required this.isDark,
    required this.onThemeToggle,
    required this.onLogout,
  });

  @override
  State<EventRegistrationFormScreen> createState() =>
      _EventRegistrationFormScreenState();
}

class _EventRegistrationFormScreenState
    extends State<EventRegistrationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isLoadingProfile = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController rollController = TextEditingController();
  final TextEditingController campusController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController bhavanController = TextEditingController();

  String? selectedTalentType;
  int? selectedYear;

  final List<String> talentTypes = [
    'Singing',
    'Dancing',
    'Comedy',
    'Instrumental',
    'Drama',
    'Mimicry',
    'Beat Boxing',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final profile = await FirebaseService.getUserProfile();
    if (profile != null && mounted) {
      setState(() {
        nameController.text = profile['full_name'] ?? '';
        emailController.text = profile['email'] ?? '';
        rollController.text = profile['roll_number'] ?? '';
        campusController.text = profile['campus'] ?? '';
        branchController.text = profile['branch'] ?? '';
        departmentController.text = profile['department'] ?? '';
        phoneController.text = profile['phone'] ?? '';
        isLoadingProfile = false;
      });
    } else {
      setState(() => isLoadingProfile = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    rollController.dispose();
    campusController.dispose();
    branchController.dispose();
    departmentController.dispose();
    phoneController.dispose();
    descriptionController.dispose();
    bhavanController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedTalentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a talent type'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    final schoolLabel = widget.subDepartment != null
        ? '${widget.schoolName} - ${widget.subDepartment}'
        : widget.schoolName;

    final result = await FirebaseService.registerForEvent(
      school: schoolLabel,
      talentType: selectedTalentType!,
      participantName: nameController.text.trim(),
      talentDescription: descriptionController.text.trim(),
      bhavan: bhavanController.text.trim(),
      yearOfStudy: selectedYear,
      phone: phoneController.text.trim(),
    );

    setState(() => isLoading = false);

    if (mounted) {
      if (result['success'] == true) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              '⚡ Registration Successful!',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            content: Text(
              'You have been registered for $schoolLabel.\n\nYour registration is pending approval.',
              style: const TextStyle(color: Colors.black87, fontSize: 15),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // go back to register screen
                },
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xFFFBC02D),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? 'Registration failed'),
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

    final schoolLabel = widget.subDepartment != null
        ? '${widget.schoolName} - ${widget.subDepartment}'
        : widget.schoolName;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // ⚡ Top bolt decoration
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/images/bolt_top.png',
                width: w * 0.25,
              ),
            ),
            // ⚡ Bottom bolt decoration
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(
                'assets/images/bolt_bottom.png',
                width: w * 0.30,
              ),
            ),

            // 🔥 Main content
            SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.08),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: w * 0.06),

                      // ⚡ Thunder logo
                      Image.asset(
                        'assets/images/thunder_logo.png',
                        width: w * 0.18,
                      ),
                      const SizedBox(height: 10),

                      // 🏫 School name header
                      Text(
                        schoolLabel.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFBC02D),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'EVENT REGISTRATION',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 📋 Form card
                      isLoadingProfile
                          ? Container(
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFFBC02D),
                                ),
                              ),
                            )
                          : Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.35),
                                        blurRadius: 22,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      // --- Personal Info Section ---
                                      _sectionLabel('Personal Details'),
                                      const SizedBox(height: 8),
                                      _inputField('Participant Name',
                                          controller: nameController,
                                          validator: (v) => v!.isEmpty
                                              ? 'Name required'
                                              : null),
                                      const SizedBox(height: 10),
                                      _inputField('Email',
                                          controller: emailController,
                                          readOnly: true,
                                          keyboardType:
                                              TextInputType.emailAddress),
                                      const SizedBox(height: 10),
                                      _inputField('Phone Number',
                                          controller: phoneController,
                                          keyboardType: TextInputType.phone),
                                      const SizedBox(height: 10),
                                      _inputField('Roll Number',
                                          controller: rollController,
                                          validator: (v) => v!.isEmpty
                                              ? 'Roll number required'
                                              : null),
                                      const SizedBox(height: 10),

                                      // --- Academic Info Section ---
                                      const SizedBox(height: 6),
                                      _sectionLabel('Academic Details'),
                                      const SizedBox(height: 8),
                                      _inputField('Campus',
                                          controller: campusController,
                                          validator: (v) => v!.isEmpty
                                              ? 'Campus required'
                                              : null),
                                      const SizedBox(height: 10),
                                      _inputField('Branch',
                                          controller: branchController,
                                          validator: (v) => v!.isEmpty
                                              ? 'Branch required'
                                              : null),
                                      const SizedBox(height: 10),
                                      _inputField('Department',
                                          controller: departmentController,
                                          validator: (v) => v!.isEmpty
                                              ? 'Department required'
                                              : null),
                                      const SizedBox(height: 10),
                                      _inputField('Bhavan / Hostel',
                                          controller: bhavanController),
                                      const SizedBox(height: 10),

                                      // Year of Study dropdown
                                      _dropdownField<int>(
                                        hint: 'Year of Study',
                                        value: selectedYear,
                                        items: [1, 2, 3, 4]
                                            .map((y) => DropdownMenuItem(
                                                  value: y,
                                                  child:
                                                      Text('Year $y'),
                                                ))
                                            .toList(),
                                        onChanged: (v) =>
                                            setState(() => selectedYear = v),
                                      ),
                                      const SizedBox(height: 10),

                                      // --- Talent Info Section ---
                                      const SizedBox(height: 6),
                                      _sectionLabel('Talent Details'),
                                      const SizedBox(height: 8),

                                      // Talent type dropdown
                                      _dropdownField<String>(
                                        hint: 'Select Talent Type',
                                        value: selectedTalentType,
                                        items: talentTypes
                                            .map((t) => DropdownMenuItem(
                                                  value: t,
                                                  child: Text(t),
                                                ))
                                            .toList(),
                                        onChanged: (v) => setState(
                                            () => selectedTalentType = v),
                                      ),
                                      const SizedBox(height: 10),

                                      _inputField('Describe your talent...',
                                          controller: descriptionController,
                                          maxLines: 3),
                                      const SizedBox(height: 18),

                                      // 🔥 Register button
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
                                                vertical: 14),
                                          ),
                                          onPressed: isLoading
                                              ? null
                                              : _handleSubmit,
                                          child: isLoading
                                              ? const SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )
                                              : const Text(
                                                  'Register ⚡',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),

                                      // Back link
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: const Text(
                                          '← Back to Schools',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // ⚡ Bolt decoration on card
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

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),

            // ⬅️ Back button
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Color(0xFFFBC02D), size: 22),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Loading overlay
            if (isLoading)
              Container(
                color: Colors.black.withValues(alpha: 0.3),
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

  // ------- Reusable Widgets -------

  Widget _sectionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFBC02D),
        ),
      ),
    );
  }

  Widget _inputField(
    String hint, {
    TextEditingController? controller,
    bool readOnly = false,
    bool obscure = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      obscureText: obscure,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.black, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        fillColor: readOnly ? const Color(0xFFDDDDDD) : const Color(0xFFEEEEEE),
        border: InputBorder.none,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  Widget _dropdownField<T>({
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: Color(0xFFEEEEEE),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(hint,
              style: const TextStyle(color: Colors.grey, fontSize: 14)),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
