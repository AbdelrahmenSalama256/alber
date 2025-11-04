import 'package:qafeel/features/news/data/models/news_model.dart';
import 'package:qafeel/features/news/data/models/pagination_meta_model.dart';

class NewsPageModel {
  final List<NewsModel> items;
  final PaginationMetaModel meta;

  const NewsPageModel({required this.items, required this.meta});
}

