import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../modules/home/viewmodel/home1provider.dart';
import 'package:realestate/modules/home/viewmodel/home1provider.dart';  // Import the provider
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DockingBar extends StatelessWidget {
  final Function(int) onTabSelected;

  const DockingBar({
    Key? key,
    required this.onTabSelected,
  }) : super(key: key);

  BottomNavigationBarItem _buildNavItem(IconData icon, bool isSelected) {
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Color(0xFF204D6C) : Colors.grey, // Change icon color based on selection
          ),
          // Show the color dot when selected
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Color(0xFF204D6C),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
      label: '', // No label displayed
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TabSelectionProvider>(
      builder: (context, tabSelectionProvider, _) {
        return BottomNavigationBar(
          currentIndex: tabSelectionProvider.selectedIndex,
          onTap: (index) {
            onTabSelected(index); // Call the callback to update the provider
            tabSelectionProvider.setSelectedIndex(index); // Update the provider's selected index
          },
          items: [
            _buildNavItem(FontAwesomeIcons.houseChimneyWindow, tabSelectionProvider.selectedIndex == 0),
            _buildNavItem(FontAwesomeIcons.solidCommentDots, tabSelectionProvider.selectedIndex == 1),
            _buildNavItem(Icons.favorite, tabSelectionProvider.selectedIndex == 2),
            _buildNavItem(Icons.person, tabSelectionProvider.selectedIndex == 3),
          ],
        );
      },
    );
  }
}
