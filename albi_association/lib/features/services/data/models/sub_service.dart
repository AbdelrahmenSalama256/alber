class SubService {
  final int id;
  final String title;
  final String? icon;
  final String? img;
  final String? cover;
  final String? content;
  final String? priceValue; // fixed/variable/multi
  final num? basicValue;
  final num? targetValue;
  final num? collectedValue;
  final num? percent;
  final num? multi1;
  final num? multi2;
  final num? multi3;
  final int? viewpercent;

  SubService({
    required this.id,
    required this.title,
    this.icon,
    this.img,
    this.cover,
    this.content,
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

  factory SubService.fromJson(Map<String, dynamic> json) => SubService(
        id: _toInt(json['id']) ?? 0,
        title: json['title']?.toString() ?? '',
        icon: _validateImageUrl(json['icon']?.toString()),
        img: _validateImageUrl(json['img']?.toString()),
        cover: _validateImageUrl(json['cover']?.toString()),
        content: json['content']?.toString(),
        priceValue: json['price_value']?.toString(),
        basicValue: _toNum(json['basic_service_value']),
        targetValue: _toNum(json['target_value']),
        collectedValue: _toNum(json['collected_value']),
        percent: _toNum(json['percent']),
        multi1: _toNum(json['multiple_service_value_1']),
        multi2: _toNum(json['multiple_service_value_2']),
        multi3: _toNum(json['multiple_service_value_3']),
        viewpercent: _toInt(json['view_percent']),
      );

  // Helper method to validate image URLs
  static String? _validateImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.contains('No translation') || url.contains('null')) return null;
    return url;
  }

  // Get the best available image (priority: img > cover > icon)
  String? get displayImage {
    if (_isValidImage(img)) return img;
    if (_isValidImage(cover)) return cover;
    if (_isValidImage(icon)) return icon;
    return null;
  }

  bool _isValidImage(String? url) {
    return url != null &&
        url.isNotEmpty &&
        !url.contains('No translation') &&
        !url.contains('null');
  }

  // Helper method to check if percentage should be shown
  bool get showPercentage => viewpercent == 1;

  // Helper method to get progress value (0 to 1)
  double get progress {
    if (targetValue == null || targetValue == 0) return 0.0;
    final collected = collectedValue ?? 0;
    return (collected / targetValue!).clamp(0.0, 1.0);
  }

  // Helper method to check if this is a donation service
  bool get isDonationService =>
      priceValue != null &&
      ['fixed', 'variable', 'multi'].contains(priceValue?.toLowerCase());

  // Helper method to get display amount based on price type
  num? get displayAmount {
    switch (priceValue?.toLowerCase()) {
      case 'fixed':
        return basicValue;
      case 'variable':
        return basicValue;
      case 'multi':
        return multi1 ?? multi2 ?? multi3 ?? basicValue;
      default:
        return basicValue;
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'icon': icon,
        'img': img,
        'cover': cover,
        'content': content,
        'price_value': priceValue,
        'basic_service_value': basicValue,
        'target_value': targetValue,
        'collected_value': collectedValue,
        'percent': percent,
        'multiple_service_value_1': multi1,
        'multiple_service_value_2': multi2,
        'multiple_service_value_3': multi3,
        'view_percent': viewpercent,
      };
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
