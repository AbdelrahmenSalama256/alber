import 'package:dartz/dartz.dart';
import 'package:qafeel/core/database/api/dio_consumer.dart';
import 'package:qafeel/features/news/data/models/news_model.dart';
import 'package:qafeel/features/news/data/models/news_page_model.dart';
import 'package:qafeel/features/news/data/models/pagination_meta_model.dart';

class NewsRepo {
  final DioConsumer api;

  NewsRepo(this.api);

  Future<Either<String, NewsPageModel>> fetchPage(int page) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final items = List.generate(12, (i) {
        final id = (page - 1) * 12 + (i + 1);
        return NewsModel(
          id: id,
          imageAsset: 'assets/images/png/news.png',
          title: 'جمعية البر بجدة',
          subtitle: 'شهادة "تكامل"',
        );
      });
      final meta = PaginationMetaModel(
        currentPage: page,
        lastPage: 3,
        perPage: 12,
        total: 36,
      );
      return Right(NewsPageModel(items: items, meta: meta));
    } catch (e) {
      return Left('Failed to load news: $e');
    }
  }
}
