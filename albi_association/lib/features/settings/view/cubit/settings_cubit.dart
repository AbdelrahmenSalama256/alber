import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/services/pusher_service.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:qafeel/features/settings/data/models/settings_model.dart';
import 'package:qafeel/features/settings/data/repo/settings_repo.dart';
import 'package:qafeel/core/cubit/global_cubit.dart';
import 'package:qafeel/core/network/local_network.dart';

import 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  final _repo = sl<SettingsRepo>();
  PusherService? _pusher;
  StreamSubscription? _sub;
  SettingsModel? last;

  Future<void> init({required int branchId}) async {
    await fetch(branchId: branchId);
    await _listenPusher(branchId: branchId);
  }

  Future<void> fetch({required int branchId, bool fromPush = false}) async {
    if (!fromPush) emit(SettingsLoading());
    final res = await _repo.fetchSettings(branchId: branchId);
    res.fold(
      (l) => emit(SettingsError(l)),
      (r) {
        last = r;
        // Apply default language from settings once available
        final settingsLang = r.defaultLanguage ?? (r.donateNow?.isNotEmpty == true ? r.donateNow!.first.code : null);
        if (settingsLang != null && settingsLang.isNotEmpty) {
          final cached = sl<CacheHelper>().getCachedLanguage();
          if (cached != settingsLang) {
            sl<GlobalCubit>().setLanguage(settingsLang);
          }
        }
        emit(SettingsLoaded(data: r, fromPush: fromPush));
      },
    );
  }

  Future<void> _listenPusher({required int branchId}) async {
    _pusher ??= PusherService(
      key: AppConstants.pusherKey,
      cluster: AppConstants.pusherCluster,
    );
    try {
      await _pusher!.subscribe('settings', (event) {
        fetch(branchId: branchId, fromPush: true);
      }, eventName: 'settings.updated');
    } catch (_) {}
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
