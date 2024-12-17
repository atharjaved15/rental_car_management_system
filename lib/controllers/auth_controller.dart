import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_car_management_system/views/owner/owner_app_structure.dart';
import 'package:rental_car_management_system/views/user/main_layout.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observables for user
  var isLoading = false.obs;
  var user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(
        _auth.authStateChanges()); // Auto-update user on auth state changes
  }

  // Sign Up Method with Role
  Future<void> signUp(
      String email, String password, String name, String role) async {
    try {
      isLoading.value = true;

      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Prepare the user data
      Map<String, dynamic> userData = {
        'uid': userCredential.user!.uid,
        'email': email,
        'name': name,
        'role': role,
      };

      // Add extra fields if the role is 'owner'
      if (role.toLowerCase() == 'owner') {
        userData.addAll({
          'earning': 0, // Default earning value
          'totalCars': 0, // Default total cars value
        });
      }

      // Add user details to Firestore
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData);

      // Show success message
      Get.snackbar("Success", "Account created successfully");
      isLoading.value = false;
    } catch (e) {
      // Handle errors and show error message
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }

  // Login Method with Role Check
  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Fetch user role from Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      String role = userDoc['role'];

      // Navigate based on role
      switch (role) {
        case 'user':
          Get.offAll(const UserHomeStructure());
          break;
        case 'admin':
          //Get.to(AdminDashboard()); // Example admin dashboard
          break;
        case 'owner':
          Get.offAll(const OwnerAppStructure()); // Example driver dashboard
          break;
        default:
          Get.snackbar("Error", "Invalid role detected");
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }

  // Logout Method
  Future<void> logout() async {
    await _auth.signOut();
    Get.snackbar("Success", "Logged out successfully");
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        "Success",
        "A password reset email has been sent to $email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
