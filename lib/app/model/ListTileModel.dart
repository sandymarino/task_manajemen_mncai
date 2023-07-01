class ListTileModel {
  int? index;
  bool? enabled;
  String? text;

  ListTileModel(this.index, this.enabled,this.text);

  ListTileModel.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    enabled = json['check'];
    text = json['text'];
  }
}