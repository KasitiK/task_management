import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:task_management/app/repository/app_repository.dart';

void main() {
  late AppRepository appRepository;

  setUp(() {
    appRepository = AppRepository();
  });

  group('AppRespository', () {
    test('should emit AppStatus.initial', () {
      appRepository.status
          .listen(expectAsync1((status) => expect(status, AppStatus.initial)));
    });

    test(
        'validate correct passcode should emit [initialSuccess] and return ture',
        () {
      fakeAsync((FakeAsync async) {
        final future =
            appRepository.validatePasscode(AppStatus.initial, '123456');
        final strem = appRepository.controller.stream;

        async.elapse(const Duration(milliseconds: 300));
        expect(strem, emitsInOrder([AppStatus.initialSuccess]));
        expect(future, completion(true));
        async.flushMicrotasks();
      });
    });

     test(
        'validate correct passcode should emit [success] and return ture',
        () {
      fakeAsync((FakeAsync async) {
        final future =
            appRepository.validatePasscode(AppStatus.lock, '123456');
        final strem = appRepository.controller.stream;

        async.elapse(const Duration(milliseconds: 300));
        expect(strem, emitsInOrder([AppStatus.success]));
        expect(future, completion(true));
        async.flushMicrotasks();
      });
    });

    test('validate incorrect passcode should return false', () {
      fakeAsync((FakeAsync async) {
        final future =
            appRepository.validatePasscode(AppStatus.initial, '222222');
        async.elapse(const Duration(milliseconds: 300));
        expect(future, completion(false));
        async.flushMicrotasks();
      });
    });

    test('start timer and should emit [lock] after 10 sec', () {
      fakeAsync((FakeAsync async) {
        appRepository.startTimer();
        async.elapse(const Duration(seconds: 10));
        async.flushTimers();
        expect(appRepository.countdown, 0);
        expect(appRepository.timer, isNull);
      });
    });

    test('reset timer with not start new timer', () {
      appRepository.resetTimer(AppStatus.initial);
      appRepository.resetTimer(AppStatus.lock);
      expect(appRepository.timer, isNull);
    });

    test('reset timer with start new timer', () {
      appRepository.resetTimer(AppStatus.success);
      expect(appRepository.timer, isNotNull);
    });

    test('dispose', () {
      appRepository.dispose();
      expect(appRepository.controller.isClosed, true);
      expect(appRepository.timer, isNull);
    });
  });
}
