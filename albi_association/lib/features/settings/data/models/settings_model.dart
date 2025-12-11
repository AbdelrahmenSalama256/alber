import '../../../../core/constants/widgets/print_util.dart';
import '../../../payments/data/services/nearpay_handler.dart';

String clearHtmlTags(String? text) {
  if (text == null) return '';
  final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false);
  return text.replaceAll(regex, '').replaceAll('&nbsp;', ' ').trim();
}

class LocalizedLabel {
  final String? title;
  final String? code;
  LocalizedLabel({this.title, this.code});
  factory LocalizedLabel.fromJson(Map<String, dynamic> json) => LocalizedLabel(
      title: json['title']?.toString(), code: json['code']?.toString());
}

class NearpayConfig {
  final bool? enableReceiptUi;
  final String? finishTimeout;
  final String? authType;
  final String? authValue;
  final String? env;

  NearpayConfig({
    this.enableReceiptUi,
    this.finishTimeout,
    this.authType,
    this.authValue,
    this.env,
  });

  factory NearpayConfig.fromJson(Map<String, dynamic> json) {
    PrintUtil.warning('📋 Parsing NearPay Config: $json');

    return NearpayConfig(
      enableReceiptUi: _toBool(json['enableReceiptUi']),
      finishTimeout: json['finishTimeout']?.toString(),
      authType: json['authType']?.toString(),
      authValue: json['authValue']?.toString(),
      env: json['env']?.toString(),
    );
  }

  bool get isValid {
    return authType != null &&
        authValue != null &&
        authValue!.isNotEmpty &&
        env != null;
  }

  @override
  String toString() {
    return 'NearpayConfig(authType: $authType, authValue: ${authValue != null ? '***' : 'null'}, env: $env, enableReceiptUi: $enableReceiptUi, finishTimeout: $finishTimeout)';
  }
}

class SettingsModel {
  final String? phone;
  final String? email;
  final String? address;
  final String? addressOnTheMap;
  final String? facebook;
  final String? twitter;
  final String? instagram;
  final String? snapchat;
  final String? whatsappNumber;
  final String? whatsappLink;
  final String? youtube;
  final String? logo;
  final String? name;
  final String? description;
  final String? aboutApp;
  final String? appname;
  final String? keywords;
  final String? debugMode;
  final Map<String, String>? languages;
  final List<LocalizedLabel>? donateNow;
  final String? defaultLanguage;
  final String? aboutAppHead;
  final String? aboutAppFoot;
  final String? paymentGateWay;
  final bool? isRefresh;
  final int? refreshTime;
  final bool? pinnedMode;
  final bool? quickDonations;
  final bool? autoStart;
  final int? unpinnedModeTime;
  final bool? kioskMode;
  final int? returnTimeout;
  final int? usingSections;
  final int? showInvoiceAfterSuccess;
  final NearpayConfig? nearpay;

  SettingsModel({
    this.phone,
    this.email,
    this.address,
    this.addressOnTheMap,
    this.facebook,
    this.twitter,
    this.instagram,
    this.snapchat,
    this.whatsappNumber,
    this.whatsappLink,
    this.youtube,
    this.logo,
    this.name,
    this.description,
    this.aboutApp,
    this.appname,
    this.keywords,
    this.debugMode,
    this.languages,
    this.donateNow,
    this.defaultLanguage,
    this.aboutAppHead,
    this.aboutAppFoot,
    this.paymentGateWay,
    this.isRefresh,
    this.refreshTime,
    this.pinnedMode,
    this.quickDonations,
    this.autoStart,
    this.unpinnedModeTime,
    this.kioskMode,
    this.returnTimeout,
    this.usingSections,
    this.showInvoiceAfterSuccess,
    this.nearpay,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    Map<String, String>? langs;
    if (json['languages'] is Map) {
      langs = (json['languages'] as Map)
          .map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    final donate = (json['donate_now'] as List?)
            ?.whereType<Map<String, dynamic>>()
            .map((e) => LocalizedLabel.fromJson(e))
            .toList() ??
        [];
    return SettingsModel(
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      address: json['address']?.toString(),
      addressOnTheMap: json['address_on_the_map']?.toString(),
      facebook: json['facebook']?.toString(),
      twitter: json['twitter']?.toString(),
      instagram: json['instagram']?.toString(),
      snapchat: json['snapchat']?.toString(),
      whatsappNumber: json['whatsapp_number']?.toString(),
      whatsappLink: json['whatsapp_link']?.toString(),
      youtube: json['youtube']?.toString(),
      logo: json['logo']?.toString(),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      aboutApp: json['aboutApp']?.toString(),
      appname: json['appname']?.toString(),
      keywords: json['keywords']?.toString(),
      debugMode: json['debugMode']?.toString(),
      languages: langs,
      donateNow: donate,
      defaultLanguage: json['default_langugae']?.toString(),
      aboutAppHead: clearHtmlTags(json['aboutAppHead']?.toString()),
      aboutAppFoot: clearHtmlTags(json['aboutAppFoot']?.toString()),
      paymentGateWay: json['paymentGateWay']?.toString() ?? 'nearpay',
      isRefresh: _toBool(json['is_refresh']),
      refreshTime: _toInt(json['refresh_time']),
      pinnedMode: _toBool(json['pinned_mode']),
      quickDonations: _toBool(json['quick_donations']),
      autoStart: _toBool(json['auto_start']),
      unpinnedModeTime: _toInt(json['unpinned_mode_time']),
      kioskMode: _toBool(json['kiosk_mode']),
      returnTimeout: _toInt(json['return_timeout']),
      usingSections: _toInt(json['using_sections']),
      showInvoiceAfterSuccess: _toInt(json['show_invoice_after_success']),
      nearpay: _parseNearpayConfig(json['nearpay']),
    );
  }
  static NearpayConfig? _parseNearpayConfig(dynamic nearpayData) {
    if (nearpayData == null) return null;
    if (nearpayData is Map<String, dynamic>) {
      return NearpayConfig.fromJson(nearpayData);
    }
    return null;
  }

  void initializeNearPay() {
    if (nearpay != null) {
      final handler = NearPayHandler.instance;
      handler.init(
        enableReceiptUi: nearpay!.enableReceiptUi,
        env: nearpay!.env,
        authType: nearpay!.authType,
        authValue: nearpay!.authValue,
        timeOut: nearpay!.finishTimeout != null
            ? int.tryParse(nearpay!.finishTimeout!)
            : null,
      );
      PrintUtil.success('⚙️ NearPay Handler Initialized: $handler');
    }
  }
}

int? _toInt(dynamic v) {
  if (v is int) return v;
  if (v is double) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

bool? _toBool(dynamic v) {
  if (v is bool) return v;
  if (v is String) {
    final s = v.toLowerCase();
    if (s == 'true' || s == 'yes' || s == '1') return true;
    if (s == 'false' || s == 'no' || s == '0') return false;
  }
  if (v is num) return v != 0;
  return null;
}
