/// code : 10070
/// message : "上傳成功"
/// data : {"path":"upload/common/chat/video/20210801/20210801020355162779783599542.mp4"}
/// timestamp : 1627797835

class File {
  int _code=200;
  String _message='';
  Data _data=Data();
  int _timestamp=0;

  int get code => _code;
  String get message => _message;
  Data get data => _data;
  int get timestamp => _timestamp;

  File({
      required int code,
      required String message,
      required Data data,
      required int timestamp}){
    _code = code;
    _message = message;
    _data = data;
    _timestamp = timestamp;
}

  File.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
    _data = (json["data"] != null ? Data.fromJson(json["data"]) : null)!;
    _timestamp = json["timestamp"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data.toJson();
    }
    map["timestamp"] = _timestamp;
    return map;
  }

}

/// path : "upload/common/chat/video/20210801/20210801020355162779783599542.mp4"

class Data {
  String? _path;

  String get path => _path??'';

  Data({
       String? path}){
    _path = path;
}

  Data.fromJson(dynamic json) {
    _path = json["path"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["path"] = _path;
    return map;
  }

}