import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/widgets/print_util.dart';
import 'package:qafeel/core/cubit/app_cubit.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';

import 'global_state.dart';

class GlobalCubit extends AppCubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());

  void init() {
    PrintUtil.warning(
        "User type is ${sl<CacheHelper>().getDataString(key: AppConstants.userType)}");
    PrintUtil.success(
        "${sl<CacheHelper>().getDataString(key: AppConstants.token)}");
    // getCurrentLocation();
  }

  int currentNavIndex = 2;
  ScrollController controller = ScrollController();

  // Shared UI resources and options
  // Centralized assets/labels used app-wide
  final String currencyIconAsset = 'assets/images/svg/currancy.svg';
  final String AppLogoInline = 'assets/images/png/alber-inline-logo.png';
  final List<String> periodicityOptions = const [
    'once',
    'monthly',
  ];

  // Global design tokens (tweak once, used everywhere)
  double radiusXs = 6.0;
  double radiusSm = 8.0;
  double radiusMd = 12.0;
  double radiusLg = 16.0;
  double radiusXl = 20.0;

  void setRadii({double? xs, double? sm, double? md, double? lg, double? xl}) {
    if (xs != null) radiusXs = xs;
    if (sm != null) radiusSm = sm;
    if (md != null) radiusMd = md;
    if (lg != null) radiusLg = lg;
    if (xl != null) radiusXl = xl;
    emitSafe(DesignTokensUpdated());
  }

  void changeBottomNavIndex(int index) {
    if (currentNavIndex != index) {
      currentNavIndex = index;
      emitSafe(BottomNavChangeState());
    }
  }

  String language = sl<CacheHelper>().getCachedLanguage();
  changeLanguage() async {
    sl<CacheHelper>().getCachedLanguage() == "en"
        ? await sl<CacheHelper>().cacheLanguage("ar")
        : await sl<CacheHelper>().cacheLanguage("en");
    // After caching the language, send it to backend with endpoint lang code
    final langCode = sl<CacheHelper>().getCachedLanguage();
    try {
      // await sl<ProfileRepo>().updateLang(langCode: langCode);
      PrintUtil.success("Language updated on backend: $langCode");
    } catch (e) {
      PrintUtil.error("Failed to update language on backend: $e");
    }
    language = sl<CacheHelper>().getCachedLanguage();
    log("language is $language");
    emitSafe(LanguageChangeState());
  }

  String? currentLocation;
  double currentLat = 30.062628785575555;
  double currentLong = 31.335285600000006;

  Future<void> getCurrentLocation() async {
    loc.Location location = loc.Location();
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        PrintUtil.error('Location services are disabled.');
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        PrintUtil.error('Location permission denied.');
        return;
      }
    }

    try {
      loc.LocationData locationData = await location.getLocation();
      double latitude = locationData.latitude!;
      double longitude = locationData.longitude!;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      final newAddress =
          "${place.subThoroughfare}${place.subThoroughfare == '' ? '' : ', '}"
                  "${place.thoroughfare}${place.thoroughfare == '' ? '' : ', '}"
                  "${place.subAdministrativeArea}${place.subAdministrativeArea == '' ? '' : ', '}"
                  "${place.administrativeArea}${place.administrativeArea == '' ? '' : ', '}"
                  "${place.country}"
              .trim();

      PrintUtil.warning('Current Location: $newAddress');
      PrintUtil.warning('Lat: $latitude, Lng: $longitude');
      currentLocation = newAddress;
      currentLat = latitude;
      currentLong = longitude;
    } on Exception catch (e) {
      PrintUtil.warning('Location request: $e');
    }
  }
}
