import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_car_management_system/controllers/user_data_controller.dart';
import 'package:rental_car_management_system/models/request_model.dart';

class RentalRequestsScreen extends StatelessWidget {
  final UserDataController userDataController = Get.put(UserDataController());

  RentalRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rental Requests"),
        centerTitle: true,
      ),
      body: Obx(() {
        // Check if rentalRequests list is empty
        if (userDataController.rentalRequests.isEmpty) {
          return const Center(
            child: Text("No rental requests available."),
          );
        }

        // List of rental requests
        return ListView.builder(
          itemCount: userDataController.rentalRequests.length,
          itemBuilder: (context, index) {
            // Fetch each rental request
            RequestModel request = userDataController.rentalRequests[index];

            // Extract data from the request map
            String carImage = request.carImage; // Car image URL
            String carName = request.carName; // Car name
            String status = request.status; // Request status
            double rentPerDay = request.rentPerDay; // Rent per day
            double condition = request.condition; // Car condition

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Car Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                    child: Image.network(
                      carImage,
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 120,
                        width: 120,
                        color: Colors.grey.shade300,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  // Car Details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Car Name
                          Text(
                            carName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Rent per Day
                          Text(
                            "Rent per Day: \$${rentPerDay.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Condition
                          Text(
                            "Condition: ${condition.toStringAsFixed(1)} ★",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Status
                          Text(
                            "Status: ${status == 'Approved' ? 'Approved' : 'Pending'}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: status == 'Approved'
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
