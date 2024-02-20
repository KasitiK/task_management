import 'package:flutter/material.dart';
import 'package:task_management/task_management/cubit/task_management_cubit.dart';
import 'package:task_management/task_management/model/task_managemant_model.dart';
import 'package:task_management/task_management/widgets/loading_view.dart';
import 'package:task_management/utility/extension.dart';

class TaskManagementListView extends StatelessWidget {
  const TaskManagementListView({
    super.key,
    required scrollController,
    required this.state,
    required this.onDeleteTask,
    required this.onRefresh,
  }) : _scrollController = scrollController;

  final ScrollController _scrollController;
  final TaskManagementLoaded state;
  final Function(int) onDeleteTask;
  final Function onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () => Future(() => onRefresh()),
      child: ListView.separated(
        shrinkWrap: true,
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount:
            state.isLoadMore ? state.tasks.length + 1 : state.tasks.length,
        itemBuilder: (context, index) {
          return index >= state.tasks.length
              ? const LoadingView()
              : _buildListItemView(
                  index,
                  state.tasks[index],
                  (index != 0)
                      ? state.tasks[index].createdAt
                          .isSameDate(state.tasks[index - 1].createdAt)
                      : false);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 20),
      ),
    );
  }

  Widget _buildListItemView(int index, Task task, bool isSameDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isSameDate)
          Text(
            task.createdAt.toDateFormatString(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        Dismissible(
          key: Key(task.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              onDeleteTask(index);
            }
          },
          background: const ColoredBox(
            color: Colors.red,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ),
          child: Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      task.description,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
