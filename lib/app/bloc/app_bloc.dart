import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:task_management/app/repository/app_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AppRepository appRepository,
  })  : _appRepository = appRepository,
        super(const AppState.initial()) {
    on<AppStatusChange>(_onAppStatusChange);

    _appStatusSubscription = _appRepository.status.listen((status) {
      add(AppStatusChange(status));
    });
  }

  final AppRepository _appRepository;
  late StreamSubscription<AppStatus> _appStatusSubscription;

  @override
  Future<void> close() {
    _appStatusSubscription.cancel();
    return super.close();
  }

  void _onAppStatusChange(
    AppStatusChange event,
    Emitter<AppState> emit,
  ) async {
    switch (event.status) {
      case AppStatus.initial:
        emit(const AppState.initial());
      case AppStatus.initialSuccess:
        _appRepository.startTimer();
        emit(const AppState.initialSuccess());
      case AppStatus.success:
        _appRepository.startTimer();
        emit(const AppState.success());
      case AppStatus.lock:
        emit(const AppState.lock());
    }
  }
}
