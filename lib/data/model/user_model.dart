import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String? userId;

  final String email;
  final String? phone;

  final String? password;

  final String? name;
  final String? address;
  final String? specialty;

  final int? phoneNunber;
  final String? hoursOfOperation;
  final String? description;

  UserModel({
    this.userId,
    required this.email,
    required this.phone,
    required this.password,
    required this.name,
    required this.address,
    required this.specialty,
    required this.phoneNunber,
    this.hoursOfOperation,
    required this.description,
  });

  UserModel copyWith({
    String? userId,
    String? email,
    String? phone,
    String? password,
    String? name,
    String? address,
    String? specialty,
    int? phoneNunber,
    String? hoursOfOperation,
    String? description,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      name: name ?? this.name,
      address: address ?? this.address,
      specialty: specialty ?? this.specialty,
      phoneNunber: phoneNunber ?? this.phoneNunber,
      hoursOfOperation: hoursOfOperation ?? this.hoursOfOperation,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': userId,
      'email': email,
      'phone': phone,
      'name': name,
      'address': address,
      'specialty': specialty,
      'phoneNunber': phoneNunber,
      'hoursOfOperation': hoursOfOperation,
      'description': description,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] != null ? map['userId'] as String : null,
      email: map['email'] as String,
      phone: map['phone'] != null ? map['phone'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      specialty: map['specialty'] != null ? map['specialty'] as String : null,
      phoneNunber:
          map['phoneNunber'] != null ? map['phoneNunber'] as int : null,
      hoursOfOperation: map['hoursOfOperation'] != null
          ? map['hoursOfOperation'] as String
          : null,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(userId: $userId, email: $email, phone: $phone, password: $password, name: $name, address: $address, specialty: $specialty, phoneNunber: $phoneNunber, hoursOfOperation: $hoursOfOperation, description: $description)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.userId == userId &&
        other.email == email &&
        other.phone == phone &&
        other.password == password &&
        other.name == name &&
        other.address == address &&
        other.specialty == specialty &&
        other.phoneNunber == phoneNunber &&
        other.hoursOfOperation == hoursOfOperation &&
        other.description == description;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        password.hashCode ^
        name.hashCode ^
        address.hashCode ^
        specialty.hashCode ^
        phoneNunber.hashCode ^
        hoursOfOperation.hashCode ^
        description.hashCode;
  }
}
