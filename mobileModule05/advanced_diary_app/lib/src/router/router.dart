import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../pages/welcome_page.dart';
import '../pages/profile_page.dart';
import '../pages/agenda_page.dart';
import '../pages/login_page.dart';
import '../../main.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      bool isLoggedIn = ref.watch(database.authenticationProvider);
      if (isLoggedIn) {
        if (state.matchedLocation == '/agenda') {
          return '/agenda';
        }
        return '/profile';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: "welcome",
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/login',
        name: "login",
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return Scaffold(
            body: child,
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.black.withAlpha(150),
              selectedItemColor: const Color.fromARGB(255, 187, 65, 21),
              unselectedItemColor: Colors.white,
              currentIndex: state.matchedLocation == '/profile' ? 0 : 1,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_today),
                  label: 'Agenda',
                ),
              ],
              showSelectedLabels: false,
              showUnselectedLabels: false,
              onTap: (index) {
                if (index == 0) {
                  context.goNamed('profile');
                } else {
                  context.goNamed('agenda');
                }
              },
            ),
          );
        },
        routes: [
          GoRoute(
            path: '/profile',
            name: "profile",
            builder: (context, state) => const ProfilePage(),
          ),
          GoRoute(
            path: '/agenda',
            name: "agenda",
            builder: (context, state) => const AgendaPage(),
          ),
        ],
      ),
    ],
  );
});
