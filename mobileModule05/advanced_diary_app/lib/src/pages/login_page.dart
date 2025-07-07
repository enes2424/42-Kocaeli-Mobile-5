import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../main.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Log in',
                style: TextStyle(
                  fontSize: height / 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height / 60),
              SizedBox(
                height: height / 15,
                width: 2 * width / 3,
                child: ElevatedButton.icon(
                  onPressed:
                      () => ref
                          .read(database.authenticationProvider.notifier)
                          .signInWithGoogle(context),
                  icon: Image.asset(
                    'assets/google_logo.png',
                    width: height / 22,
                    height: height / 22,
                  ),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Continue with Google',
                      style: TextStyle(
                        fontSize: height / 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 187, 65, 21),
                  ),
                ),
              ),
              SizedBox(height: height / 60),
              SizedBox(
                height: height / 15,
                width: 2 * width / 3,
                child: ElevatedButton.icon(
                  onPressed:
                      () => ref
                          .read(database.authenticationProvider.notifier)
                          .signInWithGitHub(context),
                  icon: Image.asset(
                    'assets/github_logo.png',
                    width: height / 22,
                    height: height / 22,
                  ),
                  label: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Continue with Github',
                      style: TextStyle(
                        fontSize: height / 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 187, 65, 21),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
