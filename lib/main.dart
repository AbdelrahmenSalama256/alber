import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/app/alber.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:upgrader/upgrader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  // await Firebase.initializeApp();

  //! Orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  //! Status Bar Settings
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  //! Service Locator
  initServiceLocator();
  //! Update Checker
  if (kDebugMode) {
    await Upgrader.clearSavedSettings();
  }
  //! Cache Helper
  await sl<CacheHelper>().init();
  //! Application Starts From here.
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<GlobalCubit>()..init(),
        ),
      ],
      child: Alber(),
    ),
  );
}
