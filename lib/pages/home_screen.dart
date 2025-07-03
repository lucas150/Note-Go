// // // import 'package:flutter/material.dart';
// // // import 'package:notegoexpense/widgets/BottomBar.dart';

// // // class HomeScreen extends StatelessWidget {
// // //   const HomeScreen({super.key});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('Home'),
// // //       ),
// // //       body: Center(
// // //         child: Column(
// // //           mainAxisAlignment: MainAxisAlignment.center,
// // //           children: <Widget>[
// // //             const Text(
// // //               'Welcome to Note&Go - Expense Tracker',
// // //               style: TextStyle(fontSize: 24),
// // //             ),
// // //             const SizedBox(height: 20),
// // //             ElevatedButton(
// // //               onPressed: () {
// // //                 // Navigate to Add Transaction Screen
// // //                 Navigator.pushNamed(context, '/addTransaction');
// // //               },
// // //               child: const Text('Add Transaction'),
// // //             ),
// // //             ElevatedButton(
// // //                 onPressed: () {
// // //                   Navigator.pushNamed(context, '/ledger');
// // //                   // HiveInspector.openHiveBox('transactions');
// // //                 },
// // //                 child: const Text('View Ledger')),
// // //             ElevatedButton(
// // //               onPressed: () {
// // //                 // Navigate to Account Management Screen
// // //                 Navigator.pushNamed(context, '/accountManagement');
// // //               },
// // //               child: const Text('Manage Accounts'),
// // //             ),
// // //             ElevatedButton(
// // //               onPressed: () {
// // //                 // Navigate to Hive Debug Screen
// // //                 Navigator.pushNamed(context, '/hiveDebug');
// // //               },
// // //               child: const Text('Hive Debug'),
// // //             ),
// // //             ElevatedButton(
// // //               onPressed: () {
// // //                 // Navigate to Settings Screen
// // //                 Navigator.pushNamed(context, '/settings');
// // //               },
// // //               child: const Text('Settings'),
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //       bottomNavigationBar: BottomBar(
// // //         currentIndex: 0, // Transactions tab is selected
// // //         onTap: (index) {
// // //           _handleBottomNavigation(context, index);
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }

// // // void _handleBottomNavigation(BuildContext context, int index) {
// // //   String route;
// // //   if (index == 0)
// // //     route = '/home';
// // //   else if (index == 1)
// // //     route = '/ledger';
// // //   else if (index == 2)
// // //     route = '/accountManagement';
// // //   else
// // //     route = '/settings';

// // //   if (ModalRoute.of(context)?.settings.name != route) {
// // //     Navigator.pushNamed(context, route);
// // //   }
// // // }

// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import if you use Riverpod in HomeScreen
// // import 'package:notegoexpense/widgets/BottomBar.dart';
// // import '../extras/AppColors.dart'; // Ensure this path is correct

// // // Import your four main pages
// // import 'package:notegoexpense/pages/ledger.dart';
// // import 'package:notegoexpense/pages/statistics_page.dart'; // Create this file if it doesn't exist
// // import 'package:notegoexpense/pages/account_management.dart'; // Create this file if it doesn't exist
// // import 'package:notegoexpense/pages/SettingPage/settings.dart'; // Create this file if it doesn't exist

// // class HomeScreen extends ConsumerStatefulWidget {
// //   // Changed to ConsumerStatefulWidget
// //   const HomeScreen({super.key});

// //   @override
// //   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends ConsumerState<HomeScreen> {
// //   int _selectedIndex = 0; // Tracks the current selected tab index

// //   // List of the main pages to display
// //   final List<Widget> _pages = [
// //     const LedgerPage(), // Index 0: Transactions (Ledger)
// //     const StatisticsPage(), // Index 1: Statistics
// //     const AccountManagementPage(), // Index 2: Account
// //     const Settings(), // Index 3: Settings
// //   ];

