import 'package:nearpay_flutter_sdk/nearpay.dart';

class NearPayHandler {
  static NearPayHandler? _instance;

  NearPayHandler._();
  static NearPayHandler get instance => _instance ??= NearPayHandler._();

  String _authValue = "emad.it@albir.org.sa";
  String get authValue => _authValue;

  AuthenticationType _authType = AuthenticationType.email;
  AuthenticationType get authType => _authType;

  set setAuthTypeNear(String value) {
    if (value == "email") {
      _authType = AuthenticationType.email;
    } else if (value == "mobile") {
      _authType = AuthenticationType.mobile;
    } else if (value == "jwt") {
      _authType = AuthenticationType.jwt;
    }
  }

  Environments _env = Environments.sandbox;
  Environments get env => _env;

  set setEnvType(String value) {
    if (value == "sandbox") {
      _env = Environments.sandbox;
    } else if (value == "production") {
      _env = Environments.production;
    }
  }

  int _timeOut = 5;
  int get timeOut => _timeOut;

  bool _enableReceiptUi = false;
  bool get enableReceiptUi => _enableReceiptUi;

  void init({
    bool? enableReceiptUi,
    String? env,
    String? authType,
    String? authValue,
    int? timeOut,
  }) {
    _enableReceiptUi = enableReceiptUi ?? _enableReceiptUi;
    _authValue = authValue ?? _authValue;
    _timeOut = timeOut ?? _timeOut;
    if (env != null) setEnvType = env;
    if (authType != null) setAuthTypeNear = authType;
  }

  @override
  String toString() {
    return "NearPayHandler(enableReceiptUi: $enableReceiptUi, authType: $authType, authValue: $authValue, timeOut: $timeOut, env: $env)";
  }
}
