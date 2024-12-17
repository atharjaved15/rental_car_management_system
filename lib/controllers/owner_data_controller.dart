import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:rental_car_management_system/models/car_model.dart';
import 'package:rental_car_management_system/models/owner_model.dart';
import 'package:rental_car_management_system/models/request_model.dart';

class OwnerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var drivers = <Owner>[].obs; // Observable list of drivers
  RxList<Car> cars = <Car>[].obs; // Observable list of cars
  Rx<Owner?> currentOwner = Rx<Owner?>(null);

  @override
  void onInit() async {
    super.onInit();
    await fetchCurrentOwner();
    listenToRequests();
    listenToEarnings();
    await fetchAllCars();
    //await fetchCarsOfOwner(_auth.currentUser!.uid.toString());
  }

  var isLoading = false.obs;
  var earning = 0.0.obs; // RxDouble for reactive update

  /// Fetches the earnings of the current user and updates the `earnings` variable
  void listenToEarnings() {
    try {
      isLoading.value = true;

      // Get the current user's ID
      final String? userId = _auth.currentUser?.uid;

      // Ensure the user is authenticated
      if (userId == null) {
        throw Exception("User is not logged in.");
      }

      // Set up a Firestore real-time listener
      _firestore.collection('users').doc(userId).snapshots().listen((snapshot) {
        // Ensure the snapshot exists
        if (snapshot.exists) {
          // Extract the 'earning' field, default to 0.0 if null
          final double userEarnings =
              (snapshot.data() as Map<String, dynamic>)['earning']
                      ?.toDouble() ??
                  0.0;

          // Update the reactive earnings variable
          earning.value = userEarnings;
        } else {
          throw Exception("User document does not exist.");
        }
      });
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCurrentOwner() async {
    // You can use the method you already have for fetching the current owner
    currentOwner.value = await getCurrentOwner();
  }

  Future<Owner?> getCurrentOwner() async {
    try {
      // Ensure user is logged in
      String? currentUid = _auth.currentUser!.uid;

      print("Fetching details for UID: $currentUid");

      // Fetch the owner details from Firestore
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(currentUid).get();

      // Check if the document exists
      if (!userSnapshot.exists) {
        print("User document does not exist for UID: $currentUid");
        Get.snackbar("Error", "User details not found");
        return null;
      }

      // Parse the document data
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;

      // Log the retrieved data
      print("User data fetched: $userData");

      // Check if the user is an owner
      if (userData['role'] == 'owner') {
        // Map to the Owner model
        Owner owner = Owner.fromMap(userData);
        print("Owner details: ${owner.toString()}");
        return owner;
      } else {
        print("User is not an owner. Role: ${userData['role']}");
        Get.snackbar("Error", "User is not an owner");
        return null;
      }
    } catch (e, stackTrace) {
      // Log the error and stack trace for debugging
      print("Error fetching owner: $e");
      print("StackTrace: $stackTrace");
      Get.snackbar("Error", "Failed to fetch owner details");
      return null;
    }
  }

  // Fetch all cars from a separate 'cars' collection
  Future<void> fetchAllCars() async {
    try {
      // Fetch documents from the 'cars' collection where status equals 'available'
      QuerySnapshot carsSnapshot = await _firestore
          .collection('cars')
          .where('status', isEqualTo: 'available')
          .get();

      // Debugging: Log the number of available documents fetched
      if (kDebugMode) {
        print("Number of available cars fetched: ${carsSnapshot.docs.length}");
      }

      // Clear the current cars list
      cars.clear();

      // Iterate through each document and convert it to a Car object
      for (var carDoc in carsSnapshot.docs) {
        Map<String, dynamic> carData = carDoc.data() as Map<String, dynamic>;

        // Debugging: Log each available car data
        if (kDebugMode) {
          print("Available Car Data: $carData");
        }

        // Convert data to a Car object
        Car car = Car.fromMap(carData);

        // Add the Car object to the RxList
        cars.add(car);
      }

      // Debugging: Ensure cars are being added
      if (kDebugMode) {
        print("Cars added to the list: ${cars.length}");
      }

      // Update the observable list
      cars.refresh();

      // Debugging: Log the car names
      if (kDebugMode) {
        print("Available Cars: ${cars.map((car) => car.carName).toList()}");
      }
    } catch (e) {
      // Log and display the error
      if (kDebugMode) {
        print("Error fetching available cars: $e");
      }
      Get.snackbar("Error", "Failed to fetch available cars: $e");
    }
  }

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> approveRequest(
      String requestId, String carId, String userId) async {
    try {
      await _db.collection('requests').doc(requestId).update({
        'status': 'approved', // Update status or add hireBy field
      });
      await _db.collection('cars').doc(carId).update({
        'hiredBy': userId, // Update status or add hireBy field
      });
    } catch (e) {
      print("Error approving request: $e");
    }
  }

  // Reject the request
  Future<void> rejectRequest(String requestId) async {
    try {
      await _db.collection('requests').doc(requestId).update({
        'status':
            'rejected', // You can also update the status as Rejected or similar
      });
    } catch (e) {
      print("Error rejecting request: $e");
    }
  }

  RxList<RequestModel> rentalRequests =
      <RequestModel>[].obs; // Now it's a list of RequestModel objects

  void listenToRequests() {
    try {
      // Assuming you have the current user's ID
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Listening to changes in the requests collection where ownerId matches the current user ID
      FirebaseFirestore.instance
          .collection('requests')
          .where('ownerId', isEqualTo: currentUserId)
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
      print("Error listening to rental requests: $e");
      Get.snackbar("Error", "Failed to listen to rental requests");
    }
  }
}
