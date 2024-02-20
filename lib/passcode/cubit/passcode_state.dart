part of 'passcode_cubit.dart';

@immutable
sealed class PasscodeState extends Equatable {
  const PasscodeState({this.stringNumbers = const []});
  
  final List<String> stringNumbers;

  @override
  List<Object> get props => [stringNumbers];
}

final class PasscodeInitial extends PasscodeState {}

final class PasscodeChange extends PasscodeState {
  const PasscodeChange({required super.stringNumbers});
}

final class PasscodeValidateFaild extends PasscodeState {
  const PasscodeValidateFaild({required super.stringNumbers});
}
