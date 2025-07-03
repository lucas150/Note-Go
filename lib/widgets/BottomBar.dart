// import 'package:flutter/material.dart';

// class BottomBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTap;

//   const BottomBar({
//     super.key,
//     required this.currentIndex,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.grey[900],
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(
//             icon: Icons.list_alt,
//             label: 'Transactions',
//             isActive: currentIndex == 0,
//             onTap: () => onTap(0),
//           ),
//           _buildNavItem(
//             icon: Icons.bar_chart,
//             label: 'Statistics',
//             isActive: currentIndex == 1,
//             onTap: () => onTap(1),
//           ),
//           _buildNavItem(
//             icon: Icons.account_balance,
//             label: 'Account',
//             isActive: currentIndex == 2,
//             onTap: () => onTap(2),
//           ),
//           _buildNavItem(
//             icon: Icons.settings,
//             label: 'Settings',
//             isActive: currentIndex == 3,
//             onTap: () => onTap(3),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem({
//     required IconData icon,
//     required String label,
//     required bool isActive,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       behavior: HitTestBehavior.translucent,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             color: isActive ? Colors.blue : Colors.white,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             label,
//             style: TextStyle(
//               color: isActive ? Colors.blue : Colors.white,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import '../extras/AppColors.dart'; // Import AppColors

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors
          .background, // Use AppColors.background for the bottom bar background
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.list_alt,
            label: 'Transactions',
            isActive: currentIndex == 0,
            onTap: () => onTap(0),
            context: context,
          ),
          _buildNavItem(
            icon: Icons.bar_chart,
            label: 'Statistics',
            isActive: currentIndex == 1,
            onTap: () => onTap(1),
            context: context,
          ),
          _buildNavItem(
            icon: Icons.account_balance,
            label: 'Account',
            isActive: currentIndex == 2,
            onTap: () => onTap(2),
            context: context,
          ),
          _buildNavItem(
            icon: Icons.settings,
            label: 'Settings',
            isActive: currentIndex == 3,
            onTap: () => onTap(3),
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            // Use AppColors.primary for active, and AppColors.textSecondary for inactive
            color: isActive ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              // Use AppColors.primary for active, and AppColors.textSecondary for inactive
              color: isActive ? AppColors.primary : AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
