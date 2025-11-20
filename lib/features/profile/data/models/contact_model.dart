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
  final String? displayname;
  final String? email;
  final String? mobile;
  final String? imageUrl;
  final List<String> roles;
  final List<String> permissions;
  final String? userGuid;
  final String? membershipId;

  const UserModel({
    required this.id,
    required this.name,
    this.email,
    this.mobile,
    this.imageUrl,
    this.roles = const [],
    this.permissions = const [],
    this.userGuid,
    this.membershipId,
    this.displayname,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['userId'];
    final idValue = rawId is num
        ? rawId.toInt()
        : rawId is String
            ? rawId.hashCode
            : 0;
    final roles = (json['roles'] as List?)
            ?.map((e) => e?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList() ??
        const <String>[];
    final permissions = (json['permissions'] as List?)
            ?.map((e) => e?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList() ??
        const <String>[];
    return UserModel(
      id: idValue,
      name: json['name']?.toString() ?? json['username']?.toString() ?? '',
      displayname: json['displayName']?.toString() ?? json['name']?.toString(),
      // email: json['email']?.toString() ?? json['email_address']?.toString(),

      email: json['email']?.toString(),
      mobile: json['mobile']?.toString() ?? json['phone']?.toString(),
      imageUrl: json['image']?.toString() ?? json['image_url']?.toString(),
      roles: roles,
      permissions: permissions,
      userGuid: json['userId']?.toString(),
      membershipId: json['member_id']?.toString() ??
          json['membership_id']?.toString() ??
          json['membershipId']?.toString() ??
          json['userId']?.toString(),
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? mobile,
    String? imageUrl,
    List<String>? roles,
    List<String>? permissions,
    String? userGuid,
    String? membershipId,
    String? displayname,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      imageUrl: imageUrl ?? this.imageUrl,
      roles: roles ?? this.roles,
      permissions: permissions ?? this.permissions,
      userGuid: userGuid ?? this.userGuid,
      membershipId: membershipId ?? this.membershipId,
      displayname: displayname ?? this.displayname,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'mobile': mobile,
        'image_url': imageUrl,
        'roles': roles,
        'permissions': permissions,
        'userId': userGuid,
        'member_id': membershipId,
        'displayName': displayname,
      };
}
