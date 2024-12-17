// ignore_for_file: file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_car_management_system/image_picker_services.dart';
import 'package:rental_car_management_system/models/newcarmodel.dart';

class AddCarMobile extends StatefulWidget {
  const AddCarMobile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddCarMobileState createState() => _AddCarMobileState();
}

class _AddCarMobileState extends State<AddCarMobile> {
  final _carNameController = TextEditingController();
  final _modelController = TextEditingController();
  final _conditionController = TextEditingController();
  final _rentPerDayController = TextEditingController();
  final _statusController = TextEditingController();

  dynamic _pickedImage;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Car"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image Picker
            GestureDetector(
              onTap: _pickImage,
              child: _pickedImage == null
                  ? Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                          SizedBox(height: 8),
                          Text(
                            "Tap to upload image",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _pickedImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            // Car Name
            _buildTextField(
              controller: _carNameController,
              label: "Car Name",
              icon: Icons.drive_eta,
            ),
            const SizedBox(height: 12),
            // Car Model
            _buildTextField(
              controller: _modelController,
              label: "Car Model",
              icon: Icons.model_training,
            ),
            const SizedBox(height: 12),
            // Car Condition
            _buildTextField(
              controller: _conditionController,
              label: "Car Condition (e.g., 4.5)",
              icon: Icons.info_outline,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 12),
            // Rent Per Day
            _buildTextField(
              controller: _rentPerDayController,
              label: "Rent Per Day",
              icon: Icons.monetization_on,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            // Submit Button
            Center(
              child: _isUploading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _addCar,
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text(
                        "Add Car",
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 5,
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    File? image = await ImagePickerService.pickImage();
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }

  Future<void> _addCar() async {
    if (_carNameController.text.isEmpty ||
        _modelController.text.isEmpty ||
        _conditionController.text.isEmpty ||
        _rentPerDayController.text.isEmpty ||
        _pickedImage == null) {
      Get.snackbar("Error", "All fields and an image are required!");
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload Image to Firebase Storage
      final imageUrl = await _uploadImage(_pickedImage!);

      // Create Car Model
      final car = CarModel(
        carName: _carNameController.text,
        model: _modelController.text,
        condition: double.parse(_conditionController.text),
        rentPerDay: double.parse(_rentPerDayController.text),
        status: _statusController.text,
        ownerId: FirebaseAuth.instance.currentUser!
            .uid, // Update with the current user's owner ID
        imageUrl: imageUrl,
      );

      // Save to Firestore
      final carDoc = await FirebaseFirestore.instance.collection('cars').add({
        'carName': car.carName,
        'model': car.model,
        'condition': car.condition,
        'rentPerDay': car.rentPerDay,
        'status': 'available',
        'ownerId': car.ownerId,
        'imageUrl': car.imageUrl,
      });

      // Update Car ID
      await carDoc.update({'carId': carDoc.id});

      //update Number of Cars

      await incrementTotalCars(FirebaseAuth.instance.currentUser!.uid);

      // Clear fields after successful addition
      _carNameController.clear();
      _modelController.clear();
      _conditionController.clear();
      _rentPerDayController.clear();
      _statusController.clear();
      setState(() {
        _pickedImage = null;
      });

      // Show success message
      Get.snackbar("Success", "Car added successfully!");
    } catch (e) {
      Get.snackbar("Error", "Failed to add car");
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> incrementTotalCars(String currentUserID) async {
    try {
      // Reference to the user's document in Firestore
      DocumentReference userRef =
          FirebaseFirestore.instance.collection('users').doc(currentUserID);

      // Get the current user's data
      DocumentSnapshot userSnapshot = await userRef.get();

      if (userSnapshot.exists) {
        // Fetch the current value of totalCars after casting the data to a Map<String, dynamic>
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        int currentTotalCars = userData['totalCars'] ?? 0;

        // Increment totalCars by 1
        int updatedTotalCars = currentTotalCars + 1;

        // Update the totalCars field in Firestore
        await userRef.update({'totalCars': updatedTotalCars});
      } else {
        // If the document does not exist, you can handle it here
        print("User document not found");
      }
    } catch (e) {
      print("Error updating totalCars: $e");
    }
  }

  Future<String> _uploadImage(File image) async {
    try {
      // Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('car_images/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }
}
