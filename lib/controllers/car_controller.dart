import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_car_management_system/models/car_model.dart';

class CarController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to handle car hiring request
  Future<void> sendHiringRequest(Car car, String userId) async {
    try {
      // Ensure the userId is not empty
      if (userId.isEmpty) {
        Get.snackbar(
          "Error",
          "You must be logged in to hire a car.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // Create a new hiring request with car details
      await _firestore.collection('requests').add({
        'carId': car.carId,
        'userId': userId,
        'ownerId': car.ownerId,
        'status': 'pending',
        'carModel': car.model,
        'carName': car.carName,
        'rentPerDay': car.rentPerDay,
        'condition': car.condition,
        'carImage': car.carImage,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show success snackbar
      Get.snackbar(
        "Success",
        "Your request to hire ${car.carName} (${car.model}) has been sent.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // Handle errors and show error snackbar
      Get.snackbar(
        "Error",
        "Failed to send hiring request: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> hasRequested(String carId) async {
    try {
      String userId = _auth.currentUser?.uid ?? "";
      if (userId.isEmpty) return false;

      // Query the requests collection
      final querySnapshot = await _firestore
          .collection('requests')
          .where('carId', isEqualTo: carId)
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'pending')
          .get();

      // Return true if a request exists, otherwise false
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      if (kDebugMode) {
        print("Error checking request status: $e");
      }
      return false;
    }
  }

  void showAlreadyRequestedPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Request Already Sent'),
          content: const Text(
              'You have already sent a request for this car. Please wait for the owner to respond.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }
}
