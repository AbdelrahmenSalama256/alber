import 'package:dio/dio.dart';
import 'package:qafeel/core/database/api/dio_consumer.dart';
import 'package:qafeel/core/database/api/end_points.dart';
import 'package:qafeel/features/home/data/models/service_model.dart';

class ServicesRemoteDataSource {
  final DioConsumer api;

  ServicesRemoteDataSource(this.api);

  Future<List<ServiceModel>> fetchServices({
    required int page,
    required int limit,
  }) async {
    final response = await api.get(
      EndPoints.services,
      queryParameters: {'page': page, 'limit': limit},
    );

    final payload = response is Response ? response.data : response;
    if (payload is! Map<String, dynamic>) {
      throw const FormatException('invalid_services_response');
    }

    final data = payload['data'];
    if (data is! List) {
      throw const FormatException('invalid_services_response');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(ServiceModel.fromJson)
        .toList();
  }

  Future<ServiceModel> fetchServiceById(String serviceId) async {
    final response = await api.get('${EndPoints.services}/$serviceId');
    final payload = response is Response ? response.data : response;
    if (payload is! Map<String, dynamic>) {
      throw const FormatException('invalid_service_response');
    }

    final data = payload['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('invalid_service_response');
    }

    return ServiceModel.fromJson(data);
  }
}
