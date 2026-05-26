import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/app_footer.dart';

import 'creators_screen.dart';
import 'register_screen.dart';
import 'voting_screen.dart';
import 'about_screen.dart';
import 'coordinators_screen.dart';
import 'student_coordinators_screen.dart';

const Color primaryGold = Color(0xFFD9A62E);

class HallOfLighteningScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  const HallOfLighteningScreen({
    super.key,
    required this.isDark,
    required this.onThemeToggle,
    required this.onLogout,
  });

  @override
  State<HallOfLighteningScreen> createState() => _HallOfLighteningScreenState();
}

class _HallOfLighteningScreenState extends State<HallOfLighteningScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentCarouselIndex = 0;

  Future<void> _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Stream<List<Map<String, dynamic>>> _highlightsStream() {
    return FirebaseFirestore.instance
        .collection('highlights')
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => {'id': d.id, ...d.data()}).toList());
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isDark = widget.isDark;

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
            child: Image.asset('assets/images/thunder_logo.png',
                fit: BoxFit.contain),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),
        ],
      ),
      drawer: _buildDrawer(isDark),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0, right: 0,
              child: Opacity(
                opacity: isDark ? 0.80 : 0.30,
                child: Image.asset(
                    'assets/images/home_screen_background_top.png',
                    width: w * 0.4),
              ),
            ),
            Positioned(
              bottom: 0, left: 0,
              child: Opacity(
                opacity: isDark ? 0.80 : 0.30,
                child: Image.asset(
                    'assets/images/home_screen_background_bottom.png',
                    width: w * 0.5),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // Title
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                            fontSize: 35, fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(
                            text: "HALL OF ",
                            style: TextStyle(
                                color: isDark ? Colors.white : Colors.black),
                          ),
                          const TextSpan(
                            text: "LIGHTNING",
                            style: TextStyle(color: primaryGold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      "Archive of legendary performances from our community.",
                      style: TextStyle(
                          color: Colors.grey, fontSize: 12, letterSpacing: 0.5),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 📸 Dynamic Photo Gallery from Firestore
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: _highlightsStream(),
                    builder: (context, snapshot) {
                      final highlights = snapshot.data ?? [];

                      if (snapshot.connectionState ==
                              ConnectionState.waiting &&
                          highlights.isEmpty) {
                        return const SizedBox(
                          height: 250,
                          child: Center(
                            child: CircularProgressIndicator(
                                color: primaryGold),
                          ),
                        );
                      }

                      if (highlights.isEmpty) {
                        // Fallback: show local carousel if no Firestore data
                        return _buildLocalCarousel();
                      }

                      // Firestore photos — show as carousel
                      return Column(
                        children: [
                          CarouselSlider.builder(
                            itemCount: highlights.length,
                            options: CarouselOptions(
                              height: 260,
                              viewportFraction: 0.85,
                              autoPlay: true,
                              autoPlayInterval:
                                  const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                                  const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.25,
                              onPageChanged: (index, _) => setState(
                                  () => _currentCarouselIndex = index),
                            ),
                            itemBuilder: (context, index, realIndex) {
                              final h = highlights[index];
                              final url = h['image_url'] ?? '';
                              final date = h['date'] ?? '';
                              final caption = h['caption'] ?? '';

                              return Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: primaryGold
                                              .withValues(alpha: 0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(20),
                                      child: url.isNotEmpty
                                          ? Image.network(
                                              url,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (_, child, progress) =>
                                                      progress == null
                                                          ? child
                                                          : Container(
                                                              color: Colors
                                                                  .grey[900],
                                                              child: const Center(
                                                                  child: CircularProgressIndicator(
                                                                      color: primaryGold,
                                                                      strokeWidth: 2)),
                                                            ),
                                              errorBuilder:
                                                  (_, __, ___) =>
                                                      Container(
                                                color:
                                                    const Color(0xFF2a2a2a),
                                                child: const Center(
                                                    child: Icon(
                                                        Icons
                                                            .photo_camera_outlined,
                                                        size: 60,
                                                        color: primaryGold)),
                                              ),
                                            )
                                          : Container(
                                              color:
                                                  const Color(0xFF2a2a2a),
                                              child: const Center(
                                                  child: Icon(
                                                      Icons
                                                          .photo_camera_outlined,
                                                      size: 60,
                                                      color: primaryGold)),
                                            ),
                                    ),
                                  ),
                                  // Date badge
                                  if (date.isNotEmpty)
                                    Positioned(
                                      bottom: 10,
                                      left: 14,
                                      child: Container(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.black
                                              .withValues(alpha: 0.6),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(date,
                                            style: const TextStyle(
                                                color: primaryGold,
                                                fontSize: 11,
                                                fontWeight:
                                                    FontWeight.bold)),
                                      ),
                                    ),
                                  // Caption badge
                                  if (caption.isNotEmpty)
                                    Positioned(
                                      bottom: 10,
                                      right: 14,
                                      child: Container(
                                        constraints: const BoxConstraints(
                                            maxWidth: 130),
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.black
                                              .withValues(alpha: 0.6),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(caption,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                            maxLines: 1,
                                            overflow:
                                                TextOverflow.ellipsis),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 12),

                          // Dot indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              highlights.length,
                              (i) => AnimatedContainer(
                                duration:
                                    const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 3),
                                width:
                                    _currentCarouselIndex == i ? 20 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _currentCarouselIndex == i
                                      ? primaryGold
                                      : Colors.grey.withValues(alpha: 0.4),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                          Text(
                            '${highlights.length} event photo${highlights.length == 1 ? '' : 's'}',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 36),

                  // Highlight Reel Cards (Instagram links)
                  const Text(
                    'HIGHLIGHT REELS',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: primaryGold),
                  ),
                  const SizedBox(height: 14),

                  _highlightCard("19 FEB 2025",
                      "https://www.instagram.com/reel/DU8UxNlipxa/?igsh=MTIxNmZ6dzZ4bWdzeQ=="),
                  const SizedBox(height: 14),
                  _highlightCard("12 FEB 2025",
                      "https://www.instagram.com/reel/DUqTu4LCaEz/?igsh=ZHlmYm1jbG16OWFw"),
                  const SizedBox(height: 14),
                  _highlightCard("29 JAN 2025",
                      "https://www.instagram.com/reel/DUGSjYAEqM0/?igsh=c24zcTE5MmZ6Y3Mx"),
                  const SizedBox(height: 14),
                  _highlightCard("22 JAN 2025",
                      "https://www.instagram.com/reel/DT0LJYgAYmV/?igsh=MTc2eXZmdW9jeXVtYQ=="),

                  const SizedBox(height: 30),
                  const AppFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fallback local carousel if no Firestore photos
  Widget _buildLocalCarousel() {
    final eventImages = List.generate(
      13,
      (i) => 'assets/images/event_images/event_${i + 1}.png',
    );
    return CarouselSlider.builder(
      itemCount: eventImages.length,
      options: CarouselOptions(
        height: 250,
        viewportFraction: 0.85,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.25,
      ),
      itemBuilder: (context, index, realIndex) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primaryGold.withValues(alpha: 0.3),
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
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF2a2a2a),
                child: const Center(
                    child: Icon(Icons.photo_camera_outlined,
                        size: 60, color: primaryGold)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _highlightCard(String date, String link) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: primaryGold, width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("THUNDERCLAPS OF",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(date,
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 10, letterSpacing: 1.2)),
            ],
          ),
          GestureDetector(
            onTap: () => _openLink(link),
            child: const Row(
              children: [
                Text("Highlight Reel",
                    style: TextStyle(color: primaryGold, fontSize: 12)),
                SizedBox(width: 6),
                Icon(Icons.play_arrow, color: primaryGold, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(bool isDark) {
    return Drawer(
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
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Divider(),
            _drawerItem(icon: Icons.bolt_outlined, title: "Register",
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => RegistrationScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)))),
            _drawerItem(icon: Icons.wifi_tethering, title: "Live Voting",
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => VotingScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)))),
            _drawerItem(icon: Icons.perm_media_outlined, title: "Gallery", onTap: () {}),
            _drawerItem(icon: Icons.info_outline, title: "About",
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => AboutScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)))),
            _drawerItem(icon: Icons.people, title: "Creators",
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => CreatorsScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)))),
            _drawerItem(icon: Icons.groups, title: "Coordinators",
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => CoordinatorsScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)))),
            _drawerItem(icon: Icons.groups, title: "Student Coordinators",
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => StudentCoordinatorsScreen(isDark: isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)))),
            const Spacer(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
        leading: Icon(icon, color: primaryGold),
        title: Text(title),
        onTap: onTap);
  }
}