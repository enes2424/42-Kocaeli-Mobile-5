import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../utils/snackbar.dart';
import '../../main.dart';

class Authentication extends StateNotifier<bool> {
  Authentication() : super(false);

  void setState(bool state) => super.state = state;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await database.supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback',
      );
    } catch (e) {
      if (context.mounted) {
        showSnackbar(context, 'Google login error: $e');
      }
    }
  }

  Future<void> signInWithGitHub(BuildContext context) async {
    try {
      await database.supabase.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: 'io.supabase.flutter://login-callback',
      );
    } catch (e) {
      if (context.mounted) {
        showSnackbar(context, 'GitHub login error: $e');
      }
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await database.supabase.auth.signOut();
    } catch (e) {
      if (context.mounted) {
        showSnackbar(context, 'Çıkış yapma hatası: $e');
      }
    }
  }
}
