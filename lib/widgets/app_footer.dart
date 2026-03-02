import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Presented by",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),

          const SizedBox(height: 20),

          Wrap(
            alignment: WrapAlignment.center,
            spacing: 50,
            runSpacing: 15,
            children: [
              Image.asset(
                isDark
                ? 'assets/images/sac_logo_dark.png'
                : 'assets/images/sac_logo_light.png',
              height: 90,
              fit:BoxFit.contain,
              ),
              Image.asset(
                'assets/images/abhinaya_club_logo_light.png',
                height: 90,
                fit:BoxFit.contain,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
