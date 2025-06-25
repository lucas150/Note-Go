import 'package:flutter/material.dart';
import 'package:notegoexpense/widgets/BottomBar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to Note&Go - Expense Tracker',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Add Transaction Screen
                Navigator.pushNamed(context, '/addTransaction');
              },
              child: const Text('Add Transaction'),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ledger');
                  // HiveInspector.openHiveBox('transactions');
                },
                child: const Text('View Ledger')),
            ElevatedButton(
              onPressed: () {
                // Navigate to Account Management Screen
                Navigator.pushNamed(context, '/accountManagement');
              },
              child: const Text('Manage Accounts'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Hive Debug Screen
                Navigator.pushNamed(context, '/hiveDebug');
              },
              child: const Text('Hive Debug'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to Settings Screen
                Navigator.pushNamed(context, '/settings');
              },
              child: const Text('Settings'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomBar(
        currentIndex: 0, // Transactions tab is selected
        onTap: (index) {
          _handleBottomNavigation(context, index);
        },
      ),
    );
  }
}

void _handleBottomNavigation(BuildContext context, int index) {
  String route;
  if (index == 0)
    route = '/home';
  else if (index == 1)
    route = '/ledger';
  else if (index == 2)
    route = '/accountManagement';
  else
    route = '/settings';

  if (ModalRoute.of(context)?.settings.name != route) {
    Navigator.pushNamed(context, route);
  }
}
