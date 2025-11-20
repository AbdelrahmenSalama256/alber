import 'package:dartz/dartz.dart';
import 'package:qafeel/core/constants/widgets/errors/exceptions.dart';
import 'package:qafeel/features/home/data/datasources/services_remote_data_source.dart';
import 'package:qafeel/features/home/data/models/service_model.dart';
import 'package:qafeel/features/home/domain/repositories/services_repository.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final ServicesRemoteDataSource remoteDataSource;

  ServicesRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, List<ServiceModel>>> fetchServices({
    int page = 1,
    int limit = 25,
  }) async {
    try {
      final services =
          await remoteDataSource.fetchServices(page: page, limit: limit);
      return Right(services);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } on FormatException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left('Failed to load services: $e');
    }
  }

  @override
  Future<Either<String, ServiceModel>> fetchServiceById(
      String serviceId) async {
    try {
      final service = await remoteDataSource.fetchServiceById(serviceId);
      return Right(service);
    } on ServerException catch (e) {
      return Left(e.errorModel.detail);
    } on NoInternetException catch (e) {
      return Left(e.errorModel.detail);
    } on FormatException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left('Failed to load service: $e');
    }
  }
}