// //   // Method to update the selected index when a BottomBar item is tapped
// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     // Apply your main app theme here once
// //     return Theme(
// //       data: ThemeData(
// //         brightness: Brightness.dark,
// //         scaffoldBackgroundColor: AppColors.background,
// //         cardColor: AppColors.card,
// //         primaryColor: AppColors.primary,
// //         hintColor: AppColors.textSecondary,
// //         appBarTheme: const AppBarTheme(
// //           backgroundColor: AppColors.background,
// //           foregroundColor: AppColors.textPrimary,
// //           elevation: 1,
// //         ),
// //         textTheme: const TextTheme(
// //           displayLarge: TextStyle(color: AppColors.textPrimary),
// //           displayMedium: TextStyle(color: AppColors.textPrimary),
// //           displaySmall: TextStyle(color: AppColors.textPrimary),
// //           headlineLarge: TextStyle(color: AppColors.textPrimary),
// //           headlineMedium: TextStyle(color: AppColors.textPrimary),
// //           headlineSmall: TextStyle(color: AppColors.textPrimary),
// //           titleLarge: TextStyle(color: AppColors.textPrimary),
// //           titleMedium: TextStyle(color: AppColors.textPrimary),
// //           titleSmall: TextStyle(color: AppColors.textPrimary),
// //           bodyLarge: TextStyle(color: AppColors.textPrimary),
// //           bodyMedium: TextStyle(color: AppColors.textPrimary),
// //           bodySmall: TextStyle(color: AppColors.textSecondary),
// //           labelLarge: TextStyle(color: AppColors.buttonText),
// //           labelMedium: TextStyle(color: AppColors.textSecondary),
// //           labelSmall: TextStyle(color: AppColors.textSecondary),
// //         ),
// //         inputDecorationTheme: InputDecorationTheme(
// //           labelStyle: const TextStyle(color: AppColors.textSecondary),
// //           enabledBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(10.0),
// //             borderSide: const BorderSide(color: AppColors.border),
// //           ),
// //           focusedBorder: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(10.0),
// //             borderSide: const BorderSide(color: AppColors.primary),
// //           ),
// //           border: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(10.0),
// //             borderSide: const BorderSide(color: AppColors.border),
// //           ),
// //           filled: true,
// //           fillColor: AppColors.chip,
// //         ),
// //         elevatedButtonTheme: ElevatedButtonThemeData(
// //           style: ElevatedButton.styleFrom(
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(8.0),
// //             ),
// //             padding: const EdgeInsets.symmetric(vertical: 10.0),
// //           ),
// //         ),
// //         cardTheme: CardThemeData(
// //           color: AppColors.card,
// //           elevation: 2,
// //           shape: RoundedRectangleBorder(
// //             borderRadius: BorderRadius.circular(10.0),
// //           ),
// //         ),
// //         dividerColor: AppColors.border,
// //         dropdownMenuTheme: DropdownMenuThemeData(
// //           textStyle: const TextStyle(color: AppColors.textPrimary),
// //           menuStyle: MenuStyle(
// //             backgroundColor: MaterialStatePropertyAll(AppColors.card),
// //           ),
// //         ),
// //       ),
// //       child: Scaffold(
// //         // The body uses IndexedStack to show only the selected page
// //         body: IndexedStack(
// //           index: _selectedIndex,
// //           children: _pages,
// //         ),
// //         // Your custom BottomBar
// //         bottomNavigationBar: BottomBar(
// //           currentIndex:
// //               _selectedIndex, // Pass the current index to highlight the active tab
// //           onTap: _onItemTapped, // Pass the callback to update the index
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:notegoexpense/model/transaction_model.dart';
// import 'package:notegoexpense/model/transaction_notifier.dart';
// import 'package:notegoexpense/widgets/BottomBar.dart';
// import '../extras/AppColors.dart';
// import 'package:notegoexpense/pages/ledger.dart';
// import 'package:notegoexpense/pages/statistics_page.dart';
// import 'package:notegoexpense/pages/account_management.dart';
// import 'package:notegoexpense/pages/SettingPage/settings.dart';
// import 'package:another_telephony/telephony.dart';
// import 'package:notegoexpense/model/sms_scan_service.dart'; // Ensure this contains _addTransaction and logic

// final telephony = Telephony.instance;

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends ConsumerState<HomeScreen>
//     with WidgetsBindingObserver {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     const LedgerPage(),
//     const StatisticsPage(),
//     const AccountManagementPage(),
//     const Settings(),
//   ];

//   @override
//   void initState() {
//     super.initState();

//     telephony.listenIncomingSms(
//       onNewMessage: (SmsMessage message) {
//         _processIncomingMessage(ref, message);
//       },
//       onBackgroundMessage: backgroundMessageHandler, // Required for background
//     );

//     // Optional: Scan inbox when app comes to foreground
//     scanSmsAndAddTransactions(ref);
//   }

//   void _processIncomingMessage(WidgetRef ref, SmsMessage message) {
//     final body = message.body?.toLowerCase() ?? '';

//     if (body.contains('credited') || body.contains('received')) {
//       _addTransaction(ref, message, TransactionType.income);
//     } else if (body.contains('debited') || body.contains('sent')) {
//       _addTransaction(ref, message, TransactionType.expense);
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       scanSmsAndAddTransactions(ref); // Scan inbox when app comes to foreground
//     }
//   }

