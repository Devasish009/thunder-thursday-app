import 'package:flutter/material.dart';
import 'voting_screen.dart';
import 'hall_of_lightening_screen.dart';
import 'creators_screen.dart';
import 'about_screen.dart';
import 'coordinators_screen.dart';
import 'widgets/app_footer.dart';
import 'student_coordinators_screen.dart';
import 'event_registration_form_screen.dart';

const Color primaryGold = Color(0xFFD9A62E);

class RegistrationScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  const RegistrationScreen({
    super.key,
    required this.isDark,
    required this.onThemeToggle,
    required this.onLogout,
  });

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool showEngineeringSub = false;
  bool showSciencesSub = false;
  bool showPharmacySub = false;

  void _openRegistrationForm(String schoolName, {String? subDepartment}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventRegistrationFormScreen(
          schoolName: schoolName,
          subDepartment: subDepartment,
          isDark: widget.isDark,
          onThemeToggle: widget.onThemeToggle,
          onLogout: widget.onLogout,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryGold,
        leadingWidth: 100,
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: InkWell(
            onTap: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: Image.asset('assets/images/thunder_logo.png', fit: BoxFit.contain),
          ),
        ),
        actions: [
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
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Divider(),
              _drawerItem(Icons.bolt_outlined, "Register", () => Navigator.pop(context)),
              _drawerItem(Icons.wifi_tethering, "Live Voting", () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => VotingScreen(isDark: widget.isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)))),
              _drawerItem(Icons.photo_library, "Gallery", () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => HallOfLighteningScreen(isDark: widget.isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)))),
              _drawerItem(Icons.info_outline, "About", () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => AboutScreen(isDark: widget.isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)))),
              _drawerItem(Icons.people, "Creators", () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CreatorsScreen(isDark: widget.isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)))),
              _drawerItem(Icons.groups, "Coordinators", () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CoordinatorsScreen(isDark: widget.isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)))),
              _drawerItem(Icons.groups, "Student Coordinators", () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => StudentCoordinatorsScreen(isDark: widget.isDark, onThemeToggle: widget.onThemeToggle, onLogout: widget.onLogout)))),
              const Spacer(),
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
              child: Image.asset('assets/images/home_screen_background_top.png', width: w * 0.4),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset('assets/images/home_screen_background_bottom.png', width: w * 0.5),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  Text("REGISTRATION",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),

                  const SizedBox(height: 40),

                  // School of Engineering
                  _schoolContainer(
                    context: context,
                    title: "School of Engineering",
                    icon: Icons.school,
                    showSub: showEngineeringSub,
                    subButtons: const ["AUS", "ACET"],
                    onTap: () => setState(() => showEngineeringSub = !showEngineeringSub),
                    onSubButtonTap: (sub) => _openRegistrationForm(
                      'School of Engineering',
                      subDepartment: sub,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // School of Business
                  _schoolContainer(
                    context: context,
                    title: "School of Business",
                    icon: Icons.business,
                    onTap: () => _openRegistrationForm('School of Business'),
                  ),

                  const SizedBox(height: 20),

                  // School of Sciences
                  _schoolContainer(
                    context: context,
                    title: "School of Sciences",
                    icon: Icons.science,
                    showSub: showSciencesSub,
                    subButtons: const ["Forensic"],
                    onTap: () => setState(() => showSciencesSub = !showSciencesSub),
                    onSubButtonTap: (sub) => _openRegistrationForm(
                      'School of Sciences',
                      subDepartment: sub,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // School of Pharmacy
                  _schoolContainer(
                    context: context,
                    title: "School of Pharmacy",
                    icon: Icons.local_pharmacy,
                    showSub: showPharmacySub,
                    subButtons: const ["I Pharmacy", "II Pharmacy"],
                    onTap: () => setState(() => showPharmacySub = !showPharmacySub),
                    onSubButtonTap: (sub) => _openRegistrationForm(
                      'School of Pharmacy',
                      subDepartment: sub,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Polytechnic
                  _schoolContainer(
                    context: context,
                    title: "Polytechnic",
                    icon: Icons.edit,
                    onTap: () => _openRegistrationForm('Polytechnic'),
                  ),

                  const SizedBox(height: 40),
                  const AppFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: primaryGold),
      title: Text(title),
      onTap: onTap,
    );
  }

  Widget _schoolContainer({
    required BuildContext context,
    required String title,
    required IconData icon,
    bool showSub = false,
    VoidCallback? onTap,
    List<String>? subButtons,
    Function(String)? onSubButtonTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryGold, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold, color: primaryGold)),
                ),
                Icon(icon, color: primaryGold),
              ],
            ),

            if (showSub && subButtons != null && onSubButtonTap != null) ...[
              const SizedBox(height: 15),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: subButtons
                    .map((text) => _miniButton(text, () => onSubButtonTap(text)))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _miniButton(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: primaryGold,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      ),
    );
  }
}
