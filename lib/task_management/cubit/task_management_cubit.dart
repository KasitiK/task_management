import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_management/task_management/model/task_managemant_model.dart';
import 'package:task_management/task_management/repository/task_management_repository.dart';

part 'task_management_state.dart';

abstract class TaskManagementCubit extends Cubit<TaskManagementState> {
  TaskManagementCubit({TaskManagementRepository? taskManagementRepository})
      : _taskManagementRepository =
            taskManagementRepository ?? TaskManagementRepository(),
        super(TaskManagementInitial());

  final TaskManagementRepository _taskManagementRepository;
  String status = 'TODO';
  int page = 0;
  bool isFinalPage = false;

  void fetchNewTaskManagement({bool isRefresh = false}) async {
    if (state == TaskManagementInitial() || isRefresh) {
      emit(TaskManagementLoading());
      page = 0;
      final result = await _taskManagementRepository.getTaskManagement(
        page: page,
        status: status,
      );
      switch (result) {
        case Success(value: final taskManagement):
          isFinalPage = page == taskManagement.totalPages - 1;
          emit(TaskManagementLoaded(tasks: taskManagement.tasks));
        case Failure(exception: final e):
          emit(TaskManagementError(errorMessage: e.toString()));
      }
    }
  }

  void deleteTask(int index) {
    final loadedState = (state as TaskManagementLoaded);
    emit(TaskManagementLoaded(
        tasks: List.from(loadedState.tasks)..removeAt(index)));
  }

  void loadMore() async {
    final loadedState = (state as TaskManagementLoaded);
    if (!loadedState.isLoadMore && !isFinalPage) {
      emit(TaskManagementLoaded(tasks: loadedState.tasks, isLoadMore: true));
      page++;
      final result = await _taskManagementRepository.getTaskManagement(
        page: page,
        status: status,
      );
      switch (result) {
        case Success(value: final taskManagement):
          isFinalPage = page == taskManagement.totalPages - 1;
          emit(TaskManagementLoaded(
              tasks: [...loadedState.tasks, ...taskManagement.tasks]));
        case Failure(exception: final e):
          emit(TaskManagementError(errorMessage: e.toString()));
      }
    }
  }
}

class TodoCubit extends TaskManagementCubit {
  TodoCubit({super.taskManagementRepository});
  
  @override
  String get status => 'TODO';
}

class DoingCubit extends TaskManagementCubit {
  DoingCubit({super.taskManagementRepository});

  @override
  String get status => 'DOING';
}

class DoneCubit extends TaskManagementCubit {
  DoneCubit({super.taskManagementRepository});

  @override
  String get status => 'DONE';
}
