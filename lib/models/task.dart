import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@JsonSerializable()
@immutable
class Task {
  final int id;
  final String title;
  final String description;
  @JsonKey(name: "isCompleted", fromJson: _intToBool, toJson: _boolToInt)
  final bool isCompleted;
  final int? date;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.date,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  static bool _intToBool(int bit) => bit == 1;
  static int _boolToInt(bool value) => value ? 1 : 0;

  Task copyWith({
    int? id,
    String? title,
    String? description,
    bool? isCompleted,
    int? date,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
    );
  }
}
