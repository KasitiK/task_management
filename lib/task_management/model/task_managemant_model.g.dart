// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_managemant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskManagement _$TaskManagementFromJson(Map<String, dynamic> json) =>
    TaskManagement(
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageNumber: json['pageNumber'] as int,
      totalPages: json['totalPages'] as int,
    );

Map<String, dynamic> _$TaskManagementToJson(TaskManagement instance) =>
    <String, dynamic>{
      'tasks': instance.tasks,
      'pageNumber': instance.pageNumber,
      'totalPages': instance.totalPages,
    };

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'status': instance.status,
    };
