import 'package:flutter/material.dart';
import 'hall_of_lightening_screen.dart';
import 'creators_screen.dart';
import 'register_screen.dart';
import 'voting_screen.dart';
import 'about_screen.dart';
import 'widgets/app_footer.dart';
import 'coordinators_screen.dart';
import 'profile_screen.dart';

/// 🎨 COLORS
const Color primaryGold = Color(0xFFD9A62E);

class StudentCoordinatorsScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  StudentCoordinatorsScreen({
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
                icon: Icons.person,
                title: "Profile",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileScreen(
                        isDark: isDark,
                        onThemeToggle: onThemeToggle,
                        onLogout: onLogout,
                      ),
                    ),
                  );
                },
              ),
              _drawerItem(
                icon: Icons.bolt_outlined,
                title: "Register",
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
                onTap: () {
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
                },
              ),
              _drawerItem(
                icon: Icons.people,
                title: "Creators",
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
                  onTap: () => Navigator.pop(context)),

              const Spacer(),

              _drawerItem(
                icon: Icons.logout,
                title: "Logout",
                onTap: onLogout,
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Opacity(
                opacity: isDark ? 0.80 : 0.30,
                child: Image.asset(
                  'assets/images/home_screen_background_top.png',
                  width: w * 0.4,
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              left: 0,
              child: Opacity(
                opacity: isDark ? 0.80 : 0.30,
                child: Image.asset(
                  'assets/images/home_screen_background_bottom.png',
                  width: w * 0.5,
                ),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  const SizedBox(height: 0),

                  // ── Page Title ──
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      children: [
                        TextSpan(
                          text: "Student Co-",
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
                    "The Core Team Behind the Energy",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  // ── Core Thunder-Team ──
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      children: [
                        TextSpan(
                          text: "Core Thunder - ",
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: "Team",
                          style: TextStyle(color: primaryGold),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  _buildCoreTable(context),

                  const SizedBox(height: 30),

                  // ── Event Co-ordinators ──
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      children: [
                        TextSpan(
                          text: "Event ",
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: "Co-ordinators",
                          style: TextStyle(color: primaryGold),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  _buildEventTable(context),

                  const SizedBox(height: 30),

                  // ── Building Co-ordinators ──
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      children: [
                        TextSpan(
                          text: "Building ",
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: "Co-ordinators",
                          style: TextStyle(color: primaryGold),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  _buildBuildingTable(context),

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

  // ── Core Thunder-Team Table ──
  Widget _buildCoreTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryGold, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _tableHeader3(context, "Name", "Role", "Bhavan"),
          const Divider(height: 1.5, thickness: 1.5, color: primaryGold),
          _tableRow3(context, "P. Manikumar", "Head", "JWB"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "R. Prem Durga Sai", "Manager", "VB"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "P. Chandra Sekhar", "Secretary", "CV"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "Chaitanya Sri Balaji Putra", "Joint Secretary", "BGB"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "K. Charan Kumar Reddy", "Treasurer", "BB"),
        ],
      ),
    );
  }

  // ── Event Co-ordinators Table ──
  Widget _buildEventTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryGold, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _tableHeader2(context, "Name", "Bhavan"),
          const Divider(height: 1.5, thickness: 1.5, color: primaryGold),
          _tableRow2(context, "K. Phani Sai", "KLB"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow2(context, "K. Meghana", "CV"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow2(context, "P. Manmadha Rao", "APC"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow2(context, "S. Pavani", "CB"),
        ],
      ),
    );
  }

  // ── Building Co-ordinators Table ──
  Widget _buildBuildingTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: primaryGold, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _tableHeader3(context, "Name", "Bhavan", "role"),
          const Divider(height: 1.5, thickness: 1.5, color: primaryGold),
          _tableRow3(context, "M. Dhakshinya", "BB", "Creative Team"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "J. Venkata Sai", "BB", "Creative Team"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "S. Sri Anjan Kumar", "BGB", "Media Publicity"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "P. Ram Karthik", "BGB", "Logistics"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "K. Suneela Srivarsha", "BGB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "V. Rakesh", "CB", "Media Publicity"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "CH. Mohith Vardhan", "CB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "K. Harshitha", "CB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "K. Durga Prasad", "CV", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "CH. Rohith Sai", "ENB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "M. Kavya Sri", "ENB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "K. Bhavitha", "FB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "P. Gnanesh Sri Mouli Mohanraj", "FS", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "P. Deeptikasree Iswarya", "FS", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "K. Ananya Chowdary", "JW", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "P. Sriya", "JW", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "Sivakumar Tharun", "KLB", "Media Publicity"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "V. Durga Lakshmi", "KLB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "V. SRG Midhilesh", "NB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "B. Geetha", "NB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "D. Madhuri", "PB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "K. Bhagya", "PB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "M. Valli", "RB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "B. Siddhardh", "RB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "M. Rahul", "RTB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "B. Sagar", "RTB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "Bhavana Kothalanka", "SOB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "R. Madhurya", "SOB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "K. Neeraja", "VB", "Member"),
          Divider(height: 1, thickness: 1, color: primaryGold.withOpacity(0.5)),
          _tableRow3(context, "G. Vijay Shankar Pani", "VB", "Member"),
        ],
      ),
    );
  }

  // ── 2-column header ──
  Widget _tableHeader2(BuildContext context, String c1, String c2) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _HeaderCell(c1),
          const VerticalDivider(thickness: 1.5, width: 1.5, color: primaryGold),
          _HeaderCell(c2),
        ],
      ),
    );
  }

  // ── 2-column row ──
  Widget _tableRow2(BuildContext context, String c1, String c2) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _TableCell(c1),
          VerticalDivider(thickness: 1, width: 1, color: primaryGold.withOpacity(0.5)),
          _TableCell(c2),
        ],
      ),
    );
  }

  // ── 3-column header ──
  Widget _tableHeader3(BuildContext context, String c1, String c2, String c3) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _HeaderCell(c1),
          const VerticalDivider(thickness: 1.5, width: 1.5, color: primaryGold),
          _HeaderCell(c2),
          const VerticalDivider(thickness: 1.5, width: 1.5, color: primaryGold),
          _HeaderCell(c3),
        ],
      ),
    );
  }

  // ── 4-column header ──
  Widget _tableHeader4(BuildContext context, String c1, String c2, String c3, String c4) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _HeaderCell(c1),
          const VerticalDivider(thickness: 1.5, width: 1.5, color: primaryGold),
          _HeaderCell(c2),
          const VerticalDivider(thickness: 1.5, width: 1.5, color: primaryGold),
          _HeaderCell(c3),
          const VerticalDivider(thickness: 1.5, width: 1.5, color: primaryGold),
          _HeaderCell(c4),
        ],
      ),
    );
  }

  // ── 3-column row ──
  Widget _tableRow3(BuildContext context, String c1, String c2, String c3) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _TableCell(c1),
          VerticalDivider(thickness: 1, width: 1, color: primaryGold.withOpacity(0.5)),
          _TableCell(c2),
          VerticalDivider(thickness: 1, width: 1, color: primaryGold.withOpacity(0.5)),
          _TableCell(c3),
        ],
      ),
    );
  }

  // ── 4-column row ──
  Widget _tableRow4(BuildContext context, String c1, String c2, String c3, String c4) {
    return IntrinsicHeight(
      child: Row(
        children: [
          _TableCell(c1),
          VerticalDivider(thickness: 1, width: 1, color: primaryGold.withOpacity(0.5)),
          _TableCell(c2),
          VerticalDivider(thickness: 1, width: 1, color: primaryGold.withOpacity(0.5)),
          _TableCell(c3),
          VerticalDivider(thickness: 1, width: 1, color: primaryGold.withOpacity(0.5)),
          _TableCell(c4),
        ],
      ),
    );
  }
}

/// ================= DRAWER ITEM =================
Widget _drawerItem({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: primaryGold),
    title: Text(title),
    onTap: onTap,
  );
}

class _HeaderCell extends StatelessWidget {
  final String text;
  const _HeaderCell(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
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
  const _TableCell(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
