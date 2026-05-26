import 'package:flutter/material.dart';
import 'hall_of_lightening_screen.dart';
import 'creators_screen.dart';
import 'register_screen.dart';
import 'voting_screen.dart';
import 'about_screen.dart';
import 'coordinators_screen.dart';
import 'widgets/app_footer.dart';
import 'student_coordinators_screen.dart';


/// 🎨 COLORS
const Color primaryGold = Color(0xFFD9A62E);
const Color bgLight = Color(0x00fffff5);
const Color bgDark = Color(0xFF121212);

class UnleashScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  UnleashScreen({
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

      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryGold,
        leadingWidth: 50,
        leading: Padding(
          padding: const EdgeInsets.all(0),
          child: InkWell(
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
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

              _drawerItem(
                icon: Icons.bolt_outlined,
                title: "Register",
                isDark: isDark,
                onTap: () {
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
                },
              ),
              _drawerItem(
                icon: Icons.wifi_tethering,
                title: "Live Voting",
                isDark: isDark,
                onTap: () {
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
                },
              ),
              
              _drawerItem(
                icon: Icons.perm_media_outlined,
                title: "Gallery",
                isDark: isDark,
                onTap: () {
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
                },
              ),
              _drawerItem(
                icon: Icons.info_outline,
                title: "About",
                isDark: isDark,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AboutScreen(
                        isDark : isDark,
                        onThemeToggle: onThemeToggle,
                        onLogout: onLogout,
                      ),
                    ),
                  );
                },
              ),
              _drawerItem(
                icon: Icons.people,
                title: "Creators",
                isDark: isDark,
                onTap: () {
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
                },
              ),
              _drawerItem(
                icon: Icons.groups,
                title: "Coordinators",
                isDark: isDark,
                onTap: () {
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
                },
              ),

              _drawerItem(
                icon: Icons.groups,
                title: "Student Coordinators",
                isDark: isDark,
                onTap: () {
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
                },
              ),

              const Spacer(),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SizedBox.expand(
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
                  width: w * 0.4,
                ),
              ),
            ),

              Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    "BE.\nTHE.\nNEXT.\nSTAR.",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: primaryGold.withValues(alpha: 0.1),
                      height: 1.2,
                    ),
                  ),
                ),
              ),

              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    const SizedBox(height: 40),

                    Transform.translate(
                      offset: const Offset(0, -47),
                      child: Text(
                        "UNLEASH YOUR",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                             ?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              letterSpacing: 3.0,
                            ),
                      ),
                    ),

                    Transform.translate(
                      offset: const Offset(0, -47),
                      child: const Text(
                        "INNER STAR",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: primaryGold,
                          letterSpacing: 2.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Transform.translate(
                      offset: const Offset(0, -45),
                      child: _actionCard(
                        context,
                        "APPLY",
                        "Submit your talent via the form. Be as detailed as possible about your act.",
                      ),
                    ),

                    const SizedBox(height: 15),

                    Transform.translate(
                      offset: const Offset(0, -40),
                      child: _actionCard(
                        context,
                        "SHINE",
                        "Walk on stage and unleash your inner star to the entire campus crowd.",
                      ),
                    ),

                    const SizedBox(height: 40),

                    Transform.translate(
                      offset: const Offset(0, -50),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGold,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RegistrationScreen(
                                isDark: isDark,
                                onThemeToggle: onThemeToggle,
                                onLogout: onLogout,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "Register Now",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        
                      ),
                    ),
                    const AppFooter(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({
  required IconData icon,
  required String title,
  required bool isDark,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: primaryGold),
    title: Text(title),
    onTap: onTap,
  );
}
  
  Widget _actionCard(
      BuildContext context,
      String title,
      String description) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: primaryGold, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryGold,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
