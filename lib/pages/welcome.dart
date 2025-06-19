import 'package:flutter/material.dart';
import '../pages/home_screen.dart';
// import image as 'assets/Note&Go.png'; // Adjust the import based on your assets structure

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    // Simulate a delay for splash screen
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen.build(context)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Image(image: AssetImage('assets/note&go.png'), height: 300),
          ],
        ),
      ),
    );
  }
}
