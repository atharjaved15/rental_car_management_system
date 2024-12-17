import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_car_management_system/controllers/owner_data_controller.dart';
import 'package:rental_car_management_system/models/request_model.dart'; // Ensure correct import for RequestModel

class OwnerRequestsScreen extends StatelessWidget {
  final OwnerController rentalRequestsController = Get.put(OwnerController());

  OwnerRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rental Requests"),
        centerTitle: true,
      ),
      body: Obx(() {
        // Fetching rental requests
        var rentalRequests = rentalRequestsController.rentalRequests;

        if (rentalRequests.isEmpty) {
          return const Center(child: Text("No rental requests available."));
        }
        // List of rental requests
        return ListView.builder(
          itemCount: rentalRequests.length,
          itemBuilder: (context, index) {
            RequestModel request =
                rentalRequests[index]; // Correctly access the list

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 4,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(request.carName,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Model: ${request.model}",
                        style: const TextStyle(fontSize: 16)),
                    Text(
                        "Rent per Day: \$${request.rentPerDay.toStringAsFixed(2)}",
                        style: const TextStyle(fontSize: 16)),
                    Text("Condition: ${request.condition.toStringAsFixed(1)} ★",
                        style: const TextStyle(fontSize: 16)),
                    Text("Status: ${request.status}",
                        style: const TextStyle(fontSize: 16)),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      onPressed: () async {
                        // Add approve logic here
                        await rentalRequestsController.approveRequest(
                          request.id,
                          request.carId,
                          request.userId,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () async {
                        // Add reject logic here
                        await rentalRequestsController
                            .rejectRequest(request.id);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
