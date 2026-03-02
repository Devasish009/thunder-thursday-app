import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'unleash_screen.dart';
import 'hall_of_lightening_screen.dart';
import 'creators_screen.dart';
import 'register_screen.dart';
import 'voting_screen.dart';
import 'about_screen.dart';
import 'coordinators_screen.dart';
import 'home_screen.dart';
import 'widgets/app_footer.dart';
import 'student_coordinators_screen.dart';



/// 🎨 COLORS
const Color primaryGold = Color(0xFFD9A62E);

class AboutScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  AboutScreen({
    super.key,
    required this.isDark,
    required this.onThemeToggle,
    required this.onLogout,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      /// 🔥 STANDARD UNLEASH STYLE APP BAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryGold,
        leadingWidth: 50,
        leading: Padding(
          padding: const EdgeInsets.all(0),
          child: InkWell(
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);

              if (Scaffold.of(context).isDrawerOpen) {
                Navigator.pop(context);
              }
            },
            child: Image.asset(
              'assets/images/thunder_logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ],
      ),

      /// 🔥 STANDARD WORKING DRAWER
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
                    Image.asset(
                      'assets/images/thunder_logo.png',
                      width: 50,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "Thunder Thursday",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const Divider(),

              _drawerItem(context, Icons.bolt_outlined, "Register", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegistrationScreen(
                      isDark: isDark,
                      onThemeToggle: onThemeToggle,
                      onLogout: onLogout,
                    ),
                  ),
                );
              }),

              _drawerItem(context, Icons.wifi_tethering, "Live Voting", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VotingScreen(
                      isDark: isDark,
                      onThemeToggle: onThemeToggle,
                      onLogout: onLogout,
                    ),
                  ),
                );
              }),

              _drawerItem(context, Icons.photo, "Gallery", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HallOfLighteningScreen(
                      isDark: isDark,
                      onThemeToggle: onThemeToggle,
                      onLogout: onLogout,
                    ),
                  ),
                );
              }),

              _drawerItem(context, Icons.info_outline, "About", () {
                Navigator.pop(context);
              }),

              _drawerItem(context, Icons.people, "Creators", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreatorsScreen(
                      isDark: isDark,
                      onThemeToggle: onThemeToggle,
                      onLogout: onLogout,
                    ),
                  ),
                );
              }),

              _drawerItem(context, Icons.groups, "Coordinators", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CoordinatorsScreen(
                      isDark: isDark,
                      onThemeToggle: onThemeToggle,
                      onLogout: onLogout,
                    ),
                  ),
                );
              }),

              _drawerItem(context, Icons.groups, "Student Coordinators", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudentCoordinatorsScreen(
                      isDark: isDark,
                      onThemeToggle: onThemeToggle,
                      onLogout: onLogout,
                    ),
                  ),
                );
              }),

              const Spacer(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),

      /// 🔥 BODY (100% UNTOUCHED)
      body: SafeArea(
        child: Stack(
          children: [

            Positioned(
              top:0,
              right:0,
              child: Opacity(
                opacity: isDark ? 0.80 : 0.30,
                child: Image.asset(
                  'assets/images/home_screen_background_top.png',
                  width: w * 0.4,
                ),
              ),
            ),

            Positioned(
              bottom:0,
              left:0,
              child: Opacity(
                opacity: isDark ? 0.80 : 0.30,
                child: Image.asset(
                  'assets/images/home_screen_background_bottom.png',
                  width: w * 0.5,
                ),
              ),
            ),

            Positioned(
              right: -200,
              bottom: 200,
              child: Opacity(
                opacity: 0.15,
                child: Transform.rotate(
                  angle: 4.71238898,
                  child: const Text(
                    "ABOUT",
                    style: TextStyle(
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 18,
                      color: primaryGold,
                    ),
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40),
              child: Column(
                children: [

                  const SizedBox(height: 0),

                  const Text(
                    "ABOUT",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: primaryGold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: const Text(
                      "About the Thunder Thursday Event",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: Column(
                      children: [

                        Text(
                          "Thunder Thursday” aims to encourage creativity, confidence, and stage presence by providing students with an opportunity to perform in a variety of art forms including music, dance, drama, instrumental performances, mime, poetry, stand-up acts, and other innovative creative expressions. The event promises an energetic and inspiring atmosphere where passion meets performance.This initiative reflects the university’s commitment to holistic development by nurturing not only academic excellence but also artistic and cultural growth. It is an excellent opportunity for students to express themselves, overcome stage fear, and engage with the campus community in a dynamic and meaningful way.",
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.justify,
                        ),

                        const SizedBox(height: 30),
                        const AppFooter(),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.25,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: primaryGold),
      title: Text(title),
      onTap: onTap,
    );
  }
}
