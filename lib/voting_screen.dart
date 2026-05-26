import 'package:flutter/material.dart';
import 'hall_of_lightening_screen.dart';
import 'creators_screen.dart';
import 'register_screen.dart';
import 'about_screen.dart';
import 'coordinators_screen.dart';
import 'home_screen.dart';
import 'services/firebase_service.dart';
import 'dart:async';

const Color primaryGold = Color(0xFFD9A62E);

class VotingScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogout;

  const VotingScreen({
    super.key,
    required this.isDark,
    required this.onThemeToggle,
    required this.onLogout,
  });

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> performances = [];
  Map<String, int> ratings = {};
  Map<String, bool> submitted = {};
  bool isLoading = true;
  bool isSubmitting = false;
  StreamSubscription<List<Map<String, dynamic>>>? _performancesSubscription;

  // Track which performance IDs we've already fetched vote status for
  // to avoid re-fetching on every stream update
  final Set<String> _voteFetchedIds = {};

  @override
  void initState() {
    super.initState();
    _subscribeToPerformances();
  }

  @override
  void dispose() {
    _performancesSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _subscribeToPerformances() async {
    // Only show loading on first load, not on re-subscribe
    if (performances.isEmpty) {
      setState(() => isLoading = true);
    }

    await _performancesSubscription?.cancel();
    _voteFetchedIds.clear();

    _performancesSubscription =
        FirebaseService.getPerformancesStream().listen((performanceList) async {
      // Save current scroll position
      final double currentScroll =
          _scrollController.hasClients ? _scrollController.offset : 0.0;

      // Only fetch vote status for NEW performances (not already fetched)
      final newPerformances = performanceList
          .where((p) => !_voteFetchedIds.contains(p['id'] as String))
          .toList();

      final newSubmitted = <String, bool>{};
      final newRatings = <String, int>{};

      // Fetch vote status only for new ones
      for (var p in newPerformances) {
        final id = p['id'] as String;
        final voted = await FirebaseService.hasUserVoted(id);
        newSubmitted[id] = voted;
        newRatings[id] = ratings[id] ?? 0;
        _voteFetchedIds.add(id);
      }

      if (!mounted) return;

      setState(() {
        performances = performanceList;

        // Merge: keep existing submitted/ratings, add new ones
        for (var p in performanceList) {
          final id = p['id'] as String;
          if (newSubmitted.containsKey(id)) {
            submitted[id] = newSubmitted[id]!;
            ratings[id] = newRatings[id]!;
          }
          // If already exists, keep current values (don't reset)
        }

        // Remove IDs that are no longer in the list
        submitted.removeWhere(
            (key, _) => !performanceList.any((p) => p['id'] == key));
        ratings.removeWhere(
            (key, _) => !performanceList.any((p) => p['id'] == key));

        isLoading = false;
      });

      // Restore scroll position after frame renders
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients &&
            currentScroll > 0 &&
            _scrollController.position.maxScrollExtent >= currentScroll) {
          _scrollController.jumpTo(currentScroll);
        }
      });
    });
  }

  Future<void> submitVoteForPerformance(String performanceId) async {
    final rating = ratings[performanceId] ?? 0;

    if (rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please give a star rating first! ⭐'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => isSubmitting = true);

    final result = await FirebaseService.submitVote(
      performanceId: performanceId,
      rating: rating,
    );

    setState(() {
      isSubmitting = false;
      if (result['success'] == true) {
        submitted[performanceId] = true;
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? ''),
          backgroundColor:
              result['success'] == true ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(
                    userName: "User",
                    isDark: widget.isDark,
                    onThemeToggle: widget.onThemeToggle,
                    onLogout: widget.onLogout,
                  ),
                ),
                (route) => false,
              );
            },
            child: Image.asset('assets/images/thunder_logo.png',
                fit: BoxFit.contain),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _voteFetchedIds.clear();
              _subscribeToPerformances();
            },
          ),
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
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => RegistrationScreen(
                              isDark: widget.isDark,
                              onThemeToggle: widget.onThemeToggle,
                              onLogout: widget.onLogout)))),
              _drawerItem(
                  icon: Icons.wifi_tethering,
                  title: "Live Voting",
                  onTap: () => Navigator.pop(context)),
              _drawerItem(
                  icon: Icons.perm_media_outlined,
                  title: "Gallery",
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => HallOfLighteningScreen(
                              isDark: widget.isDark,
                              onThemeToggle: widget.onThemeToggle,
                              onLogout: widget.onLogout)))),
              _drawerItem(
                  icon: Icons.info_outline,
                  title: "About",
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => AboutScreen(
                              isDark: widget.isDark,
                              onThemeToggle: widget.onThemeToggle,
                              onLogout: widget.onLogout)))),
              _drawerItem(
                  icon: Icons.people,
                  title: "Creators",
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CreatorsScreen(
                              isDark: widget.isDark,
                              onThemeToggle: widget.onThemeToggle,
                              onLogout: widget.onLogout)))),
              _drawerItem(
                  icon: Icons.groups,
                  title: "Coordinators",
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CoordinatorsScreen(
                              isDark: widget.isDark,
                              onThemeToggle: widget.onThemeToggle,
                              onLogout: widget.onLogout)))),
              const Spacer(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: primaryGold))
            : performances.isEmpty
                ? _noPerformancesWidget()
                : SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.red),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.circle,
                                      color: Colors.red, size: 10),
                                  SizedBox(width: 6),
                                  Text("LIVE",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text("VOTE NOW",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(
                            "Make your vote count like thunder in the sky ⚡",
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center),
                        const SizedBox(height: 24),
                        ...performances.map((p) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _performanceCard(p),
                            )),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _noPerformancesWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_tethering_off, size: 80, color: primaryGold),
          const SizedBox(height: 16),
          Text("No Live Performances Yet",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Vote Here After the Performance! ⚡",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _voteFetchedIds.clear();
              _subscribeToPerformances();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGold,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            icon: const Icon(Icons.refresh),
            label: const Text("Refresh"),
          ),
        ],
      ),
    );
  }

  Widget _performanceCard(Map<String, dynamic> performance) {
    final String id = performance['id'];
    final String name = performance['name'] ?? 'Performance';
    final String type = performance['type'] ?? '';
    final bool isVoted = submitted[id] ?? false;
    final int currentRating = ratings[id] ?? 0;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: isVoted ? Colors.green : primaryGold, width: 1.5),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              if (type.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primaryGold),
                  ),
                  child: Text(type,
                      style: const TextStyle(
                          color: primaryGold,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                5,
                (i) => IconButton(
                      onPressed: isVoted
                          ? null
                          : () => setState(() => ratings[id] = i + 1),
                      icon: Icon(
                          i < currentRating ? Icons.star : Icons.star_border,
                          color: primaryGold,
                          size: 32),
                    )),
          ),
          const SizedBox(height: 8),
          isVoted
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 18),
                      SizedBox(width: 6),
                      Text("Vote Submitted ✅",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSubmitting
                        ? null
                        : () => submitVoteForPerformance(id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGold,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : const Text("Submit Vote ⚡",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
        ],
      ),
    );
  }
}

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
