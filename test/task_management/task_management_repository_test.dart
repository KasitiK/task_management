import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:task_management/task_management/model/task_managemant_model.dart';
import 'package:task_management/task_management/repository/task_management_repository.dart';

import 'task_management_cubit_test.dart';

void main() {
  group('TaskManagementRepository', () {
    test('correct request', () async {
      final taskManagementRepository =
          TaskManagementRepository(httpClient: MockClient((request) async {
        return Response(jsonEncode(mockTodoResponse), 200);
      }));
      final item = await taskManagementRepository.getTaskManagement(
          page: 0, status: 'TODO');
      expect(item, isA<Success<TaskManagement, Exception>>());
    });

    test('invaild request', () async {
      final taskManagementRepository =
          TaskManagementRepository(httpClient: MockClient((request) async {
        request.url.queryParameters['limi'] = '10';
        return Response('Bad Request', 400);
      }));
      final item = await taskManagementRepository.getTaskManagement(
          page: 0, status: 'todo');
      expect(item, isA<Failure<TaskManagement, Exception>>());
    });
  });
}
