class StatusInfo {
  final int? code;
  final bool? error;
  final String? message;

  StatusInfo({this.code, this.error, this.message});

  factory StatusInfo.fromJson(Map<String, dynamic> json) => StatusInfo(
        code: _toInt(json['code']),
        error: _toBool(json['error']),
        message: json['message']?.toString(),
      );
}

class DonorModel {
  final int? id;
  final String? membershipNo;
  final String? phone;
  final String? email;
  final String? identNum;
  final String? name;
  final String? gender;
  final String? status;

  DonorModel({
    this.id,
    this.membershipNo,
    this.phone,
    this.email,
    this.identNum,
    this.name,
    this.gender,
    this.status,
  });

  DonorModel copyWith({
    int? id,
    String? membershipNo,
    String? phone,
    String? email,
    String? identNum,
    String? name,
    String? gender,
    String? status,
  }) {
    return DonorModel(
      id: id ?? this.id,
      membershipNo: membershipNo ?? this.membershipNo,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      identNum: identNum ?? this.identNum,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      status: status ?? this.status,
    );
  }

  factory DonorModel.fromJson(Map<String, dynamic> json) => DonorModel(
        id: _toInt(json['id']),
        membershipNo: json['membership_no']?.toString(),
        phone: json['phone']?.toString(),
        email: json['email']?.toString(),
        identNum: json['ident_num']?.toString(),
        name: json['name']?.toString(),
        gender: json['gender']?.toString(),
        status: json['status']?.toString(),
      );
}

class OtpConfirmData {
  final DonorModel? donor;
  final String? token;

  OtpConfirmData({this.donor, this.token});

  factory OtpConfirmData.fromJson(Map<String, dynamic> json) => OtpConfirmData(
        donor: json['donor'] is Map<String, dynamic>
            ? DonorModel.fromJson(json['donor'] as Map<String, dynamic>)
            : null,
        token: json['token']?.toString(),
      );
}

class OtpConfirmResponse {
  final StatusInfo? status;
  final OtpConfirmData? data;

  OtpConfirmResponse({this.status, this.data});

  factory OtpConfirmResponse.fromJson(Map<String, dynamic> json) =>
      OtpConfirmResponse(
        status: json['status'] is Map<String, dynamic>
            ? StatusInfo.fromJson(json['status'] as Map<String, dynamic>)
            : null,
        data: json['data'] is Map<String, dynamic>
            ? OtpConfirmData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
      );
}

int? _toInt(dynamic v) {
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

bool? _toBool(dynamic v) {
  if (v is bool) return v;
  if (v is String) return v.toLowerCase() == 'true' || v == '1';
  if (v is num) return v != 0;
  return null;
}

