import 'package:flutter/material.dart';

const Color primaryGold = Color(0xFFD9A62E);

class CustomDrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;
  final VoidCallback onTap;

  const CustomDrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: primaryGold),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class GoldCard extends StatelessWidget {
  final String title;
  final String content;
  final String buttonText;
  final VoidCallback onPressed;
  final bool outlined;

  const GoldCard({
    super.key,
    required this.title,
    required this.content,
    required this.buttonText,
    required this.onPressed,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryGold, width: 1.5),
      ),
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
}

class CreativeForceSection extends StatelessWidget {
  const CreativeForceSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: primaryGold, width: 1.2),
        borderRadius: BorderRadius.circular(20),
      ),
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
                Image.asset(isDark ? 'assets/images/sac_logo_dark.png' : 'assets/images/sac_logo_light.png', width: 65, height: 65),
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
                Image.asset(isDark ? 'assets/images/abhinaya_club_logo_dark.png' : 'assets/images/abhinaya_club_logo_light.png', width: 65, height: 65),
                const SizedBox(width: 16),
                Expanded(child: Text("The soul of Thunder Thursday. Curation, stage management, and talent discovery.", style: Theme.of(context).textTheme.bodyMedium)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
