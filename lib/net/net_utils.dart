import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:love_chat/providers/userManager.dart';
import 'error_handle.dart';
import 'net_base_entity.dart';
import 'package:love_chat/entity_factory.dart';
import 'package:love_chat/providers/userManager.dart';

enum Method {
  get,
  post,
  put,
  patch,
  delete,
}

final String accessToken = UserManager().accessToken;

final String baseUrl = 'http://localhost:3000';

// 打日志
void log(String msg) {
  print(msg);
}

BaseOptions baseOptions = BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: 50000,
  receiveTimeout: 30000,
  responseType: ResponseType.json,
  validateStatus: (status) {
    // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
    return true;
  },
);
Dio dio = Dio(baseOptions);

class NetUtils {

  // 数据返回格式统一，统一处理异常
  static Future<NetBaseEntity<T>> _request<T>(String method, String url,
      {Map<String, dynamic> data,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options}) async {
    var response = await dio.request(url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);

    int _code;
    String _msg;
    T _data;

    try {
      Map<String, dynamic> _map = response.data;
      _code = _map['code'];
      _msg = _map['message'];
      if (_map.containsKey('data')) {
        _data = EntityFactory.generateOBJ<T>(_map['data']);
      }
    } catch (e) {
      print(e);
      return NetBaseEntity(ExceptionHandle.parse_error, '数据解析错误', _data);
    }
    var result = NetBaseEntity<T>(_code, _msg, _data);
    return result;
  }

  static Future<NetBaseEntity<List<T>>> _requestList<T>(String method, String url,
      {Map<String, dynamic> data,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options}) async {
    var response = await dio.request(url,
        data: data,
        queryParameters: queryParameters,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);
    int _code;
    String _msg;
    List<T> _data = [];

    try {
      Map<String, dynamic> _map = response.data;
      _code = _map['code'];
      _msg = _map['message'];
      if (_map.containsKey('data')) {
        ///  List类型处理，暂不考虑Map
        (_map['data'] as List).forEach((item) {
          _data.add(EntityFactory.generateOBJ<T>(item));
        });
      }
    } catch (e) {
      print(e);
      return NetBaseEntity(ExceptionHandle.parse_error, '数据解析错误', _data);
    }
    return NetBaseEntity<List<T>>(_code, _msg, _data);
  }

  static Options _checkOptions(method, options) {
    if (options == null) {
      options = Options(headers: {'Authorization': 'Bearer ${UserManager().accessToken}'});
    }
    options.method = method;
    return options;
  }

// public
  static Future<NetBaseEntity<T>> request<T>(Method method, String url,
      {Map<String, dynamic> params,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options}) async {
    try {
      String m = _getRequestMethod(method);
      return await _request<T>(m, url,
          data: params,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken);
    } catch (e) {
      if (e is DioError && CancelToken.isCancel(e)) {
        log('取消请求接口： $url');
      }
      NetBaseEntity error = ExceptionHandle.handleException(e);
      return Future.value(NetBaseEntity(error.code, error.message, null));
    }
  }

  static Future<NetBaseEntity<List<T>>> requestList<T>(Method method, String url,
      {Map<String, dynamic> params,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options}) async {
    try {
      String m = _getRequestMethod(method);
      return await _requestList<T>(m, url,
          data: params,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken);
    } catch (e) {
      if (e is DioError && CancelToken.isCancel(e)) {
        log('取消请求接口： $url');
      }
      NetBaseEntity error = ExceptionHandle.handleException(e);
      return Future.value(NetBaseEntity(error.code, error.message, []));
    }
  }

  /// 统一处理(onSuccess返回T对象，onSuccessList返回List<T>)
  static Future<NetBaseEntity<T>> requestNetwork<T>(Method method, String url,
      {Map<String, dynamic> params,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options,
      bool isList: false}) {
    String m = _getRequestMethod(method);

    Future<NetBaseEntity<T>> requestFuture = isList
        ? _requestList<T>(m, url,
            data: params,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken)
        : _request<T>(m, url,
            data: params,
            queryParameters: queryParameters,
            options: options,
            cancelToken: cancelToken);

    return requestFuture.then((result) {
      return result;
    }).catchError((e) {
      if (e is DioError && CancelToken.isCancel(e)) {
        log('取消请求接口: $url');
      }
      NetBaseEntity error = ExceptionHandle.handleException(e);
      _onError(error.code, error.message);
      throw NetBaseEntity(error.code, error.message, null);
    });
  }

  static _onError(int code, String msg) {
    log('接口请求异常： code: $code, msg: $msg');
  }

  static String _getRequestMethod(Method method) {
    String m;
    switch (method) {
      case Method.get:
        m = 'GET';
        break;
      case Method.post:
        m = 'POST';
        break;
      case Method.put:
        m = 'PUT';
        break;
      case Method.patch:
        m = 'PATCH';
        break;
      case Method.delete:
        m = 'DELETE';
        break;
    }
    return m;
  }
}

class AuthInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) {
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return super.onRequest(options);
  }
}

class LoggingInterceptor extends Interceptor {
  DateTime startTime;
  DateTime endTime;

  @override
  onRequest(RequestOptions options) {
    startTime = DateTime.now();
    log('----------Start----------');
    if (options.queryParameters.isEmpty) {
      log('RequestUrl: ' + options.baseUrl + options.path);
    } else {
      log('RequestUrl: ' +
          options.baseUrl +
          options.path +
          '?' +
          Transformer.urlEncodeMap(options.queryParameters));
    }
    log('RequestMethod: ' + options.method);
    log('RequestHeaders:' + options.headers.toString());
    log('RequestContentType: ${options.contentType}');
    log('RequestData: ${options.data.toString()}');
    return super.onRequest(options);
  }

  @override
  onResponse(Response response) {
    endTime = DateTime.now();
    int duration = endTime.difference(startTime).inMilliseconds;
    if (response.statusCode == ExceptionHandle.success) {
      log('ResponseCode: ${response.statusCode}');
    } else {
      log('ResponseCode: ${response.statusCode}');
    }
    // 输出结果
    log(response.data.toString());
    log('----------End: $duration 毫秒----------');
    return super.onResponse(response);
  }

  @override
  onError(DioError err) {
    log('----------Error-----------');
    return super.onError(err);
  }
}
