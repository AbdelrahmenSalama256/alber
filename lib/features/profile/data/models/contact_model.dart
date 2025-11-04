class ContactResponse {
  final ContactData data;

  ContactResponse({required this.data});

  factory ContactResponse.fromJson(Map<String, dynamic> json) {
    return ContactResponse(
      data: ContactData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
      };
}

class ContactData {
  final String? token;
  final UserModel user;

  ContactData({required this.user, this.token});

  factory ContactData.fromJson(Map<String, dynamic> json) => ContactData(
        token: json['token']?.toString(),
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      );

  Map<String, dynamic> toJson() => {
        'token': token,
        'user': user.toJson(),
      };
}

class UserModel {
  final int id;
  final String name;
  final String? email;
  final String? mobile;
  final String? imageUrl;

  UserModel({
    required this.id,
    required this.name,
    this.email,
    this.mobile,
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: json['name']?.toString() ?? '',
        email: json['email']?.toString(),
        mobile: json['mobile']?.toString() ?? json['phone']?.toString(),
        imageUrl: json['image']?.toString() ?? json['image_url']?.toString(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'mobile': mobile,
        'image_url': imageUrl,
      };
}

