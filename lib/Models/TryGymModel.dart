
import 'dart:convert';

TryGymModel tryGymModelFromJson(String str) => TryGymModel.fromJson(json.decode(str));


class TryGymModel {
  List<Exercise> exercises;

  TryGymModel({
    required this.exercises,
  });

  factory TryGymModel.fromJson(Map<String, dynamic> json) => TryGymModel(
    exercises: List<Exercise>.from(json["exercises"].map((x) => Exercise.fromJson(x))),
  );

}

class Exercise {
  String id;
  String title;
  String thumbnail;
  String gif;
  String seconds;

  Exercise({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.gif,
    required this.seconds,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
    id: json["id"],
    title: json["title"],
    thumbnail: json["thumbnail"],
    gif: json["gif"],
    seconds: json["seconds"],
  );

}
