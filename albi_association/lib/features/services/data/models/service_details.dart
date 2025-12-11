class ServiceDetailsModel {
  final int id;
  final String title;
  final String? description;
  final String? cover;
  final String? image;
  final String? img;
  final String? priceValue;
  final num? basicValue;
  final num? targetValue;
  final num? collectedValue;
  final num? percent;
  final num? multi1;
  final num? multi2;
  final num? multi3;
  final int? viewpercent;

  ServiceDetailsModel({
    required this.id,
    required this.title,
    this.description,
    this.cover,
    this.image,
    this.img,
    this.priceValue,
    this.basicValue,
    this.targetValue,
    this.collectedValue,
    this.percent,
    this.multi1,
    this.multi2,
    this.multi3,
    this.viewpercent,
  });

  factory ServiceDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : json;

    return ServiceDetailsModel(
      id: _toInt(data['id']) ?? _toInt(json['id']) ?? 0,
      title: (data['title'] ?? json['title'] ?? '').toString(),
      description:
          (data['desc'] ?? data['content'] ?? json['desc'])?.toString(),
      cover: (data['cover'] ?? json['cover'])?.toString(),
      image: (data['image'] ?? json['image'])?.toString(),
      img: (data['img'] ?? json['img'])?.toString(),
      priceValue: (data['price_value'] ?? json['price_value'])?.toString(),
      basicValue:
          _toNum(data['basic_service_value'] ?? json['basic_service_value']),
      targetValue: _toNum(data['target_value'] ?? json['target_value']),
      collectedValue:
          _toNum(data['collected_value'] ?? json['collected_value']),
      percent: _toNum(data['percent'] ?? json['percent']),
      multi1: _toNum(
          data['multiple_service_value_1'] ?? json['multiple_service_value_1']),
      multi2: _toNum(
          data['multiple_service_value_2'] ?? json['multiple_service_value_2']),
      multi3: _toNum(
          data['multiple_service_value_3'] ?? json['multiple_service_value_3']),
      viewpercent: _toInt(data['view_percent'] ?? json['view_percent']),
    );
  }

  // دالة مساعدة للحصول على أفضل صورة متاحة
  String? get displayImage {
    // أولوية: img > image > cover
    if (_isValidImage(img)) return img;
    if (_isValidImage(image)) return image;
    if (_isValidImage(cover)) return cover;
    return null;
  }

  bool _isValidImage(String? url) {
    return url != null &&
        url.isNotEmpty &&
        url != 'null' &&
        !url.contains('No translation');
  }
}

int? _toInt(dynamic v) {
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

num? _toNum(dynamic v) {
  if (v is num) return v;
  if (v is String) return num.tryParse(v);
  return null;
}
