import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'widgets/app_footer.dart';
import 'home_screen.dart';
import 'unleash_screen.dart';
import 'hall_of_lightening_screen.dart';
import 'register_screen.dart';
import 'voting_screen.dart';
import 'about_screen.dart';
import 'coordinators_screen.dart';
import 'student_coordinators_screen.dart';

/// 🎨 COLORS
const Color primaryGold = Color(0xFFD9A62E);

class CreatorsScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  CreatorsScreen({
    super.key,
    required this.isDark,
    required this.onThemeToggle,
    required this.onLogout,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  /// 🔥 LINK OPENER (WORKING)
  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      /// 🔥 APP BAR (UNCHANGED)
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

      /// 🔥 DRAWER (NOT TOUCHED)
      drawer: Drawer(
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.all(20),
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
                          ?.copyWith(
                              fontWeight:
                                  FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const Divider(),

              _drawerItem(context,
                  Icons.bolt_outlined, "Register", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        RegistrationScreen(
                      isDark: isDark,
                      onThemeToggle:
                          onThemeToggle,
                      onLogout: onLogout,
                    ),
                  ),
                );
              }),

              _drawerItem(context,
                  Icons.wifi_tethering,
                  "Live Voting", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        VotingScreen(
                      isDark: isDark,
                      onThemeToggle:
                          onThemeToggle,
                      onLogout: onLogout,
                    ),
                  ),
                );
              }),

              _drawerItem(context,
                  Icons.perm_media_outlined,
                  "Gallery", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        HallOfLighteningScreen(
                      isDark: isDark,
                      onThemeToggle:
                          onThemeToggle,
                      onLogout: onLogout,
                    ),
                  ),
                );
              }),

              _drawerItem(context,
                  Icons.info_outline,
                  "About", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AboutScreen(
                      isDark: isDark,
                      onThemeToggle:
                          onThemeToggle,
                      onLogout: onLogout,
                    ),
                  ),
                );
              }),

              _drawerItem(context,
                  Icons.people,
                  "Creators", () {}),

              _drawerItem(context,
                  Icons.groups,
                  "Coordinators", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        CoordinatorsScreen(
                      isDark: isDark,
                      onThemeToggle:
                          onThemeToggle,
                      onLogout: onLogout,
                    ),
                  ),
                );
              }),

              _drawerItem(context,
                  Icons.groups,
                  "Student Coordinators", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        StudentCoordinatorsScreen(
                      isDark: isDark,
                      onThemeToggle:
                          onThemeToggle,
                      onLogout: onLogout,
                    ),
                  ),
                );
              }),
                        

              const Spacer(),

              _drawerItem(context,
                  Icons.logout,
                  "Logout", () {
                onLogout();
              }),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),

      /// 🔥 BODY FULL RESTORED
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

            /// 🔥 WATERMARK BACK
            Positioned(
              right: -255,
              bottom: 240,
              child: Opacity(
                opacity: 0.15,
                child: Transform.rotate(
                  angle: 4.71238898,
                  child: const Text(
                    "CREATORS",
                    style: TextStyle(
                      fontSize: 100,
                      fontWeight:
                          FontWeight.bold,
                      letterSpacing: 8,
                      color: primaryGold,
                    ),
                  ),
                ),
              ),
            ),

            SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  /// 🔥 APP CREATORS HEADING
                  Transform.translate(
                    offset:
                        const Offset(0, -60),
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            style:
                                const TextStyle(
                              fontSize: 28,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                            children: [
                              TextSpan(
                                text: "APP ",
                                style: TextStyle(
                                  color: Theme.of(
                                          context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    "CREATORS⚡",
                                style:
                                    TextStyle(
                                  color:
                                      primaryGold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                            height: 6),
                        Text(
                          "People Behind the Thunder Thursday App",
                          style: Theme.of(
                                  context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  fontSize: 11),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Transform.translate(
                    offset:
                        const Offset(0, -50),
                    child: Column(
                      children: [

                        _creatorCard(
                          context,
                          "Sriram Pinninti",
                          "A second-year undergraduate specializing in Artificial Intelligence and Machine Learning. I’m focused on building strong skills in programming, data, designing, and real-world projects to grow as a tech professional.",
                          "https://github.com/SP-1512",
                          "https://instagram.com/sriram.pinninti/",
                          "https://linkedin.com/in/sriram-pinninti",
                        ),

                        const SizedBox(height: 30),

                        _creatorCard(
                          context,
                          "Devasish Jajimoggala",
                          "Second-year Computer Science Engineering student driven by curiosity and real-world development.Actively improving programming and software development skills through practical projects and continuous learning.",
                          "https://github.com/Devasish009",
                          "https://instagram.com/_devasish_009/",
                          "https://linkedin.com/in/devasishvenkatsaijajimoggala",
                        ),

                        const SizedBox(height: 30),

                        _creatorCard(
                          context,
                          "Charan Kondavaripalli",
                          "A second-year undergraduate in Artificial Intelligence and Machine Learning with a strong interest in practical problem-solving. Actively developing skills in programming, data analysis, and hands-on projects to prepare for real-world tech challenges.",
                          "https://github.com/kumarcharanreddy",
                          "https://instagram.com/charan.3665/",
                          "https://www.linkedin.com/in/charan-kumar-reddy-kondavaripalli-a824a0336",

                          
                        ),
                        const AppFooter(),
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

  /// 🔥 DRAWER ITEM
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

  /// 🔥 CREATOR CARD FIXED
  Widget _creatorCard(
  BuildContext context,
  String name,
  String description,
  String github,
  String instagram,
  String linkedin,
) {
  List<String> parts = name.split(" ");

  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: primaryGold, width: 1.5),
      color: Theme.of(context).cardColor,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔥 NAME (First normal, Second gold)
        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: parts.first + " ",
                  style: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color,
                  ),
                ),
                TextSpan(
                  text: parts.sublist(1).join(" "),
                  style: const TextStyle(
                    color: primaryGold,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall,
        ),

        const SizedBox(height: 20),

        /// 🔥 SOCIAL ROW (LOGOS BACK)
        Row(
          children: [
            GestureDetector(
              onTap: () => _openLink(github),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/github_logo.png',
                    width: 22,
                    height: 22,
                  ),
                  const SizedBox(width: 6),
                  const Text("GitHub"),
                ],
              ),
            ),

            const SizedBox(width: 40),

            GestureDetector(
              onTap: () => _openLink(instagram),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/instagram_logo.png',
                    width: 22,
                    height: 22,
                  ),
                  const SizedBox(width: 6),
                  const Text("Instagram"),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        GestureDetector(
          onTap: () => _openLink(linkedin),
          child: Row(
            children: [
              Image.asset(
                'assets/images/linkedin_logo.png',
                width: 22,
                height: 22,
              ),
              const SizedBox(width: 6),
              const Text("LinkedIn"),
            ],
          ),
        ),
      ],
    ),
  );
}

}
