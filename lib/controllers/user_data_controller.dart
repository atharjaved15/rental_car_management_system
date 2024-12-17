import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rental_car_management_system/models/car_model.dart';
import 'package:rental_car_management_system/models/request_model.dart';

class UserDataController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    listenToRequests();
    listenToHiredCars();
  }

  RxList<RequestModel> rentalRequests =
      <RequestModel>[].obs; // Now it's a list of RequestModel objects
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxList<Car> hiredCars = <Car>[].obs;

  void listenToHiredCars() {
    String currentUserId = _auth.currentUser?.uid ?? "";

    _firestore
        .collection('cars')
        .where('hiredBy', isEqualTo: currentUserId)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      hiredCars.value = snapshot.docs.map((doc) {
        return Car.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  void listenToRequests() {
    try {
      // Assuming you have the current user's ID
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Listening to changes in the requests collection where ownerId matches the current user ID
      FirebaseFirestore.instance
          .collection('requests')
          .where('userId', isEqualTo: currentUserId)
          .where('status', isEqualTo: 'pending')
          .snapshots()
          .listen((snapshot) {
        // Mapping Firestore documents to RequestModel instances
        var updatedRequests = snapshot.docs.map((doc) {
          Map<String, dynamic> data = doc.data();

          // Converting each document's data to a RequestModel
          return RequestModel.fromMap(data, doc.id);
        }).toList();

        // Updating the rentalRequests list reactively
        rentalRequests.value = updatedRequests;
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error listening to rental requests: $e");
      }
      Get.snackbar("Error", "Failed to listen to rental requests");
    }
  }
}
