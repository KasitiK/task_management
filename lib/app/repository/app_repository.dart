import 'dart:async';

import 'package:flutter/foundation.dart';

enum AppStatus { initial, initialSuccess, lock, success }

class AppRepository {
  
  @visibleForTesting final controller = StreamController<AppStatus>();
  @visibleForTesting Timer? timer;
  @visibleForTesting int countdown = 10;

  Stream<AppStatus> get status async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield AppStatus.initial;
    yield* controller.stream;
  }

  Future<bool> validatePasscode(AppStatus status, String passcode) async {
    if (passcode != "123456") return false;
    return await Future.delayed(const Duration(milliseconds: 300), () {
      controller.add(status == AppStatus.initial
          ? AppStatus.initialSuccess
          : AppStatus.success);
      return true;
    });
  }

  void startTimer() {
    countdown = 10;
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (countdown == 0) {
          controller.add(AppStatus.lock);
          stopTimer();
        } else {
          countdown--;
        }
      },
    );
  }

  void stopTimer() {
    timer?.cancel();
    timer = null;
  }

  void resetTimer(AppStatus status) {
    stopTimer();
    if (status != AppStatus.initial && status != AppStatus.lock) startTimer();
  }

  void dispose() {
    controller.close();
    stopTimer();
  }
}
