import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_management/app/repository/app_repository.dart';
import 'package:equatable/equatable.dart';

part 'passcode_state.dart';

class PasscodeCubit extends Cubit<PasscodeState> {
  PasscodeCubit({
    required AppRepository appRepository,
    required AppStatus appStatus,
  })  : _appRepository = appRepository,
        _appStatus = appStatus,
        super(PasscodeInitial());

  final AppRepository _appRepository;
  final AppStatus _appStatus;

  void enterPasscode(String stringNumber) async {
    emit(PasscodeChange(
        stringNumbers: List.from(state.stringNumbers)..add(stringNumber)));
    if (state.stringNumbers.length == 6) {
      if (!await _appRepository.validatePasscode(
          _appStatus, state.stringNumbers.join())) validateFaild();
    }
  }

  void deletePasscode() async {
    if (state.stringNumbers.isEmpty) return;
    emit(PasscodeChange(
        stringNumbers: List.from(state.stringNumbers)..removeLast()));
  }

  void validateFaild() async {
    emit(PasscodeValidateFaild(stringNumbers: state.stringNumbers));
    await Future.delayed(const Duration(milliseconds: 80), () {
      emit(PasscodeInitial());
    });
  }
}
