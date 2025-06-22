import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class ExpenseCategories {}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.grey[600],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: <Widget>[
          header(title: const Text('Categories')),
          columnTile(
              tileName: 'Expemse Categories',
              onTap: () {
                Navigator.pushNamed(context, '/expenseCategory');
              }),
          columnTile(tileName: 'Income Categories', onTap: () {}),
          header(title: const Text('Configurations')),
          columnTile(
            tileName: 'Currency',
            rightText: 'INR ₹',
            onTap: () {
              // Currency selection logic
            },
          ),
        ],
      ),
    );
  }

  Widget header({required Widget title}) {
    return Container(
      color: Colors.grey[800],
      padding: const EdgeInsets.fromLTRB(8, 8, 5, 10),
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        child: Align(alignment: Alignment.topLeft, child: title),
      ),
    );
  }

  Widget columnTile({
    required String tileName,
    String? rightText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              tileName,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (rightText != null)
              Text(
                rightText,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
