part of 'task_management_cubit.dart';

sealed class TaskManagementState extends Equatable {
  const TaskManagementState();

  @override
  List<Object> get props => [];
}

final class TaskManagementInitial extends TaskManagementState {}

final class TaskManagementLoading extends TaskManagementState {}

final class TaskManagementLoaded extends TaskManagementState {
  const TaskManagementLoaded({required this.tasks, this.isLoadMore = false});

  final List<Task> tasks;
  final bool isLoadMore;

  @override
  List<Object> get props => [tasks, isLoadMore];
}

final class TaskManagementError extends TaskManagementState {
  const TaskManagementError({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object> get props => [errorMessage];
}
