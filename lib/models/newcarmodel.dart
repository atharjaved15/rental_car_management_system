class CarModel {
  final String carName;
  final String model;
  final double condition;
  final double rentPerDay;
  final String status;
  final String ownerId;
  final String imageUrl;

  CarModel({
    required this.carName,
    required this.model,
    required this.condition,
    required this.rentPerDay,
    required this.status,
    required this.ownerId,
    required this.imageUrl,
  });

  // Add a fromMap constructor if needed
  Map<String, dynamic> toMap() {
    return {
      'carName': carName,
      'model': model,
      'condition': condition,
      'rentPerDay': rentPerDay,
      'status': status,
      'ownerId': ownerId,
      'imageUrl': imageUrl,
    };
  }
}
