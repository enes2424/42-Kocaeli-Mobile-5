import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to your',
                style: TextStyle(
                  fontSize: height / 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Diary',
                style: TextStyle(
                  fontSize: height / 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: height / 60),
              SizedBox(
                height: height / 15,
                width: width / 4,
                child: ElevatedButton(
                  onPressed: () => context.goNamed('login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 187, 65, 21),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(height / 60),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: height / 35,
                        fontFamily: 'Cursive',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
