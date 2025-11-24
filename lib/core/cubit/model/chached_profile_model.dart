class CachedProfile {
  final int id;
  final String name;
  final String displayname;
  final String? email;
  final String? phone;
  final String? membershipId;
  final String? avatar;

  const CachedProfile({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.membershipId,
    this.avatar,
    required this.displayname,
  });

  CachedProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? membershipId,
    String? avatar,
    String? displayname,
  }) {
    return CachedProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      membershipId: membershipId ?? this.membershipId,
      avatar: avatar ?? this.avatar,
      displayname: displayname ?? this.displayname,
    );
  }

  factory CachedProfile.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['userId'];
    final parsedId = rawId is num
        ? rawId.toInt()
        : rawId is String
            ? rawId.hashCode
            : 0;
    return CachedProfile(
      id: parsedId,
      name: json['name']?.toString() ?? '',
      displayname:
          json['displayName']?.toString() ?? json['name']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['mobile']?.toString() ?? json['phone']?.toString(),
      membershipId:
          json['member_id']?.toString() ?? json['userId']?.toString() ?? '',
      avatar: json['image_url']?.toString() ?? json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'mobile': phone,
        'member_id': membershipId,
        'image_url': avatar,
        'userId': membershipId,
        'displayName': displayname,
      };
}
