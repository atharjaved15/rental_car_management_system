import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_car_management_system/models/car_model.dart';

class OwnerCarsScreen extends StatefulWidget {
  const OwnerCarsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OwnerCarsScreenState createState() => _OwnerCarsScreenState();
}

class _OwnerCarsScreenState extends State<OwnerCarsScreen> {
  final String ownerId = FirebaseAuth
      .instance.currentUser!.uid; // Replace with actual current owner's ID
  bool isLoading = true;
  List<Car> cars = [];

  @override
  void initState() {
    super.initState();
    _fetchCars();
  }

  Future<void> _fetchCars() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('cars')
          .where('ownerId', isEqualTo: ownerId)
          .get();

      setState(() {
        cars =
            querySnapshot.docs.map((doc) => Car.fromMap(doc.data())).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar("Error", "Failed to load cars");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Cars")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cars.isEmpty
              ? const Center(child: Text("No cars available"))
              : ListView.builder(
                  itemCount: cars.length,
                  itemBuilder: (context, index) {
                    final car = cars[index];
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
                            Text("Status: ${car.status}",
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
