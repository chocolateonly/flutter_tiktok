// http_config.dart 文件中主要配置请求相关的一些公共配置

// 请求服务器地址

//const String baseUrl =  'http://192.168.3.10:8080';
const String baseUrl =  'http://192.168.0.243:8888';

// 请求连接
const Map urlPath = {
  'sms': 'login/sms',
};

// content-type
const Map contentType = {
  'json': "application/json",
  'form': "application/x-www-form-urlencoded"
};