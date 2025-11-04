class ServiceModel {
  final int id;
  final String image;
  final String title;

  ServiceModel({required this.id, required this.image, required this.title});

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        image: json['image']?.toString() ?? '',
        title: json['title']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image': image,
        'title': title,
      };
}
