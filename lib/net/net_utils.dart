import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:love_chat/providers/userManager.dart';
import 'error_handle.dart';
import 'net_base_entity.dart';
import 'package:love_chat/entity_factory.dart';

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

class NetUtils {
  static final NetUtils _instance = NetUtils._internal();

  static NetUtils get instance => NetUtils();

  factory NetUtils() {
    return _instance;
  }

  static Dio _dio;

  Dio getDio() {
    return _dio;
  }

  NetUtils._internal() {
    var options = BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 15000,
      responseType: ResponseType.json,
      validateStatus: (status) {
        // 不使用http状态码判断状态，使用AdapterInterceptor来处理（适用于标准REST风格）
        return true;
      },
      baseUrl: baseUrl,
//      contentType: ContentType('application', 'x-www-form-urlencoded', charset: 'utf-8'),
    );
    _dio = Dio(options);

    /// 统一添加身份验证请求头
    _dio.interceptors.add(AuthInterceptor());

    /// 打印Log
    // _dio.interceptors.add(LoggingInterceptor());
  }

  // 数据返回格式统一，统一处理异常
  Future<NetBaseEntity<T>> _request<T>(String method, String url,
      {Map<String, dynamic> data,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options}) async {
    var response = await _dio.request(url,
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
        _data = EntityFactory.generateOBJ(_map['data']);
      }
    } catch (e) {
      print(e);
      return NetBaseEntity(ExceptionHandle.parse_error, '数据解析错误', _data);
    }
    return NetBaseEntity(_code, _msg, _data);
  }

  Future<NetBaseEntity<List<T>>> _requestList<T>(String method, String url,
      {Map<String, dynamic> data,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options}) async {
    var response = await _dio.request(url,
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
    return NetBaseEntity(_code, _msg, _data);
  }

  Options _checkOptions(method, options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    return options;
  }

// public
  Future<NetBaseEntity<T>> request<T>(Method method, String url,
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
      Error error = ExceptionHandle.handleException(e);
      return Future.value(NetBaseEntity(error.code, error.message, null));
    }
  }

  Future<NetBaseEntity<List<T>>> requestList<T>(Method method, String url,
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
      Error error = ExceptionHandle.handleException(e);
      return Future.value(NetBaseEntity(error.code, error.message, []));
    }
  }

  /// 统一处理(onSuccess返回T对象，onSuccessList返回List<T>)
  requestNetwork<T>(Method method, String url,
      {Function(T t) onSuccess,
      Function(List<T> list) onSuccessList,
      Function(int code, String mag) onError,
      Map<String, dynamic> params,
      Map<String, dynamic> queryParameters,
      CancelToken cancelToken,
      Options options,
      bool isList: false}) {
    String m = _getRequestMethod(method);

    Future<NetBaseEntity> requestFuture = isList
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

    requestFuture.then((result) {
      if (result.code == 200) {
        isList ? onSuccessList(result.data) : onSuccess(result.data);
      } else {
        onError == null
            ? _onError(result.code, result.message)
            : onError(result.code, result.message);
      }
    }).catchError((e) {
      if (e is DioError && CancelToken.isCancel(e)) {
        log('取消请求接口: $url');
      }
      Error error = ExceptionHandle.handleException(e);
      onError == null
          ? _onError(error.code, error.message)
          : onError(error.code, error.message);
    });
  }

  _onError(int code, String mag) {
    log('接口请求异常： code: $code, mag: $mag');
    // Toast.show(mag);
  }

  String _getRequestMethod(Method method) {
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
