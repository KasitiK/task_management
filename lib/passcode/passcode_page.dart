import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/app/bloc/app_bloc.dart';
import 'package:task_management/app/repository/app_repository.dart';
import 'package:task_management/passcode/cubit/passcode_cubit.dart';
import 'package:task_management/passcode/widgets/key_pad.dart';
import 'package:task_management/passcode/widgets/passcode_view.dart';

class PasscodePage extends StatelessWidget {
  PasscodePage({super.key, this.footer});

  static Route<void> route() {
    return CupertinoPageRoute(
      fullscreenDialog: true,
      builder: (context) => PasscodePage(),
    );
  }

  final Widget? footer;
  final numberList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocProvider(
        create: (_) => PasscodeCubit(
            appRepository: RepositoryProvider.of<AppRepository>(context),
            appStatus: BlocProvider.of<AppBloc>(context).state.status),
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Please enter passcode.',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const PasscodeView(),
                  _buildKeyPad(context),
                  if (footer != null) footer!
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyPad(BuildContext context) {
    return Column(
      children: [..._generateRow(context)],
    );
  }

  List<Widget> _generateRow(BuildContext context) {
    return List.generate(
      4,
      (rowindex) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: (rowindex == 3)
              ? _generateLastRow(context)
              : List.generate(
                  3,
                  (index) {
                    final numberIndex = rowindex * 3 + index;
                    final stringNumber = numberList[numberIndex].toString();

                    return KeyPad(
                      key: Key(stringNumber),
                      stringNumber: stringNumber,
                    );
                  },
                ),
        );
      },
    );
  }

  List<Widget> _generateLastRow(BuildContext context) {
    return [
      Visibility(
        visible: false,
        maintainAnimation: true,
        maintainState: true,
        maintainSize: true,
        child: Container(
          height: (MediaQuery.of(context).size.width - 144) / 3,
          width: (MediaQuery.of(context).size.width - 144) / 3,
          margin: const EdgeInsets.all(10),
        ),
      ),
      KeyPad(
        stringNumber: numberList.last.toString(),
      ),
      const KeyPad.delete(
        deleteIcon: Icon(Icons.backspace),
      )
    ];
  }
}
