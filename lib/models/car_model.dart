class Car {
  final String carImage;
  final String carName;
  final double rentPerDay;
  final double condition;
  final String hiredBy;
  final String status;
  final String ownerId;
  final String model;
  final String carId;

  Car({
    required this.carImage,
    required this.carName,
    required this.rentPerDay,
    required this.condition,
    required this.hiredBy,
    required this.ownerId,
    required this.status,
    required this.model,
    required this.carId,
  });

  // Factory method to create a Car object from Firestore document data
  factory Car.fromMap(Map<String, dynamic> data) {
    return Car(
      carImage: data['imageUrl'] ?? 'Unknown',
      carName: data['carName'] ?? "ABC car",
      rentPerDay: (data['rentPerDay'] ?? 0).toDouble(),
      condition: (data['condition'] ?? 0).toDouble(),
      hiredBy: data['hiredBy'] ?? 'Xyz',
      model: data['model'] ?? '2021',
      ownerId: data['ownerId'] ?? 'No Id',
      status: data['status'] ?? 'Unavailable',
      carId: data['carId'],
    );
  }

  // Method to convert a Car object to a Firestore-compatible map
  Map<String, dynamic> toMap() {
    return {
      'imageUrl': carImage,
      'carName': carName,
      'rentPerDay': rentPerDay,
      'condition': condition,
      'hiredBy': hiredBy,
      'ownerId': ownerId,
      'status': status,
      'model': model,
      'carId': carId,
    };
  }
}
