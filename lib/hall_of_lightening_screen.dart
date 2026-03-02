import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'widgets/app_footer.dart';

import 'login_screen.dart';
import 'unleash_screen.dart';
import 'creators_screen.dart';
import 'register_screen.dart';
import 'voting_screen.dart';
import 'about_screen.dart';
import 'coordinators_screen.dart';
import 'home_screen.dart';
import 'student_coordinators_screen.dart';


/// 🎨 COLORS
const Color primaryGold = Color(0xFFD9A62E);
const Color bgLight = Color(0xFFFFF5);
const Color bgDark = Color(0xFF121212);

class HallOfLighteningScreen extends StatelessWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  HallOfLighteningScreen({
    super.key,
    required this.isDark,
    required this.onThemeToggle,
    required this.onLogout,
  });

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      /// 🔥 STANDARD APP BAR
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

      /// 🔥 STANDARD DRAWER
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
                onTap: () {},
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

      /// 🔥 BODY
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            children: [
              // Background Top
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

              // Background Bottom
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

              // Main Content
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 40,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Title
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: "HALL OF ",
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: "LIGHTNING",
                              style: TextStyle(color: primaryGold),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subtitle
                    const Center(
                      child: Text(
                        "Archive of legendary performances from our community.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ⚡ IMAGE CAROUSEL
                    _buildImageCarousel(),

                    const SizedBox(height: 40),

                    // Highlight Cards
                    _highlightCard(
                      "19 FEB 2025",
                      "https://www.instagram.com/reel/DU8UxNlipxa/?igsh=MTIxNmZ6dzZ4bWdzeQ==",
                    ),
                    const SizedBox(height: 18),
                    _highlightCard(
                      "12 FEB 2025",
                      "https://www.instagram.com/reel/DUqTu4LCaEz/?igsh=ZHlmYm1jbG16OWFw",
                    ),
                    const SizedBox(height: 18),
                    _highlightCard(
                      "29 JAN 2025",
                      "https://www.instagram.com/reel/DUGSjYAEqM0/?igsh=c24zcTE5MmZ6Y3Mx",
                    ),
                    const SizedBox(height: 18),
                    _highlightCard(
                      "22 JAN 2025",
                      "https://www.instagram.com/reel/DT0LJYgAYmV/?igsh=MTc2eXZmdW9jeXVtYQ==",
                    ),
                    const SizedBox(height: 30),

                    // Footer
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

  // Drawer Item
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

  // Highlight Card
  Widget _highlightCard(String date, String link) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: primaryGold,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "THUNDERCLAPS OF",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),

          // Right Side - Link
          GestureDetector(
            onTap: () => _openLink(link),
            child: const Row(
              children: [
                Text(
                  "Highlight Reel",
                  style: TextStyle(
                    color: primaryGold,
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 6),
                Icon(
                  Icons.play_arrow,
                  color: primaryGold,
                  size: 18,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ⚡ IMAGE CAROUSEL
  Widget _buildImageCarousel() {
    // Event images from event_images folder
    final List<String> eventImages = List.generate(
      13, // Total number of images (change based on your count)
      (index) => 'assets/images/event_images/event_${index + 1}.png',
    );

    return CarouselSlider.builder(
      itemCount: eventImages.length,
      options: CarouselOptions(
        height: 250,
        viewportFraction: 0.85,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.25,
        scrollDirection: Axis.horizontal,
      ),
      itemBuilder: (context, index, realIndex) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryGold.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              eventImages[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Placeholder if image not found
                return Container(
                  color: const Color(0xFF2a2a2a),
                  child: const Center(
                    child: Icon(
                      Icons.photo_camera_outlined,
                      size: 60,
                      color: primaryGold,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}