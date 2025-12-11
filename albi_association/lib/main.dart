import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qafeel/core/app/alber.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/settings/view/cubit/settings_cubit.dart';
import 'package:upgrader/upgrader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait for kiosk/mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Hide system overlays
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  // Service initialization
  initServiceLocator();
  if (kDebugMode) await Upgrader.clearSavedSettings();
  await sl<CacheHelper>().init();

  // Run app with DevicePreview enabled only in debug
  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<GlobalCubit>()..init()),
          BlocProvider(create: (context) => SettingsCubit()),
        ],
        child: const Alber(),
      ),
    ),
  );
}
