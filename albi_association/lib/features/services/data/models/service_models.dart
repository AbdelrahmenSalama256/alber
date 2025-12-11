class ServiceItem {
  final int id;
  final String title;
  final String icon;

  ServiceItem({required this.id, required this.title, required this.icon});

  factory ServiceItem.fromJson(Map<String, dynamic> json) => ServiceItem(
        id: _toInt(json['id']) ?? 0,
        title: json['title']?.toString() ?? '',
        icon: json['icon']?.toString() ?? '',
      );
}

class ServiceSection {
  final int id;
  final String title;
  final String? desc;
  final String? cover;
  final String? image;
  final int servicesCount;
  final String? type;
  final List<ServiceItem> services;

  ServiceSection({
    required this.id,
    required this.title,
    this.desc,
    this.cover,
    this.image,
    required this.servicesCount,
    this.type,
    required this.services,
  });

  factory ServiceSection.fromJson(Map<String, dynamic> json) => ServiceSection(
        id: _toInt(json['id']) ?? 0,
        title: json['title']?.toString() ?? '',
        desc: json['desc']?.toString(),
        cover: json['cover']?.toString(),
        image: json['image']?.toString(),
        servicesCount: _toInt(json['services_count']) ?? 0,
        type: json['type']?.toString(),
        services: (json['services'] as List?)
                ?.whereType<Map<String, dynamic>>()
                .map(ServiceItem.fromJson)
                .toList() ??
            [],
      );
}

int? _toInt(dynamic v) {
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

