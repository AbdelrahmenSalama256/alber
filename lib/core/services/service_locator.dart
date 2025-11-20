import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/database/api/dio_consumer.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/features/home/data/datasources/services_remote_data_source.dart';
import 'package:qafeel/features/home/data/repo/home_repo.dart';
import 'package:qafeel/features/home/data/repositories/services_repository_impl.dart';
import 'package:qafeel/features/home/domain/repositories/services_repository.dart';
import 'package:qafeel/features/news/data/repo/news_repo.dart';
import 'package:qafeel/features/auth/data/repo/login_repo.dart';
import 'package:qafeel/features/auth/data/repo/register_repo.dart';
import 'package:qafeel/features/profile/data/repo/profile_repo.dart';
import 'package:qafeel/core/services/auth_return.dart';
import 'package:qafeel/features/auth/view/cubit/auth_cubit.dart';
import 'package:qafeel/features/profile/views/cubit/profile_cubit.dart';
import 'package:qafeel/features/services/views/cubit/services_cubit.dart';

final sl = GetIt.instance;
void initServiceLocator() {
//!external
  sl.registerLazySingleton(() => CacheHelper());
  sl.registerLazySingleton(() => GlobalCubit());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioConsumer(sl<Dio>()));
  sl.registerLazySingleton<ServicesRemoteDataSource>(
      () => ServicesRemoteDataSource(sl<DioConsumer>()));
  sl.registerLazySingleton<ServicesRepository>(
      () => ServicesRepositoryImpl(sl<ServicesRemoteDataSource>()));
  sl.registerLazySingleton(() => HomeRepo(sl<ServicesRepository>()));
  sl.registerLazySingleton(() => NewsRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => LoginRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => RegisterRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => ProfileRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => AuthReturnService());
  sl.registerFactory(() => AuthCubit(
        loginRepo: sl<LoginRepo>(),
        registerRepo: sl<RegisterRepo>(),
        cacheHelper: sl<CacheHelper>(),
        globalCubit: sl<GlobalCubit>(),
      ));
  sl.registerFactory(() => ProfileCubit(
        profileRepo: sl<ProfileRepo>(),
        globalCubit: sl<GlobalCubit>(),
        cacheHelper: sl<CacheHelper>(),
      ));
  sl.registerFactory(() => ServicesCubit(sl<HomeRepo>()));
  // sl.registerLazySingleton(() => RegisterRepo(sl<DioConsumer>()));
  // sl.registerLazySingleton(() => DataConnectionChecker());
  // sl.registerLazySingleton(() => NetworkInfoImpl(sl<DataConnectionChecker>()));
  //! Repositorys
}
