// import 'package:flutter/material.dart';
// import 'package:notegoexpense/widgets/BottomBar.dart';

// class Settings extends StatefulWidget {
//   const Settings({super.key});

//   @override
//   State<Settings> createState() => _SettingsState();
// }

// class _SettingsState extends State<Settings> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[600],
//       appBar: AppBar(
//         title: const Text('Settings'),
//         backgroundColor: Colors.grey[700],
//         foregroundColor: Colors.white,
//       ),
//       body: ListView(
//         children: <Widget>[
//           header(title: const Text('Categories')),
//           columnTile(
//             tileName: 'Expense Categories',
//             onTap: () {
//               Navigator.pushNamed(context, '/expenseCategory');
//             },
//           ),
//           columnTile(
//             tileName: 'Income Categories',
//             onTap: () {
//               Navigator.pushNamed(context, '/incomeCategory');
//             },
//           ),
//           header(title: const Text('Configurations')),
//           columnTile(
//             tileName: 'Currency',
//             rightText: 'INR ₹',
//             onTap: () {
//               // Currency selection logic
//             },
//           ),
//           header(title: const Text('Debug')),
//           columnTile(
//             tileName: 'Hive Logs',
//             onTap: () {
//               Navigator.pushNamed(context, '/hiveDebug');
//             },
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomBar(
//         currentIndex: 3, // Settings tab is selected
//         onTap: (index) {
//           _handleBottomNavigation(context, index);
//         },
//       ),
//     );
//   }

//   Widget header({required Widget title}) {
//     return Container(
//       color: Colors.grey[800],
//       padding: const EdgeInsets.fromLTRB(8, 8, 5, 10),
//       child: DefaultTextStyle(
//         style: const TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.w600,
//           color: Colors.white,
//         ),
//         child: Align(alignment: Alignment.topLeft, child: title),
//       ),
//     );
//   }

//   Widget columnTile({
//     required String tileName,
//     String? rightText,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               tileName,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: Colors.white,
//                 fontWeight: FontWeight.w400,
//               ),
//             ),
//             if (rightText != null)
//               Text(
//                 rightText,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   color: Colors.red,
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _handleBottomNavigation(BuildContext context, int index) {
//     String route;
//     if (index == 0)
//       route = '/home';
//     else if (index == 1)
//       route = '/ledger';
//     else if (index == 2)
//       route = '/accountManagement';
//     else
//       route = '/settings';

//     if (ModalRoute.of(context)?.settings.name != route) {
//       Navigator.pushNamed(context, route);
//     }
//   }
// }

import 'package:flutter/material.dart';
// import 'package:notegoexpense/widgets/BottomBar.dart'; // No longer needed here
import '../../extras/AppColors.dart'; // Import your AppColors

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.background, // Updated: Use AppColors.background
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor:
            AppColors.background, // Updated: Use AppColors.background
        foregroundColor:
            AppColors.textPrimary, // Updated: Use AppColors.textPrimary
      ),
      body: ListView(
        children: <Widget>[
          header(title: const Text('Categories')),
          columnTile(
            tileName: 'Expense Categories',
            onTap: () {
              Navigator.pushNamed(context, '/expenseCategory');
            },
          ),
          columnTile(
            tileName: 'Income Categories',
            onTap: () {
              Navigator.pushNamed(context, '/incomeCategory');
            },
          ),
          header(title: const Text('Configurations')),
          columnTile(
            tileName: 'Currency',
            rightText:
                'INR ₹', // Consider if this should be dynamic based on user settings
            onTap: () {
              // Currency selection logic
              // Example: show a dialog or navigate to a currency selection page
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Currency selection not yet implemented!',
                      style: TextStyle(color: AppColors.textPrimary)),
                  backgroundColor: AppColors.chip,
                ),
              );
            },
          ),
          header(title: const Text('Debug')),
          columnTile(
            tileName: 'Hive Logs',
            onTap: () {
              Navigator.pushNamed(context, '/hiveDebug');
            },
          ),
          // Added a general 'About' section for completeness
          header(title: const Text('General')),
          columnTile(
            tileName: 'About App',
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Note & GoExpense',
                applicationVersion: '1.0.0', // Replace with your actual version
                applicationIcon:
                    Icon(Icons.wallet_travel, color: AppColors.primary),
                children: [
                  Text(
                    'Your personal expense tracker to manage finances effortlessly.',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      // --- REMOVED: bottomNavigationBar is managed by HomeScreen ---
      // bottomNavigationBar: BottomBar(
      //   currentIndex: 3, // Settings tab is selected
      //   onTap: (index) {
      //     _handleBottomNavigation(context, index);
      //   },
      // ),
    );
  }

  // Helper widget for section headers
  Widget header({required Widget title}) {
    return Container(
      color:
          AppColors.card, // Updated: Use AppColors.chip for header background
      padding: const EdgeInsets.fromLTRB(8, 8, 5, 10),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary, // Updated: Use AppColors.textPrimary
        ),
        child: Align(alignment: Alignment.topLeft, child: title),
      ),
    );
  }

  // Helper widget for individual setting tiles
  Widget columnTile({
    required String tileName,
    String? rightText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // Added Container to apply padding and background consistently
        color: AppColors
            .chip, // Optional: Use card color for tile background if different from scaffold
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tileName,
              style: const TextStyle(
                fontSize: 16,
                color:
                    AppColors.textPrimary, // Updated: Use AppColors.textPrimary
                fontWeight: FontWeight.w400,
              ),
            ),
            if (rightText != null)
              Text(
                rightText,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors
                      .textSecondary, // Updated: Use AppColors.textSecondary for less emphasis or AppColors.primary for accent
                ),
              ),
          ],
        ),
      ),
    );
  }

  // --- REMOVED: _handleBottomNavigation is managed by HomeScreen ---
  // void _handleBottomNavigation(BuildContext context, int index) {
  //   String route;
  //   if (index == 0)
  //     route = '/home';
  //   else if (index == 1)
  //     route = '/ledger';
  //   else if (index == 2)
  //     route = '/accountManagement';
  //   else
  //     route = '/settings';

  //   if (ModalRoute.of(context)?.settings.name != route) {
  //     Navigator.pushNamed(context, route);
  //   }
  // }
}
