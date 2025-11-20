import 'package:qafeel/core/database/api/end_points.dart';

class ServiceModel {
  final String id;
  final String slug;
  final String title;
  final String? titleAr;
  final String summary;
  final String? summaryAr;
  final String? details;
  final String? detailsAr;
  final double? goalAmount;
  final double? collectedAmount;
  final String donationType;
  final String pricingType;
  final bool allowCustomAmount;
  final double? minAmount;
  final double? maxAmount;
  final bool isFeatured;
  final bool isQuickDonateEnabled;
  final bool isPublished;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? publishedAt;
  final String? orgId;
  final String? categoryId;
  final String? coverFileId;
  final String? iconFileId;
  final String image;
  final List<ServiceGalleryItem> gallery;
  final Map<String, dynamic>? metadata;

  ServiceModel({
    required this.id,
    required this.slug,
    required this.title,
    this.titleAr,
    required this.summary,
    this.summaryAr,
    this.details,
    this.detailsAr,
    this.goalAmount,
    this.collectedAmount,
    required this.donationType,
    required this.pricingType,
    required this.allowCustomAmount,
    this.minAmount,
    this.maxAmount,
    required this.isFeatured,
    required this.isQuickDonateEnabled,
    required this.isPublished,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.orgId,
    this.categoryId,
    this.coverFileId,
    this.iconFileId,
    required this.image,
    this.gallery = const [],
    this.metadata,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    final titleMap = _normalizeLocalized(json['title']);
    final summaryMap = _normalizeLocalized(json['summary']);
    final detailsMap = _normalizeLocalized(json['details']);
    final metadata = json['metadata'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(json['metadata'] as Map)
        : null;
    final slug = json['slug']?.toString() ?? '';
    final rawId = json['id']?.toString();
    final resolvedId = (rawId != null && rawId.isNotEmpty)
        ? rawId
        : (slug.isNotEmpty ? slug : json.hashCode.toString());
    final galleryItems = _extractGallery(json);
    return ServiceModel(
      id: resolvedId,
      slug: slug,
      title: _resolveText(titleMap),
      titleAr: titleMap['ar'],
      summary: _resolveText(summaryMap),
      summaryAr: summaryMap['ar'],
      details: _resolveText(detailsMap),
      detailsAr: detailsMap['ar'],
      goalAmount: _parseAmount(json['goalAmount']),
      collectedAmount: _parseAmount(json['collectedAmount']),
      donationType: json['donationType']?.toString() ?? '',
      pricingType: json['pricingType']?.toString() ?? '',
      allowCustomAmount: json['allowCustomAmount'] == true,
      minAmount: _parseAmount(json['minAmount']),
      maxAmount: _parseAmount(json['maxAmount']),
      isFeatured: json['isFeatured'] == true,
      isQuickDonateEnabled: json['isQuickDonateEnabled'] == true,
      isPublished:
          (json['status']?.toString() ?? '').toLowerCase() == 'published',
      status: json['status']?.toString() ?? '',
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      publishedAt: _parseDate(json['publishedAt']),
      orgId: json['orgId']?.toString(),
      categoryId: json['categoryId']?.toString(),
      coverFileId: json['coverFileId']?.toString(),
      iconFileId: json['iconFileId']?.toString(),
      image: _resolveImage(metadata),
      gallery: galleryItems,
      metadata: metadata,
    );
  }

  String titleForLanguage(String language) {
    if (language == 'ar' && (titleAr?.isNotEmpty ?? false)) {
      return titleAr!;
    }
    return title.isNotEmpty ? title : (titleAr ?? '');
  }

  String summaryForLanguage(String language) {
    if (language == 'ar' && (summaryAr?.isNotEmpty ?? false)) {
      return summaryAr!;
    }
    return summary.isNotEmpty ? summary : (summaryAr ?? '');
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'slug': slug,
        'title': title,
        'title_ar': titleAr,
        'summary': summary,
        'summary_ar': summaryAr,
        'details': details,
        'details_ar': detailsAr,
        'goal_amount': goalAmount,
        'collected_amount': collectedAmount,
        'donation_type': donationType,
        'pricing_type': pricingType,
        'allow_custom_amount': allowCustomAmount,
        'min_amount': minAmount,
        'max_amount': maxAmount,
        'is_featured': isFeatured,
        'is_quick_donate_enabled': isQuickDonateEnabled,
        'is_published': isPublished,
        'status': status,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'published_at': publishedAt?.toIso8601String(),
        'org_id': orgId,
        'category_id': categoryId,
        'cover_file_id': coverFileId,
        'icon_file_id': iconFileId,
        'image': image,
        'gallery': gallery.map((e) => e.toJson()).toList(),
        'metadata': metadata,
      };

  static Map<String, String> _normalizeLocalized(dynamic value) {
    final map = <String, String>{};
    if (value is Map) {
      value.forEach((key, val) {
        if (val == null) return;
        final str = val.toString().trim();
        if (str.isNotEmpty) {
          map[key.toString()] = str;
        }
      });
    } else if (value is String) {
      final str = value.trim();
      if (str.isNotEmpty) {
        map['default'] = str;
      }
    }
    return map;
  }

  static String _resolveText(Map<String, String> localized) {
    if (localized.isEmpty) return '';
    return localized['default'] ??
        localized['en'] ??
        localized['ar'] ??
        localized.entries.first.value;
  }

  static double? _parseAmount(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    final parsed = double.tryParse(value.toString());
    return parsed;
  }

  static String _resolveImage(Map<String, dynamic>? metadata) {
    final media = metadata?['media'];
    if (media is Map<String, dynamic>) {
      final candidates = [
        media['appIcon']?.toString(),
        media['img']?.toString(),
      ];
      for (final candidate in candidates) {
        if (candidate == null) continue;
        final value = candidate.trim();
        if (value.isEmpty) continue;
        if (value.startsWith('http')) return value;
        return '${EndPoints.baseUrlWithoutApi}$value';
      }
    }
    return '';
  }

  static List<ServiceGalleryItem> _extractGallery(Map<String, dynamic> json) {
    final gallery = json['gallery'];
    if (gallery is List) {
      return gallery
          .whereType<Map<String, dynamic>>()
          .map(ServiceGalleryItem.fromJson)
          .toList();
    }
    return const [];
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    final str = value.toString();
    if (str.isEmpty) return null;
    return DateTime.tryParse(str);
  }
}

class ServiceGalleryItem {
  final String? label;
  final String? fileId;
  final int? sortOrder;

  const ServiceGalleryItem({this.label, this.fileId, this.sortOrder});

  factory ServiceGalleryItem.fromJson(Map<String, dynamic> json) {
    return ServiceGalleryItem(
      label: json['label']?.toString(),
      fileId: json['fileId']?.toString(),
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'fileId': fileId,
        'sortOrder': sortOrder,
      };
}
