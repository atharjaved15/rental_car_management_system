class Owner {
  String uid;
  String name;
  String email;
  String role;
  double earning;
  int totalCars;

  Owner({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.earning,
    required this.totalCars,
  });

  factory Owner.fromMap(Map<String, dynamic> map) {
    return Owner(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      earning: map['earning'] != null
          ? double.tryParse(map['earning'].toString()) ?? 0.0
          : 0.0,
      totalCars: map['totalCars'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'role': role,
      'earning': earning,
      'totalCars': totalCars,
    };
  }
}
