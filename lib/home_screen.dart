import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'unleash_screen.dart';
import 'hall_of_lightening_screen.dart';
import 'creators_screen.dart';
import 'register_screen.dart';
import 'voting_screen.dart';
import 'about_screen.dart';
import 'student_coordinators_screen.dart';
import 'coordinators_screen.dart';
import 'profile_screen.dart';
import 'widgets/notification_badge.dart';
import 'notifications_screen.dart';
import 'services/firebase_service.dart';

/// 🎨 COLORS
const Color primaryGold = Color(0xFFD9A62E);
const Color bgLight = Color(0xFFFFFDF5);
const Color bgDark = Color(0xFF121212);

class HomeScreen extends StatefulWidget {
  final String userName;
  final bool isDark;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  const HomeScreen({
    super.key,
    required this.userName,
    required this.isDark,
    required this.onThemeToggle,
    required this.onLogout,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _rollNumber = '';

  @override
  void initState() {
    super.initState();
    _initFCM();
    _loadRollNumber();
  }

  Future<void> _initFCM() async {
    await FirebaseService.saveUserFCMToken();
  }

  Future<void> _loadRollNumber() async {
    final profile = await FirebaseService.getUserProfile();
    if (profile != null && mounted) {
      setState(() {
        _rollNumber = profile['roll_number'] ?? '';
      });
    }
  }

  Stream<int> _unreadCountStream() {
    return FirebaseService.getNotificationsStream().asyncMap((snapshot) async {
      int unread = 0;
      for (final doc in snapshot.docs) {
        final isRead = await FirebaseService.isNotificationRead(doc.id);
        if (!isRead) unread++;
      }
      return unread;
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryGold,
        leadingWidth: 50,
        leading: Padding(
          padding: const EdgeInsets.all(0),
          child: InkWell(
            onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: Image.asset('assets/images/thunder_logo.png', fit: BoxFit.contain),
          ),
        ),
        actions: [
          StreamBuilder<int>(
            stream: _unreadCountStream(),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return IconButton(
                icon: NotificationBadge(
                  count: count,
                  child: const Icon(Icons.notifications, color: Colors.white, size: 28),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NotificationsScreen(
                        isDark: isDark,
                        onThemeToggle: widget.onThemeToggle,
                        onLogout: widget.onLogout,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ],
      ),

      drawer: Drawer(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Image.asset('assets/images/thunder_logo.png', width: 50),
                    const SizedBox(width: 12),
                    Text("Thunder Thursday",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Divider(),
              _drawerItem(icon: Icons.person, title: "Profile", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              _drawerItem(icon: Icons.bolt_outlined, title: "Register", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RegistrationScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              _drawerItem(icon: Icons.wifi_tethering, title: "Live Voting", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => VotingScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              _drawerItem(icon: Icons.perm_media_outlined, title: "Gallery", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => HallOfLighteningScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              _drawerItem(icon: Icons.info_outline, title: "About", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              _drawerItem(icon: Icons.people, title: "Creators", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CreatorsScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              _drawerItem(icon: Icons.groups, title: "Coordinators", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CoordinatorsScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              _drawerItem(icon: Icons.groups, title: "Student Coordinators", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => StudentCoordinatorsScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              const Spacer(),
              _drawerItem(icon: Icons.logout, title: "Logout", isDark: isDark, onTap: widget.onLogout),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0, right: 0,
              child: Opacity(
                opacity: isDark ? 0.80 : 0.30,
                child: Image.asset('assets/images/home_screen_background_top.png', width: w * 0.4),
              ),
            ),
            Positioned(
              bottom: 0, left: 0,
              child: Opacity(
                opacity: isDark ? 0.80 : 0.30,
                child: Image.asset('assets/images/home_screen_background_bottom.png', width: w * 0.5),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _rollNumber.isEmpty ? "Hello, ${widget.userName.split(' ').first}" : "Hello, $_rollNumber",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: widget.onThemeToggle,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: primaryGold),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Transform.translate(
                          offset: Offset(0, -h * 0.095),
                          child: Image.asset('assets/images/thunder_thursday_logo.png', width: w * 0.8),
                        ),
                        Transform.translate(
                          offset: Offset(0, -h * 0.20),
                          child: Image.asset(
                            isDark ? 'assets/images/tagline_dark.png' : 'assets/images/tagline_light.png',
                            width: w * 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -h * 0.20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _goldCard(
                          context: context,
                          title: "The Legacy",
                          content: "Thunder Thursday is the heartbeat of student creativity. Every week, the campus lights up as performers take the stage in a tradition of raw talent and electric energy.",
                          buttonText: "Join the Legacy",
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => UnleashScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
                          },
                        ),
                        const SizedBox(height: 16),
                        _goldCard(
                          context: context,
                          title: "Event Intel",
                          content: "Join us at the Campus Hub every Thursday afternoon. The showcase brings together the entire student body.",
                          buttonText: "VIEW GALLERY",
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => HallOfLighteningScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
                          },
                        ),
                      ],
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -h * 0.15),
                    child: _creativeForceSection(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _drawerItem({required IconData icon, required String title, required bool isDark, required VoidCallback onTap}) {
  return ListTile(leading: Icon(icon, color: primaryGold), title: Text(title), onTap: onTap);
}

Widget _goldCard({required BuildContext context, required String title, required String content, required String buttonText, required VoidCallback onPressed, bool outlined = false}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: primaryGold, width: 1.5)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryGold)),
        const SizedBox(height: 10),
        Text(content, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: outlined ? Colors.transparent : primaryGold,
              foregroundColor: outlined ? primaryGold : Colors.black,
              side: outlined ? const BorderSide(color: primaryGold) : BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: onPressed,
            child: Text(buttonText, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    ),
  );
}

Widget _creativeForceSection(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(border: Border.all(color: primaryGold, width: 1.2), borderRadius: BorderRadius.circular(20)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("POWERING THE STAGE", style: Theme.of(context).textTheme.bodySmall?.copyWith(letterSpacing: 1.8, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            children: const [
              TextSpan(text: "THE CREATIVE "),
              TextSpan(text: "FORCE", style: TextStyle(color: primaryGold)),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(border: Border.all(color: primaryGold), borderRadius: BorderRadius.circular(16)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(Theme.of(context).brightness == Brightness.dark ? 'assets/images/sac_logo_dark.png' : 'assets/images/sac_logo_light.png', width: 65, height: 65),
              const SizedBox(width: 16),
              Expanded(child: Text("The central nervous system of campus life, ensuring every event reaches its peak potential.", style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(border: Border.all(color: primaryGold), borderRadius: BorderRadius.circular(16)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(Theme.of(context).brightness == Brightness.dark ? 'assets/images/abhinaya_club_logo_dark.png' : 'assets/images/abhinaya_club_logo_light.png', width: 65, height: 65),
              const SizedBox(width: 16),
              Expanded(child: Text("The soul of Thunder Thursday. Curation, stage management, and talent discovery.", style: Theme.of(context).textTheme.bodyMedium)),
            ],
          ),
        ),
      ],
    ),
  );
}
