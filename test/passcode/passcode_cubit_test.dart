import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_management/app/repository/app_repository.dart';
import 'package:task_management/passcode/cubit/passcode_cubit.dart';

class _MockAppRepository extends Mock implements AppRepository {}

void main() {
  late AppRepository appRepository;

  setUp(() => appRepository = _MockAppRepository());
  group('PasscodeCubit', () {
    test('emit [PasscodeInitial] when initial', () {
      final passcodeCubit = PasscodeCubit(
          appRepository: appRepository, appStatus: AppStatus.initial);
      expect(passcodeCubit.state, PasscodeInitial());
    });

    blocTest<PasscodeCubit, PasscodeState>(
      'emit [PasscodeChange] when enter passcode',
      build: () => PasscodeCubit(
          appRepository: appRepository, appStatus: AppStatus.initial),
      act: (bloc) => bloc.enterPasscode('1'),
      expect: () => [
        const PasscodeChange(stringNumbers: ['1'])
      ],
    );

    blocTest<PasscodeCubit, PasscodeState>(
      'emit [PasscodeChange, PasscodeValidateFaild] when validate faild',
      build: () => PasscodeCubit(
          appRepository: appRepository, appStatus: AppStatus.initial),
      setUp: () {
        when(() => appRepository.validatePasscode(AppStatus.initial, "123451"))
            .thenAnswer((_) => Future(() => false));
      },
      seed: () =>
          const PasscodeChange(stringNumbers: ['1', '2', '3', '4', '5']),
      act: (bloc) => bloc.enterPasscode('1'),
      expect: () => [
        const PasscodeChange(stringNumbers: ['1', '2', '3', '4', '5', '1']),
        const PasscodeValidateFaild(
            stringNumbers: ['1', '2', '3', '4', '5', '1'])
      ],
      verify: (_) {
        verify(() =>
                appRepository.validatePasscode(AppStatus.initial, "123451"))
            .called(1);
      },
    );

    blocTest<PasscodeCubit, PasscodeState>(
      'emit [PasscodeChange] when validate successful',
      build: () => PasscodeCubit(
          appRepository: appRepository, appStatus: AppStatus.initial),
      setUp: () {
        when(() => appRepository.validatePasscode(AppStatus.initial, "123456"))
            .thenAnswer((_) => Future(() => true));
      },
      seed: () =>
          const PasscodeChange(stringNumbers: ['1', '2', '3', '4', '5']),
      act: (bloc) => bloc.enterPasscode('6'),
      expect: () => [
        const PasscodeChange(stringNumbers: ['1', '2', '3', '4', '5', '6']),
      ],
      verify: (_) {
        verify(() =>
                appRepository.validatePasscode(AppStatus.initial, "123456"))
            .called(1);
      },
    );

    blocTest<PasscodeCubit, PasscodeState>(
      'emit [PasscodeChange] when delete pascode',
      build: () => PasscodeCubit(
          appRepository: appRepository, appStatus: AppStatus.initial),
      seed: () => const PasscodeChange(stringNumbers: ['1', '2']),
      act: (bloc) => bloc.deletePasscode(),
      expect: () => [
        const PasscodeChange(stringNumbers: ['1'])
      ],
    );

    blocTest<PasscodeCubit, PasscodeState>(
      'emit [PasscodeValidateFaild] when validate passcode faild',
      build: () => PasscodeCubit(
          appRepository: appRepository, appStatus: AppStatus.initial),
      act: (bloc) => bloc.validateFaild(),
      expect: () =>
          [const PasscodeValidateFaild(stringNumbers: []), PasscodeInitial()],
    );
  });
}
