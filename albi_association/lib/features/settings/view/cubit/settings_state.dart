import 'package:qafeel/features/settings/data/models/settings_model.dart';

abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final SettingsModel data;
  final bool fromPush;
  SettingsLoaded({required this.data, this.fromPush = false});
}

class SettingsError extends SettingsState {
  final String message;
  SettingsError(this.message);
}

