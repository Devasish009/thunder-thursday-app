import 'package:flutter/material.dart';
import 'hall_of_lightening_screen.dart';
import 'creators_screen.dart';
import 'register_screen.dart';
import 'voting_screen.dart';
import 'about_screen.dart';
import 'student_coordinators_screen.dart';
import 'widgets/app_footer.dart';


/// 🎨 COLORS
const Color primaryGold = Color(0xFFD9A62E);

class CoordinatorsScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  CoordinatorsScreen({
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

      /// 🔥 SAME APP BAR AS UNLEASH
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

      /// 🔥 SAME WORKING DRAWER
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

              _drawerItem(context, Icons.perm_media_outlined, "Gallery", () {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AboutScreen(
                      isDark: isDark,
                      onThemeToggle: onThemeToggle,
                      onLogout: onLogout,
                    ),
                  ),
                );
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

              _drawerItem(context, Icons.groups, "Coordinators", () {}),

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

      /// 🔥 BODY (UNCHANGED)
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

            

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40),
              child: Column(
                children: [

                  const SizedBox(height: 0),

                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: "Faculty Co-",
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: "ordinators",
                          style: TextStyle(color: primaryGold),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "The Architects of Thunder Thursday",
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  _tableHeader(),
                  _tableRow("D. Kishore", "Dean SA"),
                  _tableRow("N. Ram babu", "SAC Convener"),
                  _tableRow("A. Arif", "SAC CO-Convener"),
                  _tableRow("T. Neelima", "Abhinaya Club Convener"),
                  _tableRow("Y. Sugandhi", "Abhinaya Club CO-Convener"),

                  const SizedBox(height: 80),
                  const AppFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _tableHeader() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryGold, width: 2),
        borderRadius:  BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          _HeaderCell("Name"),
          _HeaderCell("Role"),
        ],
      ),
    );
  }

  Widget _tableRow(String name, String role) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          left: BorderSide(color: primaryGold),
          right: BorderSide(color: primaryGold),
          bottom: BorderSide(color: primaryGold),
        ),
      ),
      child: Row(
        children: [
          _TableCell(name),
          _TableCell(role),
        ],
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

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: primaryGold),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryGold,
          ),
        ),
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  const _TableCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: primaryGold),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}