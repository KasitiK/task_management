import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_management/task_management/cubit/task_management_cubit.dart';
import 'package:task_management/task_management/model/task_managemant_model.dart';
import 'package:task_management/task_management/repository/task_management_repository.dart';

const mockTodoResponse = {
  "tasks": [
    {
      "id": "cbb0732a-c9ab-4855-b66f-786cd41a3cd1",
      "title": "Read a book",
      "description": "Spend an hour reading a book for pleasure",
      "createdAt": "2023-03-24T19:30:00Z",
      "status": "TODO"
    },
    {
      "id": "119a8c45-3f3d-41da-88bb-423c5367b81a",
      "title": "Exercise",
      "description": "Go for a run or do a workout at home",
      "createdAt": "2023-03-25T09:00:00Z",
      "status": "TODO"
    },
  ],
  "pageNumber": 1,
  "totalPages": 3
};

const mockDoingResponse = {
  "tasks": [
    {
      "id": "cbb0732a-c9ab-4855-b66f-786cd41a3cd1",
      "title":
          "Do not go where the path may lead, go instead where there is no path and leave a trail.",
      "description": "Ralph Waldo Emerson",
      "createdAt": "2023-03-25T19:30:00Z",
      "status": "DOING"
    },
    {
      "id": "2e6908c7-bdb1-4bf7-a108-f10bb53c13d9",
      "title": "The best way to predict the future is to invent it.",
      "description": "Alan Kay",
      "createdAt": "2023-04-02T10:30:00Z",
      "status": "DOING"
    },
  ],
  "pageNumber": 1,
  "totalPages": 1
};

const mockDoneResponse = {
  "tasks": [
    {
      "id": "9dd9316f-39d2-4ef1-bfc6-45df0b847881",
      "title": "Levitating - Dua Lipa ft. DaBaby",
      "description":
          "I got you moonlight, you're my starlight / I need you all night, come on, dance with me / I'm levitating / You, moonlight, you're my starlight / I need you all night, come on, dance with me / I'm levitating",
      "createdAt": "2022-04-03T15:34:20.000Z",
      "status": "DONE"
    },
    {
      "id": "42af0e5a-9bfe-49fc-a42d-7175c5b5a5a7",
      "title": "Circles - Post Malone",
      "description":
          "We couldn't turn around / 'Til we were upside down / I'll be the bad guy now / But know I ain't too proud / I couldn't be there / Even when I try / You don't believe it / We do this every time",
      "createdAt": "2022-04-03T15:34:20.000Z",
      "status": "DONE"
    },
  ],
  "pageNumber": 1,
  "totalPages": 1
};

class _MockTaskModel extends Mock implements Task {}

