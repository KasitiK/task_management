import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/task_management/cubit/task_management_cubit.dart';
import 'package:task_management/task_management/views/doing_view.dart';
import 'package:task_management/task_management/views/done_view.dart';
import 'package:task_management/task_management/views/todo_view.dart';

class TaskManagementPage extends StatelessWidget {
  const TaskManagementPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const TaskManagementPage());
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => TodoCubit()..fetchNewTaskManagement(),
            // create: (_) => TodoCubit(),
          ),
          BlocProvider(
            create: (_) => DoingCubit(),
          ),
          BlocProvider(
            create: (_) => DoneCubit(),
          ),
        ],
        child: const TaskManagementView(),
      ),
    );
  }
}

class TaskManagementView extends StatefulWidget {
  const TaskManagementView({super.key});

  @override
  State<TaskManagementView> createState() => _TaskManagementViewState();
}

class _TaskManagementViewState extends State<TaskManagementView>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController?.addListener(() {
      switch (_tabController?.index) {
        case 0:
          break;
        case 1:
          context.read<DoingCubit>().fetchNewTaskManagement();
        case 2:
          context.read<DoneCubit>().fetchNewTaskManagement();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        _buildBackground(context),
        _buildContent(context),
      ],
    );
  }

  Widget _buildBackground(BuildContext context) {
    final topBackgrounHeight = MediaQuery.of(context).size.height / 3;
    return Container(
      decoration: BoxDecoration(
          color: Colors.purple.shade50,
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(60),
              bottomRight: Radius.circular(60))),
      width: double.infinity,
      height: topBackgrounHeight,
    );
  }

  Widget _buildContent(BuildContext context) {
    final topBackgrounHeight = MediaQuery.of(context).size.height / 3;
    final padding = EdgeInsets.only(
        bottom: ((topBackgrounHeight -
                80 -
                25 -
                40 -
                20 -
                MediaQuery.of(context).padding.top) /
            2));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildAvatar(),
            Padding(padding: padding),
            _buildHeaderTitle(),
            Padding(padding: padding),
            _buildCustomTabBar(),
            Padding(padding: padding),
            _buildTabBarView(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return const Align(
      alignment: Alignment.topRight,
      child: CircleAvatar(
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildHeaderTitle() {
    return const SizedBox(
      width: double.infinity,
      height: 80,
      child: Text(
        'Hi User',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
      ),
      width: 300,
      height: 50,
      child: TabBar(
        tabs: const [
          Tab(
            key: Key('todo-tab'),
            text: 'To-do',
          ),
          Tab(
            key: Key('doing-tab'),
            text: 'Doing',
          ),
          Tab(
            key: Key('done-tab'),
            text: 'Done',
          ),
        ],
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        labelColor: Colors.white,
        indicator: BoxDecoration(
          color: Colors.purple.shade100,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        indicatorPadding: const EdgeInsets.all(10),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerHeight: 0,
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            return states.contains(MaterialState.focused)
                ? null
                : Colors.transparent;
          },
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: const [
          TodoView(),
          DoingView(),
          DoneView(),
        ],
      ),
    );
  }
}
