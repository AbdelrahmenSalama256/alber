import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/widgets/print_util.dart';
import 'package:qafeel/core/database/api/end_points.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';

import '../../features/settings/data/models/settings_model.dart';
import 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());

  void init() {
    PrintUtil.warning(
        "User type is ${sl<CacheHelper>().getDataString(key: AppConstants.userType)}");
    PrintUtil.success(
        "Token: ${sl<CacheHelper>().getDataString(key: ApiKey.token) ?? ''}");
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
    // After caching the language, optionally send it to the service with endpoint lang code
    final langCode = sl<CacheHelper>().getCachedLanguage();
    try {
      // await sl<ProfileRepo>().updateLang(langCode: langCode);
      PrintUtil.success("Language updated: $langCode");
    } catch (e) {
      PrintUtil.error("Failed to update language: $e");
    }
    language = sl<CacheHelper>().getCachedLanguage();
    log("language is $language");
    emit(LanguageChangeState());
  }

  Future<void> setLanguage(String code) async {
    await sl<CacheHelper>().cacheLanguage(code == 'ar' ? 'ar' : 'en');
    final langCode = sl<CacheHelper>().getCachedLanguage();
    try {
      PrintUtil.success("Language updated: $langCode");
    } catch (e) {
      PrintUtil.error("Failed to update language: $e");
    }
    language = langCode;
    log("language is $language");
    emit(LanguageChangeState());
  }

  // -------------------- Auth & session helpers --------------------
  bool get isAuthenticated =>
      (sl<CacheHelper>().getDataString(key: ApiKey.token)?.isNotEmpty ?? false);

  Future<void> cacheToken(String token) async {
    await sl<CacheHelper>().setData(ApiKey.token, token);
    emit(GlobalTokenUpdated());
  }

  Future<void> clearToken() async {
    await sl<CacheHelper>().removeData(key: ApiKey.token);
    emit(GlobalTokenUpdated());
  }

  Future<void> setLoginPhone(String phone) async {
    await sl<CacheHelper>().setData(AppConstants.loginPhone, phone);
  }

  int? selectedBranchId;
  String? selectedBranchName;
  Future<void> setSelectedBranch(
      {required int id, required String name}) async {
    selectedBranchId = id;
    selectedBranchName = name;
    await sl<CacheHelper>()
        .setData(AppConstants.selectedBranchId, id.toString());
    await sl<CacheHelper>().setData(AppConstants.selectedBranchName, name);
    emit(GlobalLocationUpdated());
  }

  Future<void> setDonor({
    int? id,
    String? name,
    String? phone,
    String? membershipNo,
  }) async {
    if (id != null) {
      await sl<CacheHelper>().setData(AppConstants.donorId, id.toString());
    }
    if (name != null) {
      await sl<CacheHelper>().setData(AppConstants.donorName, name);
    }
    if (phone != null) {
      await sl<CacheHelper>().setData(AppConstants.donorPhone, phone);
    }
    if (membershipNo != null) {
      await sl<CacheHelper>()
          .setData(AppConstants.donorMembershipNo, membershipNo);
    }
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

  // ==================== INACTIVITY TIMER ====================
  Timer? _inactivityTimer;
  final int _inactivityDuration = 9000;
  int _currentSeconds = 9000;
  bool _isTimerActive = false;

  void startInactivityTimer() {
    if (_isTimerActive) {
      resetInactivityTimer();
      return;
    }

    _isTimerActive = true;
    _currentSeconds = _inactivityDuration;
    _startTimer();
    emit(InactivityTimerUpdateState(remainingSeconds: _currentSeconds));
  }

  void resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _currentSeconds = _inactivityDuration;
    _startTimer();
    emit(InactivityTimerUpdateState(remainingSeconds: _currentSeconds));
  }

  void _startTimer() {
    if (!_isTimerActive) return;

    _inactivityTimer?.cancel();
    _inactivityTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_currentSeconds > 0) {
        _currentSeconds--;
        emit(InactivityTimerUpdateState(remainingSeconds: _currentSeconds));
      } else {
        _handleAutoNavigate();
      }
    });
  }

  void _handleAutoNavigate() {
    _inactivityTimer?.cancel();
    _isTimerActive = false;
    PrintUtil.success('Auto navigating to home due to inactivity');
    emit(GlobalAutoNavigateState());
  }

  void stopInactivityTimer() {
    _inactivityTimer?.cancel();
    _isTimerActive = false;
    _currentSeconds = _inactivityDuration;
  }

  void pauseTimer() {
    _inactivityTimer?.cancel();
  }

  void resumeTimer() {
    if (_isTimerActive && _currentSeconds > 0) {
      _startTimer();
    }
  }

  bool get isTimerActive => _isTimerActive;

  int get remainingSeconds => _currentSeconds;

  @override
  Future<void> close() {
    _inactivityTimer?.cancel();
    _isTimerActive = false;
    return super.close();
  }

  SettingsModel? _cachedSettings;
  void cacheSettings(SettingsModel settings) {
    _cachedSettings = settings;
  }

  SettingsModel? get settings => _cachedSettings;
}
