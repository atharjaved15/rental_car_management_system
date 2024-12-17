class RequestModel {
  final String id;
  final String carName;
  final String model;
  final double rentPerDay;
  final double condition;
  final String carImage;
  final String status;
  final String ownerId; // The owner of the car
  final String userId; // The user who requested the car
  final String carId; // The ID of the car being requested

  RequestModel({
    required this.id,
    required this.carImage,
    required this.carName,
    required this.model,
    required this.rentPerDay,
    required this.condition,
    required this.status,
    required this.ownerId,
    required this.userId,
    required this.carId,
  });

  // To create a RequestModel from Firestore data
  factory RequestModel.fromMap(Map<String, dynamic> map, String documentId) {
    return RequestModel(
      id: documentId,
      carName:
          map['carName'] ?? 'Unknown Car', // Default if the key doesn't exist
      model: map['carModel'] ??
          'Unknown Model', // Default if the key doesn't exist
      rentPerDay: map['rentPerDay']?.toDouble() ??
          0.0, // Convert to double and default to 0.0
      condition: map['condition']?.toDouble() ??
          0.0, // Convert to double and default to 0.0
      status: map['status'] ??
          'Pending', // Default to 'Pending' if the key doesn't exist
      ownerId:
          map['ownerId'] ?? '', // Default empty string if the key doesn't exist
      userId:
          map['userId'] ?? '', // Default empty string if the key doesn't exist
      carId: map['carId'] ?? '',
      carImage:
          map['carImage'], // Default empty string if the key doesn't exist
    );
  }

  // To convert RequestModel to Firestore data format
  Map<String, dynamic> toMap() {
    return {
      'carName': carName,
      'model': model,
      'rentPerDay': rentPerDay,
      'condition': condition,
      'status': status,
      'ownerId': ownerId,
      'userId': userId,
      'carId': carId,
      'carImage': carImage,
    };
  }
}
