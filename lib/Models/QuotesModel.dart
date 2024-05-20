class QuotesModel {
  String content;
  String author;

  QuotesModel({
    required this.content,
    required this.author,

  });

  factory QuotesModel.fromJson(Map<String, dynamic> json) => QuotesModel(
    content: json["content"],
    author: json["author"],

  );

}