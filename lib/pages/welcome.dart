// import 'package:flutter/material.dart';
// import 'package:notegoexpense/model/sms_scan_service.dart';
// import '../pages/home_screen.dart';
// // import image as 'assets/Note&Go.png'; // Adjust the import based on your assets structure

// class WelcomePage extends StatefulWidget {
//   const WelcomePage({super.key});

//   @override
//   State<WelcomePage> createState() => _WelcomePageState();
// }

// class _WelcomePageState extends State<WelcomePage> {
//   @override
//   void initState() {
//     super.initState();
//       Future.microtask(() {
//       scanSmsAndAddTransactions(context.read);
//     });

//     // Simulate a delay for splash screen
//     Future.delayed(const Duration(seconds: 2), () {
//       if (!mounted) return;
//       Navigator.pushReplacementNamed(context, '/home');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: const <Widget>[
//             Image(image: AssetImage('assets/note&go.png'), height: 300),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notegoexpense/model/sms_scan_service.dart';

class WelcomePage extends ConsumerStatefulWidget {
  const WelcomePage({super.key});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      scanSmsAndAddTransactions(ref);
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
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
