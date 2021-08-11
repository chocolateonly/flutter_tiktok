/// folder : "11"
/// block : ["30f384792bd77f886909cb620c8ffe5038950d9186522d7725d0dde8f54392f3","efc4afebf40fe80b26c8c7becf550b65ca52ccafefbcc99edd84bf195748a248",14,"2021-08-11 05:02:58",{"timestamp":1628658178.693,"type":"folder","name":"11","meta_hash":""}]

class Add {
  String _folder='';
  List<String> _block=[];

  String get folder => _folder;
  List<String> get block => _block;

  Add({
      required String folder,
      required List<String> block}){
    _folder = folder;
    _block = block;
}

  Add.fromJson(dynamic json) {
    _folder = json["folder"];
    _block = json["block"] != null ? json["block"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["folder"] = _folder;
    map["block"] = _block;
    return map;
  }

}