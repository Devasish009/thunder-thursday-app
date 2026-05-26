import 'package:flutter/material.dart';
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
import 'widgets/ui_components.dart';

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
              CustomDrawerItem(icon: Icons.person, title: "Profile", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              CustomDrawerItem(icon: Icons.bolt_outlined, title: "Register", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => RegistrationScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              CustomDrawerItem(icon: Icons.wifi_tethering, title: "Live Voting", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => VotingScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              CustomDrawerItem(icon: Icons.perm_media_outlined, title: "Gallery", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => HallOfLighteningScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              CustomDrawerItem(icon: Icons.info_outline, title: "About", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              CustomDrawerItem(icon: Icons.people, title: "Creators", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CreatorsScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              CustomDrawerItem(icon: Icons.groups, title: "Coordinators", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => CoordinatorsScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              CustomDrawerItem(icon: Icons.groups, title: "Student Coordinators", isDark: isDark, onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => StudentCoordinatorsScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
              }),
              const Spacer(),
              CustomDrawerItem(icon: Icons.logout, title: "Logout", isDark: isDark, onTap: widget.onLogout),
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
                        GoldCard(
                          title: "The Legacy",
                          content: "Thunder Thursday is the heartbeat of student creativity. Every week, the campus lights up as performers take the stage in a tradition of raw talent and electric energy.",
                          buttonText: "Join the Legacy",
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => UnleashScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)));
                          },
                        ),
                        const SizedBox(height: 16),
                        GoldCard(
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
                    child: const CreativeForceSection(),
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
