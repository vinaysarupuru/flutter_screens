import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: AuthSocialButton(
            iconPath: "assets/icon.png", // Replace with a valid asset path
            onPressed: () {
              print("hellowi");
            },
          ),
        ),
      ),
    );
  }
}

class AuthSocialButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onPressed;

  const AuthSocialButton({
    super.key,
    required this.iconPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
            width: 1.0,
          ),
        ),
        child: Center(child: Image.asset(iconPath, width: 24, height: 24)),
      ),
    );
  }
}
