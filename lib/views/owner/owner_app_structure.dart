import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_car_management_system/views/owner/add_car_%20mobile.dart';
import 'package:rental_car_management_system/views/owner/hired_cars.dart';
import 'package:rental_car_management_system/views/owner/my_cars.dart';
import 'package:rental_car_management_system/views/owner/owner_home.dart';
import 'package:rental_car_management_system/views/owner/owner_requests.dart';
import 'profile_screen.dart'; // Replace with the actual path

class OwnerAppStructure extends StatefulWidget {
  const OwnerAppStructure({super.key});

  @override
  State<OwnerAppStructure> createState() => _OwnerAppStructureState();
}

class _OwnerAppStructureState extends State<OwnerAppStructure> {
  int _currentIndex = 0;

  // List of screens corresponding to the bottom navigation bar items
  final List<Widget> _screens = [
    OwnerDashboardScreen(),
    const OwnerCarsScreen(),
    OwnerRequestsScreen(),
    const HiredCarsScreen(),
    ProfileScreen(),
  ];

  // Colors for selected and unselected states
  final Color selectedColor = Colors.blue;
  final Color unselectedColor = Colors.grey;
  final Color hoverColor = Colors.blue.shade100;

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width <= 600;

    return Scaffold(
      floatingActionButton: kIsWeb
          ? null
          : FloatingActionButton(
              onPressed: () {
                Get.to(() => const AddCarMobile());
              },
              child: const Column(
                children: [
                  Icon(Icons.car_rental),
                  Text('Add Car'),
                ],
              ),
            ),
      appBar: AppBar(
        title: const Text("Owner Panel"),
        centerTitle: true,
      ),
      body: Row(
        children: [
          if (!isMobile)
            NavigationRail(
              selectedIndex: _currentIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              selectedIconTheme: IconThemeData(color: selectedColor),
              unselectedIconTheme: IconThemeData(color: unselectedColor),
              selectedLabelTextStyle: TextStyle(color: selectedColor),
              unselectedLabelTextStyle: TextStyle(color: unselectedColor),
              destinations: [
                _buildNavRailItem(Icons.dashboard, "Dashboard", 0),
                _buildNavRailItem(Icons.car_crash, "My Cars", 1),
                _buildNavRailItem(Icons.list, "Requests", 2),
                _buildNavRailItem(Icons.car_rental, "Hired Cars", 3),
                _buildNavRailItem(Icons.person, "Profile", 4),
              ],
            ),
          Expanded(
            child: _screens[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              selectedItemColor: selectedColor,
              unselectedItemColor: unselectedColor,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: "Dashboard",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.car_crash),
                  label: "My Cars",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: "Requests",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.car_rental),
                  label: "Hired Cars",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            )
          : null,
    );
  }

  // Method to build each NavigationRail item with hover effect
  NavigationRailDestination _buildNavRailItem(
      IconData icon, String label, int index) {
    return NavigationRailDestination(
      icon: MouseRegion(
        onEnter: (_) {
          setState(() {
            // Update color when hovering over an item
            _currentIndex == index ? null : _currentIndex = index;
          });
        },
        onExit: (_) {
          setState(() {
            // Reset hover effect when the mouse leaves
            _currentIndex == index ? null : _currentIndex;
          });
        },
        child: Icon(
          icon,
          color: _currentIndex == index ? selectedColor : unselectedColor,
        ),
      ),
      label: MouseRegion(
        onEnter: (_) {
          setState(() {
            _currentIndex == index ? null : _currentIndex = index;
          });
        },
        onExit: (_) {
          setState(() {
            _currentIndex == index ? null : _currentIndex;
          });
        },
        child: Text(
          label,
          style: TextStyle(
            color: _currentIndex == index ? selectedColor : unselectedColor,
          ),
        ),
      ),
    );
  }
}
