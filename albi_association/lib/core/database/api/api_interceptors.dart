import 'package:qafeel/core/constants/app_constant.dart';
import 'package:qafeel/core/database/api/end_points.dart';
import 'package:qafeel/core/network/local_network.dart';
import 'package:qafeel/core/services/service_locator.dart';
import 'package:dio/dio.dart';

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    String? token = sl<CacheHelper>().getDataString(key: ApiKey.token);
    String? cookie = sl<CacheHelper>().getDataString(key: AppConstants.cookie);

    if (token != null && token.isNotEmpty) {
      options.headers[ApiKey.authorization] = 'Bearer $token';
    } else {
      options.headers.remove(ApiKey.authorization);
    }

    options.headers["Cookie"] = "maxliss_session=$cookie";
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.realUri.toString().contains(EndPoints.login)) {
      RegExp regex = RegExp(r'maxliss_session=([^;]*)');
      Match? match =
          regex.firstMatch(response.headers["Set-Cookie"].toString());

      String? sessionValue = match?.group(1);
      sl<CacheHelper>().setData(AppConstants.cookie, sessionValue ?? "");
    }
    super.onResponse(response, handler);
  }
}
