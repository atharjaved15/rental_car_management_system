import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rental_car_management_system/controllers/auth_controller.dart';
import 'package:rental_car_management_system/controllers/owner_data_controller.dart';
import 'package:rental_car_management_system/views/auth_views/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final OwnerController ownerController = Get.find();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    const isWeb = kIsWeb;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: isWeb ? 600 : double.infinity),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: const NetworkImage(
                        "https://via.placeholder.com/150"), // Replace with user image
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.greenAccent,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                // Add image upload functionality
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User Name
                  Text(
                    ownerController.currentOwner.value!.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Email
                  Text(
                    ownerController.currentOwner.value!.email,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),

                  // Editable Profile
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     // Add profile edit functionality
                  //   },
                  //   icon: const Icon(Icons.edit, size: 18),
                  //   label: const Text("Edit Profile"),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.blueAccent,
                  //     foregroundColor: Colors.white,
                  //   ),
                  // ),
                  const SizedBox(height: 32),

                  // Earnings Section
                  const Text(
                    "Total Earnings",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "\$${ownerController.currentOwner.value!.earning}",
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  const SizedBox(height: 32),

                  // Stats Cards
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _buildStatCard(
                          title: "Total Hires",
                          value: "120",
                          icon: Icons.car_rental,
                          color: Colors.orangeAccent),
                      _buildStatCard(
                          title: "Cars Listed",
                          value: "25",
                          icon: Icons.directions_car,
                          color: Colors.blueAccent),
                      _buildStatCard(
                          title: "Pending Requests",
                          value: "5",
                          icon: Icons.pending_actions,
                          color: Colors.purpleAccent),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Sign Out Button
                  ElevatedButton.icon(
                    onPressed: () {
                      authController.logout();
                      Get.offAll(LoginScreen());
                      // Add sign-out functionality
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Sign Out"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 32),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
      {required String title,
      required String value,
      required IconData icon,
      required Color color}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
