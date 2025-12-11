import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:qafeel/core/constants/widgets/errors/exceptions.dart';
import 'package:qafeel/core/database/api/api_consumer.dart';
import 'package:qafeel/core/database/api/end_points.dart';

import '../model/home_slider_model.dart';

class HomeRepo {
  final ApiConsumer api;
  HomeRepo(this.api);

  Future<Either<String, List<HomeSliderModel>>> fetchSliders({
    required int branchId,
    String sliderType = 'home',
  }) async {
    try {
      final Response res = await api.get(
        EndPoints.sliders(sliderType: sliderType, branchId: branchId),
      );
      final body = res.data;

      if (body is Map<String, dynamic>) {
        final status = body['status'];
        if (status is Map<String, dynamic> &&
            (status['error'] == false || status['code'] == 200)) {
          final data = body['data'];
          if (data is List) {
            final sliders = data
                .whereType<Map<String, dynamic>>()
                .map((json) => HomeSliderModel.fromJson(json))
                .toList();
            return Right(sliders);
          }
          return const Left('No sliders data found');
        } else {
          final message =
              status?['message']?.toString() ?? 'Failed to load sliders';
          return Left(message);
        }
      }
      return const Left('Invalid sliders response format');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
