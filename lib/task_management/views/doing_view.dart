import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/task_management/cubit/task_management_cubit.dart';
import 'package:task_management/task_management/widgets/error_view.dart';
import 'package:task_management/task_management/widgets/loading_view.dart';
import 'package:task_management/task_management/widgets/task_management_list_view.dart';

class DoingView extends StatefulWidget {
  const DoingView({super.key});

  @override
  State<DoingView> createState() => _DoingViewState();
}

class _DoingViewState extends State<DoingView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<DoingCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoingCubit, TaskManagementState>(
      builder: (context, state) {
        switch (state) {
          case TaskManagementInitial():
            return const LoadingView();
          case TaskManagementLoading():
            return const LoadingView();
          case TaskManagementLoaded():
            return TaskManagementListView(
              scrollController: _scrollController,
              state: state,
              onDeleteTask: (index) {
                context.read<DoingCubit>().deleteTask(index);
              },
              onRefresh: () => context
                  .read<DoingCubit>()
                  .fetchNewTaskManagement(isRefresh: true),
            );
          case TaskManagementError():
            return ErrorView(errorMessage: state.errorMessage);
        }
      },
    );
  }
}
