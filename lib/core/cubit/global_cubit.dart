import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/constants/widgets/print_util.dart';
import 'package:qafeel/core/cubit/app_cubit.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/profile/data/repo/profile_repo.dart';

import 'global_state.dart';

class GlobalCubit extends AppCubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());

  CachedProfile? cachedProfile;

  void init() {
    loadCachedProfile();
    refreshProfile();
    PrintUtil.warning(
        "User type is ${sl<CacheHelper>().getDataString(key: AppConstants.userType)}");
    PrintUtil.success(
        "${sl<CacheHelper>().getDataString(key: AppConstants.token)}");
  }

  int currentNavIndex = 2;
  ScrollController controller = ScrollController();

  final String currencyIconAsset = 'assets/images/svg/currancy.svg';
  final String AppLogoInline = 'assets/images/png/alber-inline-logo.png';
  final List<String> periodicityOptions = const [
    'once',
    'monthly',
  ];

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
    final langCode = sl<CacheHelper>().getCachedLanguage();
    try {
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

  void loadCachedProfile() {
    final raw = sl<CacheHelper>().getDataString(key: AppConstants.userProfile);
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final data = decoded['data'] as Map<String, dynamic>? ?? {};
      final userJson = data['user'] as Map<String, dynamic>? ?? {};
      cachedProfile = CachedProfile.fromJson(userJson);
    } catch (e) {
      PrintUtil.error('Failed to parse cached profile: $e');
    }
  }

  void updateCachedProfileFromJson(Map<String, dynamic> userJson) {
    cachedProfile = CachedProfile.fromJson(userJson);
    _persistCachedProfile();
  }

  void updateCachedProfileValues({
    String? name,
    String? email,
    String? phone,
    String? memberId,
    String? avatarPath,
  }) {
    if (cachedProfile == null) {
      cachedProfile = CachedProfile(
        id: DateTime.now().millisecondsSinceEpoch,
        name: name ?? '',
        email: email,
        phone: phone,
        membershipId: memberId,
        avatar: avatarPath,
        displayname: name ?? '',
      );
    } else {
      cachedProfile = cachedProfile!.copyWith(
        id: cachedProfile!.id,
        name: name,
        email: email,
        phone: phone,
        membershipId: memberId,
        avatar: avatarPath,
      );
    }
    _persistCachedProfile();
  }

  void clearCachedProfile() {
    cachedProfile = null;
  }

  Future<void> refreshProfile() async {
    final token = sl<CacheHelper>().getDataString(key: AppConstants.token);
    if (token == null || token.isEmpty) return;
    final repo = sl<ProfileRepo>();
    final result = await repo.getProfile();
    result.fold(
      (err) => PrintUtil.error('Failed to refresh profile: $err'),
      (contact) {
        updateCachedProfileFromJson(contact.data.user.toJson());
      },
    );
  }

  void _persistCachedProfile() {
    if (cachedProfile == null) return;
    final payload = {
      'data': {'user': cachedProfile!.toJson()}
    };
    sl<CacheHelper>().setData(AppConstants.userProfile, jsonEncode(payload));
  }
}

class CachedProfile {
  final int id;
  final String name;
  final String displayname;
  final String? email;
  final String? phone;
  final String? membershipId;
  final String? avatar;

  const CachedProfile({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.membershipId,
    this.avatar,
    required this.displayname,
  });

  CachedProfile copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? membershipId,
    String? avatar,
    String? displayname,
  }) {
    return CachedProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      membershipId: membershipId ?? this.membershipId,
      avatar: avatar ?? this.avatar,
      displayname: displayname ?? this.displayname,
    );
  }

  factory CachedProfile.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['userId'];
    final parsedId = rawId is num
        ? rawId.toInt()
        : rawId is String
            ? rawId.hashCode
            : 0;
    return CachedProfile(
      id: parsedId,
      name: json['name']?.toString() ?? '',
      displayname:
          json['displayName']?.toString() ?? json['name']?.toString() ?? '',
      email: json['email']?.toString(),
      phone: json['mobile']?.toString() ?? json['phone']?.toString(),
      membershipId:
          json['member_id']?.toString() ?? json['userId']?.toString() ?? '',
      avatar: json['image_url']?.toString() ?? json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'mobile': phone,
        'member_id': membershipId,
        'image_url': avatar,
        'userId': membershipId,
        'displayName': displayname,
      };
}
