import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rental_car_management_system/models/request_model.dart';

class DataController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var currentUser =
      Rxn<Map<String, dynamic>>(); // Observable to hold current user details

  var rentalRequests = <RequestModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchRequests();
    await fetchLoggedInUserWithRole();
  }

  // Fetch requests logic here
  Future<void> fetchRequests() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('requests')
          .where('ownerId',
              isEqualTo: 'currentUserId') // Replace with actual current user ID
          .get();

      var requests = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return RequestModel.fromMap(
            data, doc.id); // Correctly create RequestModel from map
      }).toList();

      rentalRequests.value =
          requests; // Assign the list of RequestModel to the RxList
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching rental requests: $e");
      }
    }
  }

  // Method to fetch the currently logged-in user with role "User"
  Future<void> fetchLoggedInUserWithRole() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        // Fetch the user document from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

          // Check if the role is "User"
          if (data['role'] == 'user') {
            currentUser.value = data; // Store user details in the observable
          } else {
            Get.snackbar(
                "Error", "Logged-in user does not have the 'User' role");
          }
        } else {
          Get.snackbar("Error", "User not found in database");
        }
      } else {
        Get.snackbar("Error", "No user is logged in");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
