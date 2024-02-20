import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_management/task_management/model/task_managemant_model.dart';

sealed class Result<S, E extends Exception> {
  const Result();
}

final class Success<S, E extends Exception> extends Result<S, E> {
  const Success(this.value);
  final S value;
}

final class Failure<S, E extends Exception> extends Result<S, E> {
  const Failure(this.exception);
  final E exception;
}

class TaskManagementRepository {
  TaskManagementRepository({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;
  static const _baseUrl = 'todo-list-api-mfchjooefq-as.a.run.app';

  Future<Result<TaskManagement, Exception>> getTaskManagement(
      {required int page, required String status}) async {
    try {
      final taskManagementRequest = Uri.https(_baseUrl, 'todo-list', {
        'offset': page.toString(),
        'limit': '10',
        'sortBy': 'createdAt',
        'isAsc': 'true',
        'status': status,
      });

      final taskManagementResponse =
          await _httpClient.get(taskManagementRequest);
      switch (taskManagementResponse.statusCode) {
        case 200:
          final data = json.decode(taskManagementResponse.body);
          return Success(TaskManagement.fromJson(data));
        default:
          return Failure(Exception(taskManagementResponse.reasonPhrase));
      }
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