//   void _processMessage(SmsMessage message) {
//     final body = message.body?.toLowerCase() ?? '';

//     if (body.contains('credited')) {
//       _addTransaction(ref, message, TransactionType.income);
//     } else if (body.contains('debited') || body.contains('sent')) {
//       _addTransaction(ref, message, TransactionType.expense);
//     }
//   }

//   void _addTransaction(
//       WidgetRef ref, SmsMessage message, TransactionType type) {
//     final amount = _extractAmount(message.body ?? '');
//     if (amount == null) return;

//     final tx = TransactionModel(
//       title: 'Auto SMS Transaction',
//       amount: amount,
//       type: type,
//       category: 'Auto-detected',
//       account: 'Unknown',
//       date: DateTime.fromMillisecondsSinceEpoch(
//         message.date ?? DateTime.now().millisecondsSinceEpoch,
//       ),
//       note: message.body,
//       id: '',
//     );

//     ref.read(transactionsProvider.notifier).addTransaction(tx);
//   }

//   double? _extractAmount(String body) {
//     final regex = RegExp(r'(?i)(?:rs\.?|inr)\s?(\d+(?:,\d{3})*(?:\.\d{1,2})?)');
//     final match = regex.firstMatch(body);
//     if (match != null) {
//       final amountStr = match.group(1)?.replaceAll(',', '');
//       return double.tryParse(amountStr ?? '');
//     }
//     return null;
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: AppColors.background,
//         cardColor: AppColors.card,
//         primaryColor: AppColors.primary,
//         hintColor: AppColors.textSecondary,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: AppColors.background,
//           foregroundColor: AppColors.textPrimary,
//           elevation: 1,
//         ),
//         textTheme: const TextTheme(
//           bodyLarge: TextStyle(color: AppColors.textPrimary),
//           bodyMedium: TextStyle(color: AppColors.textPrimary),
//           bodySmall: TextStyle(color: AppColors.textSecondary),
//           labelLarge: TextStyle(color: AppColors.buttonText),
//         ),
//         inputDecorationTheme: InputDecorationTheme(
//           labelStyle: const TextStyle(color: AppColors.textSecondary),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//             borderSide: const BorderSide(color: AppColors.border),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//             borderSide: const BorderSide(color: AppColors.primary),
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10.0),
//             borderSide: const BorderSide(color: AppColors.border),
//           ),
//           filled: true,
//           fillColor: AppColors.chip,
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             padding: const EdgeInsets.symmetric(vertical: 10.0),
//           ),
//         ),
//         cardTheme: CardThemeData(
//           color: AppColors.card,
//           elevation: 2,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10.0),
//           ),
//         ),
//         dividerColor: AppColors.border,
//         dropdownMenuTheme: DropdownMenuThemeData(
//           textStyle: const TextStyle(color: AppColors.textPrimary),
//           menuStyle: MenuStyle(
//             backgroundColor: MaterialStatePropertyAll(AppColors.card),
//           ),
//         ),
//       ),
//       child: Scaffold(
//         body: IndexedStack(
//           index: _selectedIndex,
//           children: _pages,
//         ),
//         bottomNavigationBar: BottomBar(
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notegoexpense/widgets/BottomBar.dart';
import '../extras/AppColors.dart';
import 'package:notegoexpense/pages/ledger.dart';
import 'package:notegoexpense/pages/statistics_page.dart';
import 'package:notegoexpense/pages/account_management.dart';
import 'package:notegoexpense/pages/SettingPage/settings.dart';
import 'package:another_telephony/telephony.dart';
import 'package:notegoexpense/model/sms_scan_service.dart';

final telephony = Telephony.instance;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const LedgerPage(),
    const StatisticsPage(),
    const AccountManagementPage(),
    const Settings(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        processIncomingMessage(ref, message);
      },
      onBackgroundMessage: backgroundMessageHandler,
    );

    scanSmsAndAddTransactions(ref);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      scanSmsAndAddTransactions(ref);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        cardColor: AppColors.card,
        primaryColor: AppColors.primary,
        hintColor: AppColors.textSecondary,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 1,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textPrimary),
          bodySmall: TextStyle(color: AppColors.textSecondary),
          labelLarge: TextStyle(color: AppColors.buttonText),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          filled: true,
          fillColor: AppColors.chip,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10.0),
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.card,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        dividerColor: AppColors.border,
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: const TextStyle(color: AppColors.textPrimary),
          menuStyle: MenuStyle(
            backgroundColor: MaterialStatePropertyAll(AppColors.card),
          ),
        ),
      ),
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
