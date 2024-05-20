// To parse this JSON data, do
//
//     final movieModel = movieModelFromJson(jsonString);

import 'dart:convert';

MovieModel movieModelFromJson(String str) => MovieModel.fromJson(json.decode(str));

class MovieModel {
  List<Video> videos;

  MovieModel({
    required this.videos,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) => MovieModel(
    videos: List<Video>.from(json["videos"].map((x) => Video.fromJson(x))),
  );

}

class Video {
  String description;
  List<String> sources;
  String subtitle;
  String thumb;
  String title;

  Video({
    required this.description,
    required this.sources,
    required this.subtitle,
    required this.thumb,
    required this.title,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    description: json["description"],
    sources: List<String>.from(json["sources"].map((x) => x)),
    subtitle: json["subtitle"],
    thumb: json["thumb"],
    title: json["title"],
  );

}
