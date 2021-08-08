// http_config.dart 文件中主要配置请求相关的一些公共配置

// 请求服务器地址
const String baseUrl =  'https://taiwan.dev.hbbeisheng.com';

// 请求连接
const Map urlPath = {
  'sms': 'login/sms',
};

// content-type
const Map contentType = {
  'json': "application/json",
  'form': "application/x-www-form-urlencoded"
};