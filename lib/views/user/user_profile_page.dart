import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rental_car_management_system/controllers/data_controller.dart';
import 'package:rental_car_management_system/views/auth_views/login_screen.dart';

class UserProfilePage extends StatelessWidget {
  final DataController authController = Get.put(DataController());

  UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Obx(() {
        if (authController.currentUser.value == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final userData = authController.currentUser.value;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Top profile section with background color
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade900,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(35),
                  ),
                ),
                child: Column(
                  children: [
                    // Profile Image with shadow effect
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: userData?['profileImageUrl'] != null
                          ? NetworkImage(userData!['profileImageUrl'])
                          : null,
                      child: userData?['profileImageUrl'] == null
                          ? const Icon(
                              Icons.person,
                              size: 70,
                              color: Colors.white,
                            )
                          : null,
                    ),
                    const SizedBox(height: 15),
                    // User Name
                    Text(
                      userData?['name'] ?? 'N/A',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // User Email
                    Text(
                      userData?['email'] ?? 'N/A',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ],
                ),
              ),

              // Profile Details Section with nice spacing and shadowed cards
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileItem(
                      icon: Icons.person,
                      title: "Role",
                      value: userData?['role'] ?? 'N/A',
                    ),
                    _buildProfileItem(
                      icon: Icons.phone,
                      title: "Phone",
                      value: userData?['phone'] ?? '+44 321681 1273',
                    ),
                    _buildProfileItem(
                      icon: Icons.location_on,
                      title: "Location",
                      value: userData?['location'] ?? 'Manchester, UK',
                    ),
                    const SizedBox(height: 30),

                    // Logout Button with better styling
                    ElevatedButton.icon(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Get.snackbar("Logged Out", "You have been logged out");
                        Get.offAll(LoginScreen());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 30.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      icon: const Icon(Icons.logout, size: 20),
                      label: const Text(
                        "Log Out",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Method for building profile items with a shadow effect
  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.blueGrey.shade800,
          size: 30,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.blueGrey,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey.shade600,
          ),
        ),
      ),
    );
  }
}
