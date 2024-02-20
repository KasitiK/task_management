import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_managemant_model.g.dart';

@JsonSerializable()
class TaskManagement extends Equatable {
  const TaskManagement({
    required this.tasks,
    required this.pageNumber,
    required this.totalPages,
  });

  factory TaskManagement.fromJson(Map<String, dynamic> json) =>
      _$TaskManagementFromJson(json);

  final List<Task> tasks;
  final int pageNumber;
  final int totalPages;

  Map<String, dynamic> toJson() => _$TaskManagementToJson(this);

  @override
  List<Object> get props => [tasks, pageNumber, totalPages];
}

@JsonSerializable()
class Task extends Equatable {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.status,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String status;

  Map<String, dynamic> toJson() => _$TaskToJson(this);

  @override
  List<Object> get props => [id, title, description, createdAt, status];
}
