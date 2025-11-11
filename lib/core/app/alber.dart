import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qafeel/core/component/widgets/app_theme.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/cubit/global_state.dart';
import 'package:qafeel/core/locale/localization_settings.dart';

import '../../features/intro/splash/view/splash_screen.dart';
import '../services/service_locator.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Alber extends StatelessWidget {
  const Alber({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ));
    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        return ScreenUtilInit(
          designSize: const Size(375, 812),
          builder: (context, child) {
            return MaterialApp(
              useInheritedMediaQuery: true,
              locale: Locale(sl<GlobalCubit>().language),
              navigatorKey: navigatorKey,
              theme: AppTheme.getLightTheme(sl<GlobalCubit>().language),
              builder: (context, child) {
                // Wrap with DevicePreview builder in debug to simulate devices
                final wrapped = DevicePreview.appBuilder(context, child);
                final mediaQueryData = MediaQuery.of(context);
                final scale = mediaQueryData.textScaler
                    .clamp(minScaleFactor: 1.0, maxScaleFactor: 1.0);
                return MediaQuery(
                  data: mediaQueryData.copyWith(textScaler: scale),
                  child: wrapped,
                );
              },
              debugShowCheckedModeBanner: false,
              //!Localization Settings
              localizationsDelegates: localizationsDelegatesList,
              supportedLocales: supportedLocalesList,

              //!App Scroll Behavior
              scrollBehavior: ScrollConfiguration.of(context)
                  .copyWith(physics: const BouncingScrollPhysics()),
              //! Theme

              //!Routing
              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
