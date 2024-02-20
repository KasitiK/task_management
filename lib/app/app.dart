import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/app/bloc/app_bloc.dart';
import 'package:task_management/app/repository/app_repository.dart';
import 'package:task_management/task_management/task_management_page.dart';
import 'package:task_management/passcode/passcode_page.dart';
import 'package:task_management/splash/splash_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRepository _appnRepository;

  @override
  void initState() {
    super.initState();
    _appnRepository = AppRepository();
  }

  @override
  void dispose() {
    _appnRepository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: RepositoryProvider.value(
        value: _appnRepository,
        child: BlocProvider(
          create: (_) => AppBloc(appRepository: _appnRepository),
          child: const AppView(),
        ),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => RepositoryProvider.of<AppRepository>(context)
          .resetTimer(BlocProvider.of<AppBloc>(context).state.status),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        title: 'Task Management',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
          useMaterial3: true,
        ),
        builder: (context, child) {
          return BlocListener<AppBloc, AppState>(
            listener: (context, state) {
              switch (state.status) {
                case AppStatus.initial || AppStatus.lock:
                  _navigator.pushAndRemoveUntil<void>(
                    PasscodePage.route(),
                    (route) => route != TaskManagementPage.route(),
                  );
                case AppStatus.initialSuccess:
                  _navigator.pushAndRemoveUntil<void>(
                      TaskManagementPage.route(), (route) => false);
                case AppStatus.success:
                  _navigator.pop();
              }
            },
            child: child,
          );
        },
        onGenerateRoute: (_) => SplashPage.route(),
      ),
    );
  }
}
