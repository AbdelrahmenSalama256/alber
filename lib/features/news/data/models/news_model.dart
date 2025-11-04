class NewsModel {
  final int id;
  final String imageAsset;
  final String title;
  final String subtitle;

  const NewsModel({
    required this.id,
    required this.imageAsset,
    required this.title,
    required this.subtitle,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        imageAsset: json['imageAsset']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
        subtitle: json['subtitle']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'imageAsset': imageAsset,
        'title': title,
        'subtitle': subtitle,
      };
}

