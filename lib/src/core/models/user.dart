import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safe_guard/src/core/database/shared_preference.dart';

class SafeGuardUser {
  SafeGuardUser({
    String? userID,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.dateOfBirth,
    this.imageUrl,
    this.height,
    this.weight,
    this.allergies,
  }) : userID = userID ?? LocalPreference.userID;
  final String userID;
  final String? fullName;
  final String email;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? imageUrl;
  final double? height;
  final double? weight;
  final List<String?>? allergies;
  factory SafeGuardUser.fromJson(Map<String, dynamic> json) => SafeGuardUser(
        userID: json['user_id'],
        email: json['email'],
        fullName: json['full_name'],
        phoneNumber: json['phone_number'],
        dateOfBirth: json['date_of_birth'] != null ? (json['date_of_birth'] as Timestamp).toDate() : null,
        imageUrl: json['image_url'],
        height: double.tryParse((json['height'].toString())),
        weight: double.tryParse((json['weight'].toString())),
        allergies: json['allergies'] == null ? null : List<String>.from((json['allergies'] as List<dynamic>)),
      );

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
        'date_of_birth': dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
        'height': height,
        'weight': weight,
      };
}
