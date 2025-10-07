import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/widgets/print_util.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';

import 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
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

  void changeBottomNavIndex(int index) {
    if (currentNavIndex != index) {
      currentNavIndex = index;
      emit(BottomNavChangeState());
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
    emit(LanguageChangeState());
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
