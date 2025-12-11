import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qafeel/core/component/widgets/app_theme.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/cubit/global_state.dart';
import 'package:qafeel/core/locale/localization_settings.dart';
import 'package:sizer/sizer.dart';

import '../../features/intro/splash/view/splash_screen.dart';
import '../services/service_locator.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class Alber extends StatelessWidget {
  const Alber({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark),
    );

    return BlocBuilder<GlobalCubit, GlobalState>(
      builder: (context, state) {
        return Sizer(
          builder: (context, orientation, deviceType) {
            return MaterialApp(
              navigatorKey: navigatorKey,
              useInheritedMediaQuery: true,
              debugShowCheckedModeBanner: false,

              builder: (context, widget) {
                final mq = MediaQuery.of(context);
                final scale = mq.textScaler
                    .clamp(minScaleFactor: 1.0, maxScaleFactor: 1.0);
                Widget wrapped = MediaQuery(
                  data: mq.copyWith(textScaler: scale),
                  child: widget!,
                );
                // Hook DevicePreview appBuilder only in debug
                if (kDebugMode) {
                  wrapped = DevicePreview.appBuilder(context, wrapped);
                }
                return wrapped;
              },

              // Theme
              theme: AppTheme.getLightTheme(sl<GlobalCubit>().language),

              // Localization
              localizationsDelegates: localizationsDelegatesList,
              supportedLocales: supportedLocalesList,
              locale: Locale(sl<GlobalCubit>().language),

              // Scroll behavior
              scrollBehavior: ScrollConfiguration.of(context)
                  .copyWith(physics: const BouncingScrollPhysics()),

              home: const SplashScreen(),
            );
          },
        );
      },
    );
  }
}
