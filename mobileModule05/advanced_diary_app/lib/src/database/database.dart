import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'authentication.dart';

class Database {
  SupabaseClient get supabase => Supabase.instance.client;

  final authenticationProvider = StateNotifierProvider<Authentication, bool>(
    (ref) => Authentication(),
  );

  Future<void> initialize(WidgetRef ref) async {
    await Supabase.initialize(
      url: 'https://iuwkxavzpbalisxgqodo.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml1d2t4YXZ6cGJhbGlzeGdxb2RvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTE1NDc1MDIsImV4cCI6MjA2NzEyMzUwMn0.D3mdROFm9D4leRVILExIgv1ZPRDg1bWTi7Q7QMSJ2aM',
    );

    ref
        .read(authenticationProvider.notifier)
        .setState(supabase.auth.currentSession != null);

    supabase.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn) {
        ref.read(authenticationProvider.notifier).setState(true);
      } else if (data.event == AuthChangeEvent.signedOut) {
        ref.read(authenticationProvider.notifier).setState(false);
      }
    });
  }
}
