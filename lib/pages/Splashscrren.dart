import 'package:book_shop/pages/BottomNav.dart';
import 'package:book_shop/pages/bottonnavforuser.dart';
import 'package:book_shop/pages/login.dart';
import 'package:flutter/material.dart';// Replace with your desired screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Adjust the duration as needed
    );

    // Define the animation
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);

    // Start the animation
    _animationController.forward().whenComplete(() {
      // After the animation completes, navigate to the next screen (e.g., HomeScreen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavForUser(), // Replace BottomNav() with your desired screen
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            'assets/images/logo.png', // Replace with the correct path to your splash logo
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
