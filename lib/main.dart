import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'splash_video_screen.dart';
import 'login_screen.dart';
import 'home_screen.dart';

// ✅ Background message handler — main() బయట top-level function గా ఉండాలి
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Background handler register చేయండి
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const ThunderApp());
}

class ThunderApp extends StatefulWidget {
  const ThunderApp({super.key});

  @override
  State<ThunderApp> createState() => _ThunderAppState();
}

class _ThunderAppState extends State<ThunderApp> {
  bool isDark = true;
  bool isLoggedIn = false;
  String? userName;
  bool showSplash = true;

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  void loginSuccess(String name) {
    setState(() {
      userName = name;
      isLoggedIn = true;
    });
  }

  void logout() {
    setState(() {
      isLoggedIn = false;
    });
  }

  void splashFinished() {
    setState(() {
      showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),

      home: showSplash
          ? SplashVideoScreen(
              onFinished: splashFinished,
            )
          : isLoggedIn
              ? HomeScreen(
                  userName: userName ?? "User",
                  isDark: isDark,
                  onThemeToggle: toggleTheme,
                  onLogout: logout,
                )
              : LoginScreen(
                  onLoginSuccess: loginSuccess,
                ),
    );
  }
}
