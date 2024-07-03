import 'dart:io';

import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/io.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'path.dart';

/// dio http 请求库缓存时间
const kHttpCacheTime = Duration(hours: 2);

/// 默认所有的 `dio-http` 请求都持久化话([kHttpCacheTime])
///
/// 此扩展可以修改 `options` 控制缓存行为
///
/// 参考: https://pub.dev/packages/dio_cache_interceptor
///
/// ```dart
/// var resp = await XHttp.dio.get(
///  fetchMirrorAPI,
///  options: $toDioOptions(CachePolicy.noCache),
/// );
///```
extension AnyInjectHttpCacheOptions on Object {
  Options $toDioOptions([CachePolicy? cachePolicy]) {
    var options = kHttpCacheMiddlewareOptions
        .copyWith(policy: CachePolicy.noCache)
        .toOptions();
    return options;
  }
}

var kHttpCacheMiddlewareOptions = CacheOptions(
  store: MemCacheStore(),
  policy: CachePolicy.forceCache,
  hitCacheOnErrorExcept: [401, 403],
  maxStale: kHttpCacheTime,
  priority: CachePriority.normal,
  cipher: null,
  keyBuilder: CacheOptions.defaultCacheKeyBuilder,
  allowPostMethod: true,
);

class XHttp {
  XHttp._internal();

  /// 网络请求配置
  static final Dio dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 13),
  ));

  static changeTimeout({
    int connectTimeout = 15,
    int receiveTimeout = 13,
  }) {
    dio.options.connectTimeout = Duration(seconds: connectTimeout);
    dio.options.receiveTimeout = Duration(seconds: receiveTimeout);
  }

  /// 初始化dio
  static Future<void> init() async {
    /// 初始化cookie
    var value = await PathUtils.getDocumentsDirPath();
    var cookieJar = PersistCookieJar(
      storage: FileStorage("$value/.cookies/"),
    );
    dio.interceptors.add(CookieManager(cookieJar));

    dio.interceptors
        .add(DioCacheInterceptor(options: kHttpCacheMiddlewareOptions));

    // ignore: dead_code
    if (false) {
      dio.interceptors.add(
        AwesomeDioInterceptor(
          logRequestTimeout: false,
          logRequestHeaders: false,
          logResponseHeaders: false,
          logger: debugPrint,
        ),
      );
    }

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );
  }

  static Future<T> get<T>(String url, [Map<String, dynamic>? params]) async {
    Response response;
    if (params != null) {
      response = await dio.get<T>(url, queryParameters: params);
    } else {
      response = await dio.get<T>(url);
    }
    return response.data;
  }

  static Future<T> post<T>(String url, [Map<String, dynamic>? params]) async {
    Response response = await dio.post<T>(url, queryParameters: params);
    return response.data;
  }

  static Future<T> postWithBody<T>(String url,
      [Map<String, dynamic>? data]) async {
    Response response = await dio.post<T>(url, data: data);
    return response.data;
  }
}
