import 'package:flutter/material.dart';
import 'services/firebase_service.dart';
import 'home_screen.dart';

const Color primaryGold = Color(0xFFD9A62E);

class ProfileScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.isDark,
    required this.onThemeToggle,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profileData;
  int registrationCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    setState(() => isLoading = true);

    final data = await FirebaseService.getUserProfile();
    final count = await FirebaseService.getUserRegistrationCount();

    setState(() {
      profileData = data;
      registrationCount = count;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryGold,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),

       body: isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryGold))
          : profileData == null
              ? _errorWidget()
              : Stack(
                  children: [
                    // Full screen repeating background pattern
                    Positioned.fill(
                      child: Opacity(
                        opacity: widget.isDark ? 0.6 : 0.05,
                        child: Image.asset(
                          'assets/images/profile_background.png',
                        ),
                      ),
                    ),
                    // Content
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Profile Icon
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryGold, width: 3),
                              color: primaryGold.withOpacity(0.1),
                            ),
                            child: const Icon(Icons.person, size: 50, color: primaryGold),
                          ),

                          const SizedBox(height: 16),

                          // Name
                          Text(
                            profileData!['full_name'] ?? 'User',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 24),

                          // Details Card
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: primaryGold, width: 1.5),
                              color: Theme.of(context).cardColor,
                            ),
                            child: Column(
                              children: [
                                _detailRow(Icons.email, 'Email', profileData!['email'] ?? ''),
                                const Divider(height: 24),

                                _detailRow(Icons.phone, 'Phone', profileData!['phone'] ?? 'Not provided'),
                                const Divider(height: 24),

                                _detailRow(Icons.badge, 'Roll Number', profileData!['roll_number'] ?? ''),
                                const Divider(height: 24),

                                _detailRow(Icons.business, 'Campus', profileData!['campus'] ?? ''),
                                const Divider(height: 24),

                                _detailRow(Icons.school, 'Branch', profileData!['branch'] ?? ''),
                                const Divider(height: 24),

                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Registration Count
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  primaryGold.withOpacity(0.2),
                                  primaryGold.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border: Border.all(color: primaryGold, width: 1.5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.event_available, color: primaryGold, size: 28),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Event Registrations',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: primaryGold,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '$registrationCount',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Logout Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                FirebaseService.logout();
                                widget.onLogout();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => HomeScreen(
                                      userName: "User",
                                      isDark: widget.isDark,
                                      onThemeToggle: widget.onThemeToggle,
                                      onLogout: widget.onLogout,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                              icon: const Icon(Icons.logout),
                              label: const Text(
                                'Logout',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: primaryGold, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _errorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Failed to load profile'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: loadProfile,
            style: ElevatedButton.styleFrom(backgroundColor: primaryGold),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
