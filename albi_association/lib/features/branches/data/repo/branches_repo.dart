import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:qafeel/core/constants/widgets/errors/exceptions.dart';
import 'package:qafeel/core/database/api/api_consumer.dart';
import 'package:qafeel/core/database/api/end_points.dart';
import 'package:qafeel/features/branches/data/models/branch.dart';

class BranchesRepo {
  final ApiConsumer api;
  BranchesRepo(this.api);

  Future<Either<String, List<Branch>>> fetchBranches() async {
    try {
      final Response res = await api.get(EndPoints.getAllBranches());
      final body = res.data;
      List<dynamic> list = _extractList(body);
      final items = list
          .whereType<Map<String, dynamic>>()
          .map((e) => Branch.fromJson(e))
          .where((b) => b.id != 0 && b.name.isNotEmpty)
          .toList();
      return Right(items);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }

  List<dynamic> _extractList(dynamic body) {
    if (body is List) return body;
    if (body is Map<String, dynamic>) {
      // Common containers
      final candidates = [
        body['data'],
        body['result'],
        body['branches'],
        body['items'],
      ];
      for (final c in candidates) {
        if (c is List) return c;
      }
      // Nested data
      if (body['data'] is Map<String, dynamic>) {
        final data = body['data'] as Map<String, dynamic>;
        for (final v in data.values) {
          if (v is List) return v;
        }
      }
    }
    return <dynamic>[];
  }
}

