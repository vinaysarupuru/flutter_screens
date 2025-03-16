// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// import 'route_paths.dart';

// final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// class AppRouter {
//   static final router = GoRouter(
//     navigatorKey: _rootNavigatorKey,
//     debugLogDiagnostics: true,
//     initialLocation: RoutePaths.splash,
//     // refreshListenable: GoRouterRefreshStream(di.getIt<AuthBloc>().stream),
//     redirect: (BuildContext? context, GoRouterState state) {
//       // final authBloc = di.getIt<AuthBloc>();
//       // final authState = authBloc.state;

//       // // Don't redirect during splash screen
//       // if (state.matchedLocation == RoutePaths.splash) {
//       //   return null;
//       // }

//       // // Allow unprotected routes
//       // final isUnprotectedRoute = [
//       //   RoutePaths.login,
//       //   RoutePaths.register,
//       //   RoutePaths.forgotPassword,
//       //   RoutePaths.intro,
//       // ].contains(state.matchedLocation);

//       // if (authState is AuthenticatedState) {
//       //   // User is authenticated, redirect to home if they're trying to access auth pages
//       //   if (isUnprotectedRoute) {
//       //     return RoutePaths.home;
//       //   }
//       // } else if (authState is UnauthenticatedState) {
//       //   // User is not authenticated, redirect to login if they're trying to access protected pages
//       //   if (!isUnprotectedRoute) {
//       //     return RoutePaths.login;
//       //   }
//       // }
//       // No redirect needed
//       return null;
//     },
//     routes: [
//       GoRoute(
//         path: RoutePaths.splash,
//         name: 'splash',
//         builder: (context, state) => const SplashScreen(),
//       ),
//       GoRoute(
//         path: RoutePaths.intro,
//         name: 'intro',
//         builder: (context, state) => const IntroScreen(),
//       ),
//       GoRoute(
//         path: RoutePaths.login,
//         name: 'login',
//         builder: (context, state) => const LoginScreen(),
//       ),
//       GoRoute(
//         path: RoutePaths.register,
//         name: 'register',
//         builder: (context, state) => const RegisterScreen(),
//       ),
//       GoRoute(
//         path: RoutePaths.forgotPassword,
//         name: 'forgotPassword',
//         builder: (context, state) => const ForgotPasswordScreen(),
//       ),
//       GoRoute(
//         path: RoutePaths.profile,
//         name: 'profile',
//         builder: (context, state) => const ProfileScreen(),
//       ),
//       GoRoute(
//         path: RoutePaths.home,
//         name: 'home',
//         builder: (context, state) => const HomeScreen(),
//       ),
//       GoRoute(
//         path: RoutePaths.settings,
//         name: 'settings',
//         builder: (context, state) => const SettingsScreen(),
//       ),
//     ],
//     errorBuilder:
//         (context, state) => ErrorScreen(errorMessage: state.error?.toString()),
//   );
// }

// // Helper class to allow GoRouter to listen to BLoC state changes
// class GoRouterRefreshStream extends ChangeNotifier {
//   late final Stream<dynamic> _stream;
//   late final StreamSubscription<dynamic> _subscription;

//   GoRouterRefreshStream(Stream<dynamic> stream) : _stream = stream {
//     _subscription = _stream.listen((_) => notifyListeners());
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }
