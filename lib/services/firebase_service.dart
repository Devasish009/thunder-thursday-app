import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== AUTH ====================

  static Future<Map<String, dynamic>> signup({
    required String email,
    required String password,
    required String fullName,
    required String rollNumber,
    required String campus,
    required String branch,
    required String department,
    String? phone,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'full_name': fullName,
          'roll_number': rollNumber,
          'campus': campus,
          'branch': branch,
          'department': department,
          'phone': phone ?? '',
          'created_at': FieldValue.serverTimestamp(),
          'email_verified': false,
        });
        return {'success': true, 'message': 'Account created! Please verify your email 📧'};
      }
      return {'success': false, 'message': 'Signup failed'};
    } on FirebaseAuthException catch (e) {
      String message = 'Signup failed';
      switch (e.code) {
        case 'email-already-in-use': message = 'Email already registered. Please login.'; break;
        case 'weak-password': message = 'Password too weak. Use at least 6 characters.'; break;
        case 'invalid-email': message = 'Invalid email address.'; break;
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;
      if (user != null) {
        if (!user.emailVerified) {
          await _auth.signOut();
          return {'success': false, 'message': 'Please verify your email first! Check inbox 📧'};
        }
        return {'success': true, 'message': 'Login successful! ⚡'};
      }
      return {'success': false, 'message': 'Login failed'};
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      switch (e.code) {
        case 'user-not-found': message = 'No account found with this email.'; break;
        case 'wrong-password': message = 'Wrong password.'; break;
        case 'invalid-credential': message = 'Invalid email or password.'; break;
        case 'too-many-requests': message = 'Too many attempts. Try later.'; break;
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  static Future<void> logout() async => await _auth.signOut();

  static User? getCurrentUser() => _auth.currentUser;

  static Future<String> getUserDisplayName() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return 'User';
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final fullName = doc.data()?['full_name'] ?? 'User';
        return fullName.toString().trim().split(' ').first;
      }
      final email = user.email ?? '';
      final username = email.split('@').first;
      final name = username.length > 4 ? username.substring(0, 4) : username;
      return name[0].toUpperCase() + name.substring(1);
    } catch (e) {
      return 'User';
    }
  }

  // GET USER PROFILE DATA
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return null;
      
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // GET REGISTRATION COUNT
  static Future<int> getUserRegistrationCount() async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return 0;
      
      final snapshot = await _firestore
          .collection('registrations')
          .where('user_id', isEqualTo: user.uid)
          .get();
      
      return snapshot.docs.length;
    } catch (e) {
      return 0;
    }
  }

  static Future<Map<String, dynamic>> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {'success': true, 'message': 'Password reset email sent! Check inbox 📧'};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': e.message ?? 'Error sending reset email'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // ==================== FIRESTORE ====================

  static Future<Map<String, dynamic>> registerForEvent({
    required String school,
    required String talentType,
    required String participantName,
    String? talentDescription,
    String? bhavan,
    int? yearOfStudy,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return {'success': false, 'message': 'Please login first'};
      
      final existing = await _firestore
          .collection('registrations')
          .where('user_id', isEqualTo: user.uid)
          .get();
      
      if (existing.docs.isNotEmpty) return {'success': false, 'message': 'Already registered!'};
      
      await _firestore.collection('registrations').add({
        'user_id': user.uid,
        'email': user.email,
        'school': school,
        'talent_type': talentType,
        'participant_name': participantName,
        'talent_description': talentDescription ?? '',
        'bhavan': bhavan ?? '',
        'year_of_study': yearOfStudy ?? 0,
        'status': 'pending',
        'registered_at': FieldValue.serverTimestamp(),
      });
      
      return {'success': true, 'message': 'Registered successfully! ⚡'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  static Future<List<Map<String, dynamic>>> getPerformances() async {
    try {
      final snapshot = await _firestore
          .collection('performances')
          .where('status', isEqualTo: 'live')
          .get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      return [];
    }
  }

  static Stream<List<Map<String, dynamic>>> getPerformancesStream() {
    return _firestore
        .collection('performances')
        .where('status', isEqualTo: 'live')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  static Future<bool> hasUserVoted(String performanceId) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return false;
      final existing = await _firestore
          .collection('votes')
          .where('user_id', isEqualTo: user.uid)
          .where('performance_id', isEqualTo: performanceId)
          .get();
      return existing.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> submitVote({
    required String performanceId,
    required int rating,
  }) async {
    try {
      final User? user = _auth.currentUser;
      if (user == null) return {'success': false, 'message': 'Please login first'};

      final already = await hasUserVoted(performanceId);
      if (already) return {'success': false, 'message': 'Already voted!'};

      await _firestore.runTransaction((transaction) async {
        final perfRef = _firestore.collection('performances').doc(performanceId);
        final perfDoc = await transaction.get(perfRef);
        if (!perfDoc.exists) return;

        final currentTotal = (perfDoc.data()?['total_score'] ?? 0) as int;
        final currentCount = (perfDoc.data()?['total_votes'] ?? 0) as int;

        final newTotal = currentTotal + rating;
        final newCount = currentCount + 1;
        final newAverage = newTotal / newCount;

        transaction.update(perfRef, {
          'total_score': newTotal,
          'total_votes': newCount,
          'average': double.parse(newAverage.toStringAsFixed(2)),
        });

        final voteRef = _firestore.collection('votes').doc();
        transaction.set(voteRef, {
          'user_id': user.uid,
          'performance_id': performanceId,
          'rating': rating,
          'voted_at': FieldValue.serverTimestamp(),
        });
      });

      return {'success': true, 'message': 'Vote submitted! ⚡'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  static Future<List<Map<String, dynamic>>> getCoordinators() async {
    try {
      final snapshot = await _firestore.collection('coordinators').get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> getHighlights() async {
    try {
      final snapshot = await _firestore.collection('highlights').get();
      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      return [];
    }
  }
  // ==================== NOTIFICATIONS ====================

// User token save చేయడం
static Future<void> saveUserFCMToken() async {
  try {
    final User? user = _auth.currentUser;
    if (user == null) return;

    final messaging = FirebaseMessaging.instance;
    final token = await messaging.getToken();
    if (token != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'fcm_token': token,
      });
    }
  } catch (e) {
    debugPrint('FCM token error: $e');
  }
}

// Notifications fetch చేయడం
static Stream<QuerySnapshot> getNotificationsStream() {
  return _firestore
      .collection('notifications')
      .orderBy('created_at', descending: true)
      .snapshots();
}

// Notification read గా mark చేయడం
static Future<void> markNotificationRead(String notificationId) async {
  try {
    final User? user = _auth.currentUser;
    if (user == null) return;
    await _firestore
        .collection('notifications')
        .doc(notificationId)
        .collection('read_by')
        .doc(user.uid)
        .set({'read_at': FieldValue.serverTimestamp()});
  } catch (e) {
    debugPrint('Mark read error: $e');
  }
}

// User ఈ notification చదివాడా check చేయడం
static Future<bool> isNotificationRead(String notificationId) async {
  try {
    final User? user = _auth.currentUser;
    if (user == null) return false;
    final doc = await _firestore
        .collection('notifications')
        .doc(notificationId)
        .collection('read_by')
        .doc(user.uid)
        .get();
    return doc.exists;
  } catch (e) {
    return false;
  }
}
}
