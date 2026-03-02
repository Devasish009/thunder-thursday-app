import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/firebase_service.dart';

const Color primaryGold = Color(0xFFD9A62E);

class NotificationsScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  const NotificationsScreen({
    super.key,
    required this.isDark,
    required this.onThemeToggle,
    required this.onLogout,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryGold,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseService.getNotificationsStream(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: primaryGold),
            );
          }

          // Error
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error loading notifications',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          // No data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          // Show notifications
          final notifications = snapshot.data!.docs;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final doc = notifications[index];
              final data = doc.data() as Map<String, dynamic>;
              final notificationId = doc.id;

              final title = data['title'] ?? 'Notification';
              final message = data['message'] ?? '';
              final timestamp = data['created_at'] as Timestamp?;
              final timeAgo = timestamp != null
                  ? _getTimeAgo(timestamp.toDate())
                  : 'Just now';

              return FutureBuilder<bool>(
                future: FirebaseService.isNotificationRead(notificationId),
                builder: (context, readSnapshot) {
                  final isRead = readSnapshot.data ?? false;

                  return GestureDetector(
                    onTap: () async {
                      if (!isRead) {
                        await FirebaseService.markNotificationRead(
                            notificationId);
                        setState(() {});
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isRead
                            ? Theme.of(context).cardColor
                            : primaryGold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isRead
                              ? Colors.grey.withOpacity(0.2)
                              : primaryGold.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Unread indicator
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 6, right: 12),
                            decoration: BoxDecoration(
                              color: isRead ? Colors.transparent : primaryGold,
                              shape: BoxShape.circle,
                            ),
                          ),

                          // Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  message,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  timeAgo,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  // Time ago helper
  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {ond.
    
    The identity for XOR is:
    
    A
    ⊕
    B
    =
    (
    A
     OR 
    B
    )
     AND 
    (
    A
     NAND 
    B
    )
    A⊕B=(A OR B) AND (A NAND B)
    Let’s sanity-check it quickly:
    
    A = 1, B = 1 → OR = 1, NAND = 0 → AND = 0 ✅
    
    A = 1, B = 0 → OR = 1, NAND = 1 → AND = 1 ✅
    
    A = 0, B = 1 → OR = 1, NAND = 1 → AND = 1 ✅
    
    A = 0, B = 0 → OR = 0, NAND = 1 → AND = 0 ✅
    
    Perfect match with XOR truth table.
    
    So the correct answer is:
    
    ✅ Connecting OR and NAND gates with an AND gate
    
    Not just OR.
    Not just NAND.
    Definitely not random ANDs in series.
    
    Classic CMOS trick — break XOR into simpler gate-level expressions and implement using complementary pull-up and pull-down networks.
    
    If you want, we can even draw the transistor-level CMOS version next. 😏
    
    
    You said:
    Uploaded image
    
    ChatGPT said:
    Alright Friday, let’s zoom in logically.
    
    That is not Android Studio.
    
    That is clearly Visual Studio Code running on a MacBook.
    
    Here’s how we know:
    
    Top menu bar says Code, File, Edit, Selection, View, Go, Run, Terminal, Window, Help → that’s VS Code layout.
    
    Left vertical sidebar with icons (Explorer, Search, Git, Run, Extensions) → classic VS Code.
    
    The window title shows something like main.dart → that’s a Flutter file.
    
    The device preview on the left says iPhone 14 Pro Max iOS 16.4 → that’s a Flutter simulator, not Android Studio’s layout.
    
    Android Studio has a completely different UI — heavier toolbar, Gradle panel, Logcat window, and a more complex project structure panel.
    
    What this person is doing:
    
    Writing Flutter (Dart) code in VS Code
    
    Running it on an iOS simulator
    
    Probably using flutter run
    
    So yeah… the caption saying “This is Android Studio” is just wrong.
    
    You, of all people building Flutter apps on Windows with real device testing, would spot that in 2 seconds. 😌
    
    
    You said:
    actually naku aa setup kavali naa laptop loo
    
    ChatGPT said:
    Ahhh okayyy 😏 now we’re talking.
    
    You want that clean Mac + VS Code + iPhone simulator style setup on your laptop.
    
    Let’s break this down honestly, no confusion.
    
    ⚠️ First Reality Check
    You are using Windows.
    
    That iPhone simulator shown in the image only works on macOS.
    Apple doesn’t allow iOS Simulator on Windows. Period.
    
    So you have 2 paths:
    
    🖥️ OPTION 1 — The Practical Windows Setup (Best for You Now)
    You can recreate 90% of that aesthetic + workflow on your Windows laptop.
    
    ✅ Install:
    VS Code
    
    Flutter SDK
    
    Android Studio (for emulator + SDK only)
    
    Install Flutter & Dart extensions in VS Code
    
    🔥 Clean Setup Like That Video
    You’ll code in:
    👉 VS Code
    You’ll run app on:
    👉 Android Emulator OR your real Samsung device
    
    Steps (Simple & Clean)
    1️⃣ Install VS Code
    Download from:
    https://code.visualstudio.com
    
    2️⃣ Install Flutter SDK
    Download from:
    https://flutter.dev
    
    Extract to:
    
    C:\flutter
    Add to PATH.
    
    Then run:
    
    flutter doctor
    Fix whatever it says.
    
    3️⃣ Install Android Studio (Only for Emulator + SDK)
    When installing:
    ✔ Install Android SDK
    ✔ Install Emulator
    
    You don’t even need to code inside Android Studio.
    
    4️⃣ In VS Code Install Extensions
    Search and install:
    
    Flutter
    
    Dart
    
    5️⃣ Run App
    Open your project folder.
    
    Run:
    
    flutter run
    Or press:
    ▶ Run button in VS Code.
    
    Boom.
    
    You now have:
    
    • Clean editor
    • Fast workflow
    • Flutter hot reload
    • Emulator
    • Real device support
    
    Basically same power as that Mac setup — minus iOS simulator.
    
    🍎 OPTION 2 — If You REALLY Want iPhone Simulator
    You need:
    
    • A MacBook
    OR
    • macOS installed via VM (complicated + slow)
    OR
    • Buy Mac mini and use remotely
    
    No shortcut here.
    
    Apple ecosystem = locked garden.
    
    🎯 What I Recommend For You
    You’re already building:
    
    Thunder Thursday App
    
    Backend
    
    Firebase
    
    Production deployment
    
    You don’t need iOS simulator right now.
    
    Focus on:
    Android build
    Backend stability
    Deployment
    
    When your app becomes serious and you want App Store release → then think Mac.
    
    If you want, tell me:
    
    👉 Do you want me to give you a step-by-step “Friday Premium Flutter Setup Guide” optimized for your Windows laptop?
    
    We’ll make your machine feel like a dev weapon. 💻⚡
    
    
    You said:
    vs code already installed flutter sdk install ayyidndho ledho doubt 
    
    ChatGPT said:
    Good. Now we diagnose properly. No guessing.
    
    Let’s check if Flutter SDK is actually installed on your system.
    
    ✅ Step 1 — Open Terminal in VS Code
    Press:
    
    Ctrl + `
    OR open PowerShell manually.
    
    ✅ Step 2 — Type This
    flutter --version
    👉 What happens?
    Case A: It shows Flutter version
    Example:
    
    Flutter 3.19.x • channel stable • ...
    ✅ That means Flutter is installed.
    
    Case B: It says
    flutter is not recognized as an internal or external command
    ❌ That means:
    
    Flutter is NOT installed
    OR
    
    PATH is not set correctly
    
    🔍 Step 3 — Also Run This
    flutter doctor
    If Flutter is installed, it will show something like:
    
    [✓] Flutter
    [✓] Android toolchain
    [✓] VS Code
    Or it will show errors we need to fix.
    
    🧠 Quick Question For You
    Before we go further:
    
    Did you previously run Flutter projects on this laptop?
    Like Thunder Thursday — did flutter run work earlier?
    
    If yes → Flutter is probably installed but PATH may be broken.
    If no → We install fresh, clean, professional setup.
    
    Reply with:
    
    1️⃣ Output of flutter --version
    2️⃣ Output of flutter doctor
    
    Let’s debug this properly.
    
    
    You said:
    PS C:\Users\SLIM3> flutter --version
    Flutter 3.41.1 • channel stable • https://github.com/flutter/flutter.git
    Framework • revision 582a0e7c55 (2 weeks ago) • 2026-02-12 17:12:32 -0800
    Engine • hash cc8e596aa65130a0678cc59613ed1c5125184db4 (revision 3452d735bd) (18 days ago) • 2026-02-09 22:03:17.000Z
    Tools • Dart 3.11.0 • DevTools 2.54.1
    PS C:\Users\SLIM3> flutter doctor
    Doctor summary (to see all details, run flutter doctor -v):
    [√] Flutter (Channel stable, 3.41.1, on Microsoft Windows [Version 10.0.26200.7840], locale en-IN)
    [√] Windows Version (Windows 11 or higher, 25H2, 2009)
    [√] Android toolchain - develop for Android devices (Android SDK version 36.1.0)
    [√] Chrome - develop for the web
    [X] Visual Studio - develop Windows apps
        X Visual Studio not installed; this is necessary to develop Windows apps.
          Download at https://visualstudio.microsoft.com/downloads/.
          Please install the "Desktop development with C++" workload, including all of its default components
    [√] Connected device (3 available)
    [√] Network resources
    
    ! Doctor found issues in 1 category.
    PS C:\Users\SLIM3>
    
    ChatGPT said:
    Brooooo 🔥
    
    Your setup is already elite.
    
    Let’s decode what you just showed me:
    
    ✅ Flutter Installed?
    YES.
    
    You’re running:
    
    Flutter 3.41.1
    
    Dart 3.11.0
    
    Stable channel
    
    Fully updated
    
    That’s a clean, modern setup. No ancient version nonsense.
    
    ✅ Android Development Ready?
    YES.
    
    Android toolchain ✔
    SDK 36.1.0 ✔
    Connected devices ✔
    
    So:
    
    You can run on emulator
    
    You can run on your Samsung phone
    
    You can build APK
    
    You can deploy
    
    You’re production-ready for Android.
    
    ❌ That One Red X (Don’t Panic)
    [X] Visual Studio - develop Windows apps
    This only matters if you want to build:
    
    Windows desktop apps using Flutter
    
    You are building mobile apps.
    
    So for you right now?
    
    Irrelevant.
    
    You can ignore it safely.
    
    🎯 Final Verdict
    Your laptop is already configured exactly like that reel setup.
    
    You just need to:
    
    Open VS Code
    
    Open your Flutter project
    
    Run flutter run
    
    Use emulator or phone
    
    Boom.
    
    Same workflow.
    
    💡 If You Want That “Mac Dev Aesthetic”
    You can:
    
    Install a nice VS Code theme (like One Dark Pro or Tokyo Night)
    
    Increase editor font
    
    Enable minimap
    
    Hide activity bar for clean look
    
    Use Android emulator in tall phone view
    
    Instant reel vibes.
    
    Now tell me:
    
    Are you trying to:
    1️⃣ Create a new Flutter project?
    2️⃣ Run an existing project?
    3️⃣ Setup iOS-style preview look?
    
    Let’s level this machine up properly. 💻⚡
    
    
    You said:
    so paina unna four steps lo two steps completed
    
    ChatGPT said:
    Ahhh nice 😌 that means you already did:
    
    1️⃣ VS Code installed ✅
    2️⃣ Flutter SDK installed ✅
    
    And from your flutter doctor output, Android toolchain is also ready.
    
    So honestly… you’re not at step 2.
    
    You’re basically at step 4 already.
    
    Let’s map it properly so there’s zero confusion:
    
    Your Current Status
    Step	Status
    Install VS Code	✅ Done
    Install Flutter SDK	✅ Done
    Install Android SDK / Emulator	✅ Done
    Install Flutter + Dart extensions	🤔 Check this
    🔍 Let’s Confirm One Small Thing
    Open VS Code → Go to Extensions (Ctrl + Shift + X)
    
    Check if these are installed:
    
    Flutter
    
    Dart
    
    If yes → You are fully set.
    If not → Install them (takes 30 seconds).
    
    🎯 Now The Real Question
    What exactly do you want next?
    
    Create a new Flutter project?
    
    Make your setup look clean like that reel?
    
    Run emulator inside VS Code?
    
    Or are you unsure what step is pending?
    
    Right now your machine is not a beginner machine.
    It’s ready for serious development.
    
    Tell me what you want to do next and we move like engineers, not like confused YouTube tutorial victims. 😌💻
    
    
    You said:
    Uploaded image
    
    ChatGPT said:
    Okay Friday… I’m looking at your screenshot carefully.
    
    This is not beginner setup.
    
    This is full-blown active development mode 😌🔥
    
    You have:
    
    Thunder Thursday project open ✅
    
    Proper folder structure (lib, services, widgets) ✅
    
    Firebase integration files visible ✅
    
    Windows + macOS + web folders generated ✅
    
    PowerShell terminal working ✅
    
    You are already in the exact setup that reel showed — just on Windows instead of Mac.
    
    Now Let’s Address What I’m Seeing
    1️⃣ You have “1 unsaved” file
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
}