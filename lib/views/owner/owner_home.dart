import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_car_management_system/controllers/owner_data_controller.dart';
import 'package:rental_car_management_system/models/car_model.dart';
import 'package:rental_car_management_system/models/owner_model.dart';

class OwnerDashboardScreen extends StatelessWidget {
  final OwnerController ownerController = Get.put(OwnerController());

  OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        Owner? owner = ownerController.currentOwner.value;

        if (owner == null) {
          return const Center(
            child: Text(
              "No Owner Data Found",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Text(
                  "Welcome, ${owner.name}!",
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Divider(thickness: 1, color: Colors.grey),

                // Stats Section
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      title: "Earnings",
                      value: "\$${owner.earning.toStringAsFixed(2)}",
                      color: Colors.blueAccent,
                      icon: Icons.monetization_on,
                    ),
                    _buildStatCard(
                      title: "Total Cars",
                      value: "${owner.totalCars}",
                      color: Colors.greenAccent,
                      icon: Icons.directions_car,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // My Cars Section
                const Text(
                  "My Cars",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ownerController.cars.isEmpty
                    ? const Center(
                        child: Text(
                          "No cars listed yet",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ownerController.cars.length,
                        itemBuilder: (context, index) {
                          Car car = ownerController.cars[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: car.carImage.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        car.carImage,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.car_rental,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                              title: Text(
                                car.carName,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Model: ${car.model}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    "Rent per Day: \$${car.rentPerDay}",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  // Add car-specific action (e.g., edit or remove)
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent),
                                child: const Text(
                                  "Remove",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: 150,
      height: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
