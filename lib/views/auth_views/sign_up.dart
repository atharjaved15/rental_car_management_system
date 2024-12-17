import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_car_management_system/app_colors.dart';
import 'package:rental_car_management_system/views/auth_views/login_screen.dart';
import '../../controllers/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Roles for dropdown
  final List<String> roles = ['user', 'owner'];
  final RxString selectedRole = 'user'.obs;

  SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/background.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(color: Colors.transparent),
                ),
              ],
            ),
          ),
          Center(
            child: Obx(() {
              return authController.isLoading.value
                  ? const CircularProgressIndicator()
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: isWeb ? 400 : double.infinity,
                            padding: const EdgeInsets.all(24.0),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Logo
                                Image.asset(
                                  'assets/images/logo.png',
                                  height: 100,
                                ),
                                const SizedBox(height: 16),
                                // Tagline
                                const Text(
                                  "Your Journey, Our Priority",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Form
                                const Text(
                                  "Create Account",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    labelText: "Name",
                                    prefixIcon: const Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: emailController,
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    prefixIcon: const Icon(Icons.email),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    prefixIcon: const Icon(Icons.lock),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  obscureText: true,
                                ),
                                const SizedBox(height: 16),
                                // Role Selection Dropdown
                                Obx(() {
                                  return DropdownButtonFormField<String>(
                                    value: selectedRole.value,
                                    items: roles
                                        .map(
                                          (role) => DropdownMenuItem(
                                            value: role,
                                            child: Text(role),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (value) {
                                      selectedRole.value = value!;
                                    },
                                    decoration: InputDecoration(
                                      labelText: "Select Role",
                                      prefixIcon: const Icon(Icons.people),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      authController.signUp(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                        nameController.text.trim(),
                                        selectedRole.value,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors
                                          .greenAccent, // Change button color
                                      foregroundColor:
                                          Colors.white, // Change text color
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Get.offAll(LoginScreen());
                                    },
                                    child: const Text(
                                      "Already have an account? Login",
                                      style: TextStyle(color: AppColors.accent),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }
}
