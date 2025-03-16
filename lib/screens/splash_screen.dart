// import 'package:flutter/material.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _navigateToNextScreen();
//   }

//   Future<void> _navigateToNextScreen() async {
//     // Wait for 1 second
//     await Future.delayed(const Duration(seconds: 1));

//     // Check if the widget is still mounted before proceeding
//     if (!mounted) return;

//     // Determine the next route
//     String nextRoute = RoutePaths.login; // Default route

//     try {
//       final secureStorage = getIt<SecureStorageService>();

//       // Get the intro completed status from secure storage
//       final introCompleted =
//           await secureStorage.getSecureValue(AppConstants.introCompletedKey) ==
//           'true';

//       if (!introCompleted) {
//         // Mark intro as completed for next time
//         await secureStorage.saveSecureValue(
//           AppConstants.introCompletedKey,
//           'true',
//         );
//         nextRoute = RoutePaths.intro;
//       } else {
//         // Check if user is logged in
//         final isLoggedIn = await secureStorage.isLoggedIn();
//         nextRoute = isLoggedIn ? RoutePaths.home : RoutePaths.login;
//       }
//     } catch (e) {
//       // If any error occurs, default to login screen
//       nextRoute = RoutePaths.login;
//     }

//     // Check again if the widget is still mounted before navigating
//     if (!mounted) return;

//     // Navigate to the determined route
//     context.go(nextRoute);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final backgroundColor =
//         isDarkMode ? AppColors.primary.withOpacity(0.8) : AppColors.primary;
//     final textColor = Colors.white;

//     return Scaffold(
//       body: Container(
//         color: backgroundColor,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Logo here (you can replace with your actual logo)
//               Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 10,
//                       spreadRadius: 1,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Icon(
//                   Icons.lightbulb_outline,
//                   color: AppColors.primary,
//                   size: 72,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 'Ideafy',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: textColor,
//                 ),
//               ),
//               const SizedBox(height: 24),
//               SizedBox(
//                 width: 36,
//                 height: 36,
//                 child: CircularProgressIndicator(
//                   color: textColor,
//                   strokeWidth: 3,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
