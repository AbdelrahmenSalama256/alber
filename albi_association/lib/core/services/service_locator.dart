import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/database/api/dio_consumer.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/features/auth/data/repo/auth_repo.dart';
import 'package:qafeel/features/branches/data/repo/branches_repo.dart';
import 'package:qafeel/features/home/data/repo/home_repo.dart';
import 'package:qafeel/features/payments/data/repo/payment_repo.dart';
import 'package:qafeel/features/services/data/repo/services_repo.dart';
import 'package:qafeel/features/settings/data/repo/settings_repo.dart';
import 'package:qafeel/common/custom_keyboard/custom_keyboard_controller.dart';

final sl = GetIt.instance;
void initServiceLocator() {
//!external
  sl.registerLazySingleton(() => CacheHelper());
  sl.registerLazySingleton(() => GlobalCubit());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioConsumer(sl<Dio>()));
  //! Repos
  sl.registerLazySingleton(() => AuthRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => BranchesRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => SettingsRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => ServicesRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => HomeRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => PaymentRepo(sl<DioConsumer>()));
  sl.registerLazySingleton(() => CustomKeyBoardController());
  // sl.registerLazySingleton(() => RegisterRepo(sl<DioConsumer>()));
  // sl.registerLazySingleton(() => DataConnectionChecker());
  // sl.registerLazySingleton(() => NetworkInfoImpl(sl<DataConnectionChecker>()));
  //! Repositorys
}
