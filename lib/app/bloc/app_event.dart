part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

final class AppStatusChange extends AppEvent {
  const AppStatusChange(this.status);

  final AppStatus status;
}
