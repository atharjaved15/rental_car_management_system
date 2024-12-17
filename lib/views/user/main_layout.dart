import 'package:flutter/material.dart';
import 'package:rental_car_management_system/views/user/home_screen.dart';
import 'package:rental_car_management_system/views/user/my_requests.dart';
import 'package:rental_car_management_system/views/user/user_profile_page.dart';

class UserHomeStructure extends StatefulWidget {
  const UserHomeStructure({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserHomeStructureState createState() => _UserHomeStructureState();
}

class _UserHomeStructureState extends State<UserHomeStructure> {
  int selectedIndex = 0;

  // List of screens
  final List<Widget> screens = [
    HomeScreen(),
    RentalRequestsScreen(),
    RentalRequestsScreen(),
    UserProfilePage(),
  ];

  // Screen titles (optional)
  final List<String> titles = [
    "Home",
    "My Requests",
    "Rented Cars",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    final bool isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      drawer: isWeb
          ? null
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blueGrey),
                    child: Text(
                      "Menu",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  _buildDrawerItem(Icons.home, "Home", 0),
                  _buildDrawerItem(Icons.list, "My Requests", 1),
                  _buildDrawerItem(Icons.car_rental, "Rented Cars", 2),
                  _buildDrawerItem(Icons.person, "Profile", 3),
                ],
              ),
            ),
      body: Row(
        children: [
          if (isWeb) _buildSidebar(),
          Expanded(child: screens[selectedIndex]),
        ],
      ),
      bottomNavigationBar: isWeb
          ? null
          : BottomNavigationBar(
              currentIndex: selectedIndex,
              selectedItemColor: Colors.blueAccent,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.blueGrey.shade800,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              onTap: (index) => setState(() => selectedIndex = index),
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.list), label: 'My Requests'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.car_rental), label: 'Rented Cars'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      color: Colors.blueGrey.shade900,
      child: Column(
        children: [
          const SizedBox(height: 60),
          _buildSidebarItem(Icons.home, "Home", 0),
          _buildSidebarItem(Icons.list, "My Requests", 1),
          _buildSidebarItem(Icons.car_rental, "Rented Cars", 2),
          _buildSidebarItem(Icons.person, "Profile", 3),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, int index) {
    bool isSelected = selectedIndex == index;
    return MouseRegion(
      onEnter: (_) => setState(() {}),
      onExit: (_) => setState(() {}),
      child: ListTile(
        leading:
            Icon(icon, color: isSelected ? Colors.blueAccent : Colors.grey),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blueAccent : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        tileColor: isSelected ? Colors.blueGrey.shade700 : Colors.transparent,
        onTap: () => setState(() => selectedIndex = index),
        hoverColor: Colors.blueGrey.shade600,
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () => setState(() {
        selectedIndex = index;
        Navigator.pop(context); // Close drawer on selection
      }),
    );
  }
}
