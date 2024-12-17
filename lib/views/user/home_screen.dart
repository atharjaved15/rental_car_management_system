import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rental_car_management_system/controllers/car_controller.dart';
import 'package:rental_car_management_system/controllers/data_controller.dart';
import 'package:rental_car_management_system/controllers/owner_data_controller.dart';
import 'package:rental_car_management_system/models/car_model.dart';
import 'package:rental_car_management_system/views/auth_views/sign_up.dart';
import 'package:rental_car_management_system/views/user/my_requests.dart';
import 'package:rental_car_management_system/views/user/user_profile_page.dart';

class HomeScreen extends StatelessWidget {
  final OwnerController ownerController = Get.put(OwnerController());
  final TextEditingController searchController = TextEditingController();
  final DataController userDataController = Get.put(DataController());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: isWeb
          ? null
          : AppBar(
              title: const Text("Home"),
              centerTitle: true,
            ),
      drawer: isWeb
          ? null
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text(
                      "Menu",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text("Home"),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text("My Rental Requests"),
                    onTap: () {
                      Get.to(RentalRequestsScreen());
                    },
                  ),
                  ListTile(
                    title: const Text("Current Rental Cars"),
                    onTap: () {},
                  ),
                  ListTile(
                    title: const Text("Profile"),
                    onTap: () {
                      Get.to(UserProfilePage());
                    },
                  ),
                  ListTile(
                    title: const Text("Logout"),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Get.snackbar('Success!', 'Logged Out Successfully!');
                      Get.offAll(SignUpScreen());
                    },
                  ),
                ],
              ),
            ),
      body: Obx(() {
        if (userDataController.currentUser.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final userName =
            userDataController.currentUser.value!['name'] ?? 'User';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Welcome message
              Text(
                "Welcome, $userName",
                style: TextStyle(
                  fontSize: isWeb ? 28 : 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              // Search bar
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Search cars by model",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Heading
              Text(
                "Available Cars for Rent",
                style: TextStyle(
                  fontSize: isWeb ? 24 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              // Scrollable car widgets
              Expanded(
                child: Obx(() {
                  final cars = ownerController.cars;
                  if (cars.isEmpty) {
                    return const Center(
                      child: Text("No cars available."),
                    );
                  }
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isWeb ? 2 : 1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: isWeb ? 1.5 : 0.8,
                    ),
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      return CarWidget(
                        car: car,
                        height: isWeb
                            ? 500
                            : MediaQuery.of(context).size.height * 0.4,
                        width: isWeb
                            ? MediaQuery.of(context).size.width * 0.5
                            : MediaQuery.of(context).size.width,
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }
}

class CarWidget extends StatefulWidget {
  final Car car; // The Car model is now the single parameter
  final double height;
  final double width;

  const CarWidget({
    required this.car,
    required this.height,
    required this.width,
    super.key,
  });

  @override
  State<CarWidget> createState() => _CarWidgetState();
}

class _CarWidgetState extends State<CarWidget> {
  final CarController carController = Get.put(CarController());

  @override
  Widget build(BuildContext context) {
    bool isMobile = widget.width <= 600;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      height: 500, // Increased height for better visuals
      width: isMobile ? widget.width : widget.width * 0.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Car Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.car.carImage, // Use car model's image
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          // Black Gradient Overlay
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [
                  Colors.black87,
                  Colors.black54,
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          // Car Details in the Overlay
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Car Name
                Text(
                  widget.car.carName, // Use car model's name
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                // Rent per Day
                Text(
                  "Rent: \$${widget.car.rentPerDay.toStringAsFixed(2)} / 24 hours",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                // Condition
                Text(
                  "Condition: ${widget.car.condition.toStringAsFixed(1)} ★",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                // Status
                Text(
                  "Status: ${widget.car.status == 'available' ? 'Available' : 'Hired'}",
                  style: TextStyle(
                    fontSize: 16,
                    color: widget.car.status == 'available'
                        ? Colors.greenAccent
                        : Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                // Model
                Text(
                  "Model: ${widget.car.model}", // Use car model's year
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 16),
                // Hire Button
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (await carController.hasRequested(widget.car.carId)) {
                        carController.showAlreadyRequestedPopup(context);
                      } else {
                        await carController.sendHiringRequest(
                            widget.car,
                            FirebaseAuth.instance.currentUser!.uid
                                .toString() // Pass the entire car object
                            );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 10,
                      ),
                      backgroundColor: widget.car.status == 'available'
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    child: const Text(
                      "Hire",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
