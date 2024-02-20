import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_management/app/bloc/app_bloc.dart';
import 'package:task_management/app/repository/app_repository.dart';

class _MockAppRepository extends Mock implements AppRepository {}

void main() {
  late AppRepository appRepository;
  setUp(() {
    appRepository = _MockAppRepository();
    when(
      () => appRepository.status,
    ).thenAnswer((_) => const Stream.empty());
  });

  group('AppBloc', () {
    blocTest<AppBloc, AppState>(
      'emits [initial] when status is initial',
      setUp: () {
        when(() => appRepository.status).thenAnswer(
          (_) => Stream.value(AppStatus.initial),
        );
      },
      build: () => AppBloc(appRepository: appRepository),
      expect: () => const <AppState>[AppState.initial()],
    );

    blocTest<AppBloc, AppState>(
      'emits [initialSuccess] when status is initialSuccess',
      setUp: () {
        when(() => appRepository.status).thenAnswer(
          (_) => Stream.value(AppStatus.initialSuccess),
        );
      },
      build: () => AppBloc(appRepository: appRepository),
      expect: () => const <AppState>[AppState.initialSuccess()],
    );

    blocTest<AppBloc, AppState>(
      'emits [lock] when status is lock',
      setUp: () {
        when(() => appRepository.status).thenAnswer(
          (_) => Stream.value(AppStatus.lock),
        );
      },
      build: () => AppBloc(appRepository: appRepository),
      expect: () => const <AppState>[AppState.lock()],
    );

    blocTest<AppBloc, AppState>(
      'emits [success] when status is success',
      setUp: () {
        when(() => appRepository.status).thenAnswer(
          (_) => Stream.value(AppStatus.success),
        );
      },
      build: () => AppBloc(appRepository: appRepository),
      expect: () => const <AppState>[AppState.success()],
    );
  });
}
