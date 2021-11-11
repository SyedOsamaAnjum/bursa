class GetArticles {
  int id;
  String name;
  String text;
  int userId;

  GetArticles({this.id, this.name, this.text, this.userId});

  GetArticles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    text = json['text'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['text'] = this.text;
    data['userId'] = this.userId;
    return data;
  }
}