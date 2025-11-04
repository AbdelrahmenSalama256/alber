import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/database/api/dio_consumer.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/features/home/data/repo/home_repo.dart';
import 'package:qafeel/features/news/data/repo/news_repo.dart';
import 'package:qafeel/features/auth/data/repo/login_repo.dart';
import 'package:qafeel/features/auth/data/repo/register_repo.dart';
import 'package:qafeel/features/profile/data/repo/profile_repo.dart';
import 'package:qafeel/core/services/auth_return.dart';

final sl = GetIt.instance;
void initServiceLocator() {
//!external
  sl.registerLazySingleton(() => CacheHelper());
  sl.registerLazySingleton(() => GlobalCubit());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioConsumer(sl<Dio>()));
  sl.registerLazySingleton(() => HomeRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => NewsRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => LoginRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => RegisterRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => ProfileRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => AuthReturnService());
  // sl.registerLazySingleton(() => RegisterRepo(sl<DioConsumer>()));
  // sl.registerLazySingleton(() => DataConnectionChecker());
  // sl.registerLazySingleton(() => NetworkInfoImpl(sl<DataConnectionChecker>()));
  //! Repositorys
}
