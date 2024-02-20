part of 'app_bloc.dart';

final class AppState extends Equatable{
  const AppState({
    this.status = AppStatus.initial,
  });

  const AppState.initial() : this();
  const AppState.initialSuccess() : this(status: AppStatus.initialSuccess);
  const AppState.lock() : this(status: AppStatus.lock);
  const AppState.success() : this(status: AppStatus.success);

  final AppStatus status;

    @override
  List<Object?> get props => [status];
}