void main() {
  late Task taskA;
  late Task taskB;

  setUp(() {
    taskA = _MockTaskModel();
    taskB = _MockTaskModel();
  });

  group('TaskManagementCubit', () {
    group('TodoCubit', () {
      test('override is correct', () {
        final status = TodoCubit().status;
        expect(status, 'TODO');
      });

      blocTest<TodoCubit, TaskManagementState>(
        'emits [TaskManagementInitial] when status is initial',
        build: () => TodoCubit(),
        expect: () => [],
      );

      blocTest<TodoCubit, TaskManagementState>(
        'emit [TaskManagementLoading, TaskManagementLoaded] when can fetch data from api',
        seed: () => TaskManagementInitial(),
        build: () {
          return TodoCubit(
            taskManagementRepository: TaskManagementRepository(
              httpClient: MockClient(
                (request) async {
                  expect(request.url.queryParameters['status'], 'TODO');
                  return Response(jsonEncode(mockTodoResponse), 200);
                },
              ),
            ),
          );
        },
        act: (bloc) => bloc.fetchNewTaskManagement(),
        expect: () {
          final tasks = TaskManagement.fromJson(mockTodoResponse).tasks;
          return [TaskManagementLoading(), TaskManagementLoaded(tasks: tasks)];
        },
      );

      blocTest<TodoCubit, TaskManagementState>(
        'emit [TaskManagementLoading, TaskManagementError] when get error from fetch data',
        seed: () => TaskManagementInitial(),
        build: () {
          return TodoCubit(
            taskManagementRepository: TaskManagementRepository(
              httpClient: MockClient(
                (request) async {
                  return Response('Not Found', 404);
                },
              ),
            ),
          );
        },
        act: (bloc) => bloc.fetchNewTaskManagement(),
        expect: () {
          return [
            TaskManagementLoading(),
            TaskManagementError(errorMessage: Exception().toString())
          ];
        },
      );

      blocTest<TodoCubit, TaskManagementState>(
        'emit [TaskManagementLoaded] when delete task',
        seed: () => TaskManagementLoaded(tasks: [taskA, taskB]),
        act: (bloc) => bloc.deleteTask(1),
        build: () => TodoCubit(),
        expect: () => [
          TaskManagementLoaded(tasks: [taskA])
        ],
      );

      blocTest<TodoCubit, TaskManagementState>(
        'emit [TaskManagementLoaded] when can Load more',
        seed: () => TaskManagementLoaded(tasks: [taskA]),
        build: () {
          return TodoCubit(
            taskManagementRepository: TaskManagementRepository(
              httpClient: MockClient(
                (request) async {
                  expect(request.url.queryParameters['status'], 'TODO');
                  return Response(jsonEncode(mockTodoResponse), 200);
                },
              ),
            ),
          );
        },
        act: (bloc) => bloc.loadMore(),
        expect: () {
          final tasks = TaskManagement.fromJson(mockTodoResponse).tasks;
          return [
            TaskManagementLoaded(tasks: [taskA], isLoadMore: true),
            TaskManagementLoaded(tasks: [taskA, ...tasks])
          ];
        },
      );

      blocTest<TodoCubit, TaskManagementState>(
        'emit [TaskManagementError] when load more error',
        seed: () => TaskManagementLoaded(tasks: [taskA]),
        build: () {
          return TodoCubit(
            taskManagementRepository: TaskManagementRepository(
              httpClient: MockClient(
                (request) async {
                  return Response('Not Found', 404);
                },
              ),
            ),
          );
        },
        act: (bloc) => bloc.loadMore(),
        expect: () => [
          TaskManagementLoaded(tasks: [taskA], isLoadMore: true),
          TaskManagementError(errorMessage: Exception().toString())
        ],
      );

      blocTest<TodoCubit, TaskManagementState>(
        'emit nothing if isFinalpage',
        seed: () => TaskManagementLoaded(tasks: [taskA]),
        build: () {
          final todoCubit = TodoCubit();
          todoCubit.isFinalPage = true;
          return todoCubit;
        },
        act: (bloc) => bloc.loadMore(),
        expect: () => [],
      );

      blocTest<TodoCubit, TaskManagementState>(
        'emit nothing if still load more',
        seed: () => TaskManagementLoaded(tasks: [taskA], isLoadMore: true),
        build: () => TodoCubit(),
        act: (bloc) => bloc.loadMore(),
        expect: () => [],
      );
    });

    group('DoingCubit', () {
      test('override is correct', () {
        final status = DoingCubit().status;
        expect(status, 'DOING');
      });

      blocTest<DoingCubit, TaskManagementState>(
        'emits [TaskManagementInitial] when status is initial',
        build: () => DoingCubit(),
        expect: () => [],
      );

      blocTest<DoingCubit, TaskManagementState>(
        'emit [TaskManagementLoading, TaskManagementLoaded] when can fetch data from api',
        seed: () => TaskManagementInitial(),
        build: () {
          return DoingCubit(
            taskManagementRepository: TaskManagementRepository(
              httpClient: MockClient(
                (request) async {
                  expect(request.url.queryParameters['status'], 'DOING');
                  return Response(jsonEncode(mockDoingResponse), 200);
                },
              ),
            ),
          );
        },
        act: (bloc) => bloc.fetchNewTaskManagement(),
        expect: () {
          final tasks = TaskManagement.fromJson(mockDoingResponse).tasks;
          return [TaskManagementLoading(), TaskManagementLoaded(tasks: tasks)];
        },
      );

      blocTest<DoingCubit, TaskManagementState>(
        'emit [TaskManagementLoading, TaskManagementError] when get error from fetch data',
        seed: () => TaskManagementInitial(),
        build: () {
          return DoingCubit(
            taskManagementRepository: TaskManagementRepository(
              httpClient: MockClient(
                (request) async {
                  return Response('Not Found', 404);
                },
              ),
            ),
          );
        },
        act: (bloc) => bloc.fetchNewTaskManagement(),
        expect: () {
          return [
            TaskManagementLoading(),
            TaskManagementError(errorMessage: Exception().toString())
          ];
        },
      );

      blocTest<DoingCubit, TaskManagementState>(
        'emit [TaskManagementLoaded] when delete task',
        seed: () => TaskManagementLoaded(tasks: [taskA, taskB]),
        act: (bloc) => bloc.deleteTask(1),
        build: () => DoingCubit(),
        expect: () => [
          TaskManagementLoaded(tasks: [taskA])
        ],
      );

      blocTest<DoingCubit, TaskManagementState>(
        'emit [TaskManagementLoaded] when can Load more',
        seed: () => TaskManagementLoaded(tasks: [taskA]),
        build: () {
          return DoingCubit(
            taskManagementRepository: TaskManagementRepository(
              httpClient: MockClient(
                (request) async {
                  expect(request.url.queryParameters['status'], 'DOING');
                  return Response(jsonEncode(mockDoingResponse), 200);
                },
              ),
            ),
          );
        },
        act: (bloc) => bloc.loadMore(),
        expect: () {
          final tasks = TaskManagement.fromJson(mockDoingResponse).tasks;
          return [
            TaskManagementLoaded(tasks: [taskA], isLoadMore: true),
            TaskManagementLoaded(tasks: [taskA, ...tasks])
          ];
        },
      );
      blocTest<DoingCubit, TaskManagementState>(
        'emit [TaskManagementError] when load more error',
        seed: () => TaskManagementLoaded(tasks: [taskA]),
        build: () {
          return DoingCubit(
            taskManagementRepository: TaskManagementRepository(
              httpClient: MockClient(
                (request) async {
                  return Response('Not Found', 404);
                },
              ),
            ),
          );
        },
        act: (bloc) => bloc.loadMore(),
        expect: () => [
          TaskManagementLoaded(tasks: [taskA], isLoadMore: true),
          TaskManagementError(errorMessage: Exception().toString())
        ],
      );

      blocTest<DoingCubit, TaskManagementState>(
        'emit nothing if isFinalpage',
        seed: () => TaskManagementLoaded(tasks: [taskA]),
        build: () {
          final doingCubit = DoingCubit();
          doingCubit.isFinalPage = true;
          return doingCubit;
        },
        act: (bloc) => bloc.loadMore(),
        expect: () => [],
      );

      blocTest<DoingCubit, TaskManagementState>(
        'emit nothing if still load more',
        seed: () => TaskManagementLoaded(tasks: [taskA], isLoadMore: true),
        build: () => DoingCubit(),
        act: (bloc) => bloc.loadMore(),
        expect: () => [],
      );
    });

    group('DoneCubit', () {
      test('override is correct', () {
        final status = DoneCubit().status;
        expect(status, 'DONE');
      });

      blocTest<DoneCubit, TaskManagementState>(
        'emits [TaskManagementInitial] when status is initial',
        build: () => DoneCubit(),
        expect: () => [],
      );

      blocTest<DoneCubit, TaskManagementState>(
        'emit [TaskManagementLoading, TaskManagementLoaded] when can fetch data from api',
        seed: () => TaskManagementInitial(),
        build: () {
          return DoneCubit(
            taskManagementRepository: TaskManagementRepository(
              httpClient: MockClient(
                (request) async {
                  expect(request.url.queryParameters['status'], 'DONE');
                  return Response(jsonEncode(mockDoneResponse), 200);
                },
              ),
            ),
          );
        },
        act: (bloc) => bloc.fetchNewTaskManagement(),
        expect: () {
          final tasks = TaskManagement.fromJson(mockDoneResponse).tasks;
          return [TaskManagementLoading(), TaskManagementLoaded(tasks: tasks)];
        },
      );

      blocTest<DoneCubit, TaskManagementState>(
        'emit [TaskManagementLoading, TaskManagementError] when get error from fetch data',
        seed: () => TaskManagementInitial(),
        build: () {
          return DoneCubit(
            taskManagementRepository: TaskManagementRepository(
              httpClient: MockClient(
                (request) async {
                  return Response('Not Found', 404);
                },
              ),
            ),
          );
        },
        act: (bloc) => bloc.fetchNewTaskManagement(),
        expect: () {
          return [
            TaskManagementLoading(),
            TaskManagementError(errorMessage: Exception().toString())
          ];
        },
      );

      blocTest<DoneCubit, TaskManagementState>(
        'emit [TaskManagementLoaded] when delete task',
        seed: () => TaskManagementLoaded(tasks: [taskA, taskB]),
        act: (bloc) => bloc.deleteTask(1),
        build: () => DoneCubit(),
        expect: () => [
          TaskManagementLoaded(tasks: [taskA])
        ],
      );

      blocTest<DoneCubit, TaskManagementState>(
        'emit [TaskManagementLoaded] when can Load more',
        seed: () => TaskManagementLoaded(tasks: [taskA]),
        build: () {
          return DoneCubit(
            taskManagementRepository: TaskManagementRepository(
              httpClient: MockClient(
                (request) async {
                  expect(request.url.queryParameters['status'], 'DONE');
                  return Response(jsonEncode(mockDoneResponse), 200);
                },
              ),
            ),
          );
        },
        act: (bloc) => bloc.loadMore(),
        expect: () {
          final tasks = TaskManagement.fromJson(mockDoneResponse).tasks;
          return [
            TaskManagementLoaded(tasks: [taskA], isLoadMore: true),
            TaskManagementLoaded(tasks: [taskA, ...tasks])
          ];
        },
      );
      blocTest<DoneCubit, TaskManagementState>(
        'emit [TaskManagementError] when load more error',
        seed: () => TaskManagementLoaded(tasks: [taskA]),
        build: () {
          return DoneCubit(
            taskManagementRepository: TaskManagementRepository(
              httpClient: MockClient(
                (request) async {
                  return Response('Not Found', 404);
                },
              ),
            ),
          );
        },
        act: (bloc) => bloc.loadMore(),
        expect: () => [
          TaskManagementLoaded(tasks: [taskA], isLoadMore: true),
          TaskManagementError(errorMessage: Exception().toString())
        ],
      );

      blocTest<DoneCubit, TaskManagementState>(
        'emit nothing if isFinalpage',
        seed: () => TaskManagementLoaded(tasks: [taskA]),
        build: () {
          final doneCubit = DoneCubit();
          doneCubit.isFinalPage = true;
          return doneCubit;
        },
        act: (bloc) => bloc.loadMore(),
        expect: () => [],
      );

      blocTest<DoneCubit, TaskManagementState>(
        'emit nothing if still load more',
        seed: () => TaskManagementLoaded(tasks: [taskA], isLoadMore: true),
        build: () => DoneCubit(),
        act: (bloc) => bloc.loadMore(),
        expect: () => [],
      );
    });
  });
}
