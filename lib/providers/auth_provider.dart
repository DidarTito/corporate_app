import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? user;
  Map<String, dynamic>? _cachedProfile;

  AuthProvider() {
    _auth.authStateChanges().listen((event) {
      user = event;
      notifyListeners();
    });
  }

  Future<String?> register(String email, String password, String name) async {
    try {
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        return 'All fields are required';
      }

      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      user = cred.user;
      
      if (user != null) {
        // Save user profile to Firestore
        await _db.collection('users').doc(user!.uid).set({
          'name': name,
          'email': email,
          'createdAt': DateTime.now(),
        });
      }
      
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'Password is too weak. Use at least 6 characters';
      } else if (e.code == 'email-already-in-use') {
        return 'Email is already registered';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email address';
      }
      return 'Registration failed: ${e.message}';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return 'Email and password are required';
      }

      final cred =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      user = cred.user;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No account found for this email';
      } else if (e.code == 'wrong-password') {
        return 'Incorrect password';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email address';
      }
      return 'Login failed: ${e.message}';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    user = null;
    _cachedProfile = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getProfile({bool forceRefresh = false}) async {
    final currentUser = user ?? _auth.currentUser;
    if (currentUser == null) return null;

    // Return cached data if available and refresh is not forced
    if (!forceRefresh && _cachedProfile != null) {
      return _cachedProfile;
    }

    // Base data from FirebaseAuth – at minimum we always have email/uid
    final Map<String, dynamic> base = {
      'uid': currentUser.uid,
      'name': currentUser.displayName ?? '',
      'email': currentUser.email ?? '',
    };

    try {
      // Add timeout so UI doesn't spin forever on bad network
      final doc = await _db
          .collection('users')
          .doc(currentUser.uid)
          .get()
          .timeout(const Duration(seconds: 10));

      Map<String, dynamic> result;
      if (!doc.exists) {
        // If there's no Firestore document yet, just use base auth data
        result = base;
      } else {
        final data = doc.data() ?? <String, dynamic>{};
        // Merge so we always at least have email/uid from auth
        result = {...base, ...data};
      }

      _cachedProfile = result;
      return result;
    } on TimeoutException {
      // On timeout, fall back to whatever we have (auth + cache)
      _cachedProfile ??= base;
      return _cachedProfile;
    } on FirebaseException {
      // On Firestore errors, still show cached/auth data instead of hard error
      _cachedProfile ??= base;
      return _cachedProfile;
    } catch (_) {
      // Any other error – never crash UI, just return the best we have
      _cachedProfile ??= base;
      return _cachedProfile;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final currentUser = user ?? _auth.currentUser;
    if (currentUser == null) {
      print('[AuthProvider] updateProfile: No user found!');
      return;
    }

    print('[AuthProvider] updateProfile: Writing to users/${currentUser.uid}');
    print('[AuthProvider] updateProfile: Data = $data');

    await _db.collection('users').doc(currentUser.uid).set(
          data,
          SetOptions(merge: true),
        );

    print('[AuthProvider] updateProfile: Successfully written to Firestore!');

    // Update cache so UI reflects changes immediately
    _cachedProfile = {
      'uid': currentUser.uid,
      'name': currentUser.displayName ?? '',
      'email': currentUser.email ?? '',
      ...?_cachedProfile,
      ...data,
    };

    notifyListeners();
  }
}
