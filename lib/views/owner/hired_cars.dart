import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_car_management_system/models/car_model.dart';

class HiredCarsScreen extends StatefulWidget {
  const HiredCarsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HiredCarsScreenState createState() => _HiredCarsScreenState();
}

class _HiredCarsScreenState extends State<HiredCarsScreen> {
  bool isLoading = true;
  List<Car> hiredCars = [];

  @override
  void initState() {
    super.initState();
    _listenToHiredCars();
  }

  // Listen for real-time updates to hired cars
  void _listenToHiredCars() {
    FirebaseFirestore.instance
        .collection('cars')
        .where('hiredBy', isNotEqualTo: '')
        .snapshots()
        .listen((querySnapshot) {
      setState(() {
        hiredCars =
            querySnapshot.docs.map((doc) => Car.fromMap(doc.data())).toList();
        isLoading = false;
      });
    });
  }

  // Complete hiring by clearing the `hiredBy` field and updating earnings
  Future<void> _completeHiring(String carId, double rentPerDay) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      // Start a Firestore transaction
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final carDoc = FirebaseFirestore.instance.collection('cars').doc(carId);
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(currentUserId);

        // Fetch data within the transaction
        final carSnapshot = await transaction.get(carDoc);
        final userSnapshot = await transaction.get(userDoc);

        if (!carSnapshot.exists || !userSnapshot.exists) {
          throw Exception("Car or User document does not exist.");
        }

        final currentEarnings = userSnapshot.data()?['earning'] ?? 0.0;

        // Update car and user documents
        transaction.update(carDoc, {'hiredBy': ''});
        transaction.update(userDoc, {'earning': currentEarnings + rentPerDay});
      });

      Get.snackbar("Success", "Hiring completed and earnings updated.");
    } catch (e) {
      Get.snackbar("Error", "Failed to complete hiring: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hired Cars")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hiredCars.isEmpty
              ? const Center(child: Text("No hired cars available"))
              : ListView.builder(
                  itemCount: hiredCars.length,
                  itemBuilder: (context, index) {
                    final car = hiredCars[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: car.carImage.isNotEmpty
                            ? Image.network(car.carImage,
                                width: 60, height: 60, fit: BoxFit.cover)
                            : const Icon(Icons.car_rental, size: 60),
                        title: Text(
                          car.carName,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Model: ${car.model}",
                                style: const TextStyle(fontSize: 16)),
                            Text("Condition: ${car.condition}",
                                style: const TextStyle(fontSize: 16)),
                            Text("Rent per Day: \$${car.rentPerDay}",
                                style: const TextStyle(fontSize: 16)),
                            Text("Hired by: ${car.hiredBy}",
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () => _completeHiring(
                            car.carId,
                            car.rentPerDay,
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text(
                            "Complete Hiring",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
