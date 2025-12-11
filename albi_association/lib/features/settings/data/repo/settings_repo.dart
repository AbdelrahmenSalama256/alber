import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:qafeel/core/constants/widgets/errors/exceptions.dart';
import 'package:qafeel/core/database/api/api_consumer.dart';
import 'package:qafeel/core/database/api/end_points.dart';
import 'package:qafeel/features/settings/data/models/settings_model.dart';

import '../../../../core/constants/widgets/print_util.dart';

class SettingsRepo {
  final ApiConsumer api;
  SettingsRepo(this.api);

  Future<Either<String, SettingsModel>> fetchSettings(
      {required int branchId}) async {
    try {
      final Response res = await api.get(EndPoints.settings(branchId));
      final body = res.data;
      PrintUtil.warning('Settings API Response: ${jsonEncode(body)}');

      if (body is Map<String, dynamic>) {
        final list = body['data'];
        if (list is List && list.isNotEmpty) {
          final first = list.first;
          if (first is Map<String, dynamic>) {
            PrintUtil.warning('NearPay config: ${first['nearpay']}');

            return Right(SettingsModel.fromJson(first));
          }
        }
      }
      return const Left('Invalid settings payload');
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
