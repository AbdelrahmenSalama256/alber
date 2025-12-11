class HomeSliderModel {
  final int id;
  final String img;
  final String type; // 'video' or 'image'
  final int? serviceId;
  final int? serviceSectionId;

  const HomeSliderModel({
    required this.id,
    required this.img,
    required this.type,
    this.serviceId,
    this.serviceSectionId,
  });

  factory HomeSliderModel.fromJson(Map<String, dynamic> json) =>
      HomeSliderModel(
        id: _toInt(json['id']) ?? 0,
        img: json['img']?.toString() ?? '',
        type: json['type']?.toString() ?? 'image',
        serviceId: _toInt(json['service_id']),
        serviceSectionId: _toInt(json['service_section_id']),
      );

  bool get isVideo => type.toLowerCase() == 'video';
  bool get isImage => type.toLowerCase() == 'image';
}

int? _toInt(dynamic v) {
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}
