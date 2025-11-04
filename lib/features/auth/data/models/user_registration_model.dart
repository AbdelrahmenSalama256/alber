import 'package:image_picker/image_picker.dart';

class UserRegistrationModel {
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String name;
  final String mobile;
  final String? fcmToken;
  final XFile? image;

  UserRegistrationModel({
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.name,
    required this.mobile,
    this.fcmToken,
    this.image,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'name': name,
        'mobile': mobile,
        'fcm_token': fcmToken,
        'image': image?.path.split('/').last,
      };
}

