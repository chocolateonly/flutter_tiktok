import 'package:dio/dio.dart';
// 引入请求的公共配置，例如 baseUrl等
import 'GlobalConfig.dart';
// 引入本地缓存插件，用来获取本地缓存中的用户信息
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';

// 封装 dio 请求类
class Http{
  // dio 的 options 配置
  static BaseOptions _options = new BaseOptions(
    baseUrl: baseUrl,        // 请求的baseUrl
    connectTimeout: 10000,    // 连接超时时间
    receiveTimeout: 15000,    // 响应超时时间
    contentType: contentType['form'],
  );

  // get 请求
  static get( url, { pathParams, params, needCode = false ,cancelToken })async{
    return await request( url , pathParams, params, 'GET', null, needCode, cancelToken );
  }
  // post 请求
  static post( url, { pathParams, params, needCode = false ,cancelToken })async{
    return await request( url , pathParams, params, 'POST', null, needCode, cancelToken );
  }
  // put 请求
  static put( url, { pathParams, params, needCode = false ,cancelToken })async{
    return await request( url , pathParams, params, 'PUT', null, needCode, cancelToken );
  }
  // delete 请求
  static delete( urlName, { pathParams, params, needCode = false ,cancelToken })async{
    return await request( urlName , pathParams, params, 'DELETE', null, needCode, cancelToken );
  }

  /*
        * @description: 封装请求
        * @param {type}
        * url          请求主路径连接
        * pathParams   连接请求参数类型为：https://test_api.com/user/:id/:name
        * params       请求参数在 body 中，或者为：https://test_api.com/user?id=123&name=zhangsan
        * method       请求方法
        * header       请求头重置
        * needCode     是否需要状态码
        * @return {type}   返回响应数据
        */
  static request(urlName, pathParams, params, method, header, needCode, cancelToken ) async{
    // 处理URL ，通过 urlName 在 urlPath 中匹配相应的 url 路径地址
    String url = urlName;

    // get请求处理
    if(pathParams != null) {
      // 处理  https://test_api.com/user/:id/:name => https://test_api.com/user/123/zhangsan  请求连接
      pathParams.forEach((key, value) {
        if(url.indexOf(key) != -1) {
          url = url.replaceAll(":$key", value.toString());
        }
      });
    }else if( pathParams == null && method=='GET'){
      // 处理 https://test_api.com/user?id=123&name=zhangsan 请求连接
      url += '?';
      params.forEach((key, value) {
        url += '$key=$value&';
      });
    }
    // 读取本地缓存中的数据
    dynamic sp = await SharedPreferences.getInstance();
    Map headers = {};
    // 存储 请求头 参数
    if( header != null ){
      headers.addAll(header);
    }
    //  授权信息 Authorization / token
    if( sp.get('token') == null &&  sp.get('Authorization') == null ){
      // 处理授权信息不存在的逻辑，即 重新登录 或者 获取授权信息
    }else{
      // 获取授权信息（ token、Authorization 一般出现一个或者两都存在）
      if( sp.get('token') != null ){
        headers['token'] = sp.get('token');
      }
      if( sp.get('Authorization') != null ){
        headers['Authorization'] = sp.get('Authorization');
      }
    }

    // 设置请求头
    _options.headers = new Map<String, dynamic>.from(headers);

    // 初始化 Dio
    Dio _dio = new Dio(_options);

    // 请求拦击
    _dio.interceptors.add( InterceptorsWrapper(
        onRequest:(options, handler){
          // Do something before request is sent
          return handler.next(options); //continue
          // If you want to resolve the request with some custom data，
          // you can resolve a `Response` object eg: return `dio.resolve(response)`.
          // If you want to reject the request with a error message,
          // you can reject a `DioError` object eg: return `dio.reject(dioError)`
        },
        onResponse:(response,handler) {
          print('---api-response--->resp----->${response.data}');
          // Do something with response data
          return handler.next(response); // continue
          // If you want to reject the request with a error message,
          // you can reject a `DioError` object eg: return `dio.reject(dioError)`
        },
        onError: (DioError e, handler) {
          // Do something with response error
          return  handler.next(e);//continue
          // If you want to resolve the request with some custom data，
          // you can resolve a `Response` object eg: return `dio.resolve(response)`.
        }
    ));

    Response? response;
    // dio 请求处理
    try{
      response = await _dio.request(url, data:params, options:  Options(method:method), cancelToken: cancelToken);
    } on DioError catch(e){
      print(e);
      // 请求错误处理  ,错误码 e.response.statusCode
      print('请求错误处理： ${e.response!.statusCode}');

      handleHttpError(e.response!.statusCode!);
      if(CancelToken.isCancel(e)){
        print('请求取消! ' + e.message);
      }else{
        // 请求发生错误处理
        if( e.type == DioErrorType.connectTimeout ){
          print('连接超时');
        }
      }
    }

    // 对相应code的处理
    if( response == null ){
      print('响应错误');
    }else if( needCode ){
      // 需要返回code
      return response.data;
    }else if( !needCode ){
      // 不需要返回 code ，统一处理不同 code 的情况
      if(response.data!=''&&response.data!=null){
        // 可对其他不同值的 code 做额外处理
        print('aaaa');
        print(response.data);
        return response.data;
      }else{
        print('其他数据类型处理');
        return response;
      }
    }
  }

  /*
        * @description: 处理Http错误码
        * @param {type} 错误码
        * @return {type}
        */
  static handleHttpError(int errorCode) {
    print('http错误码： $errorCode');
  }
}