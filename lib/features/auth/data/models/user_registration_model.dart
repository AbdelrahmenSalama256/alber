import 'package:image_picker/image_picker.dart';

class UserRegistrationModel {
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String name;
  final String mobile;
  final String? gender;
  final String? fcmToken;
  final XFile? image;

  UserRegistrationModel({
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.name,
    required this.mobile,
    this.gender,
    this.fcmToken,
    this.image,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'displayName': name,
        'email': email,
        'phone': mobile.startsWith('+') ? mobile : '+$mobile',
        'password': password,
        'gender': gender ?? 'unspecified',
        'fcm_token': fcmToken,
      };
}
