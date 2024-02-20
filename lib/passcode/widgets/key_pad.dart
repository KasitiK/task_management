import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/passcode/cubit/passcode_cubit.dart';

class KeyPad extends StatelessWidget {
  const KeyPad({
    super.key,
    required this.stringNumber,
    this.deleteIcon,
  });

  const KeyPad.delete({
    super.key,
    this.stringNumber = 'delete_icon',
    required this.deleteIcon,
  });

  final String stringNumber;
  final Widget? deleteIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.width - 144) / 3,
      width: (MediaQuery.of(context).size.width - 144) / 3,
      margin: const EdgeInsets.all(10),
      child: BlocBuilder<PasscodeCubit, PasscodeState>(
        builder: (context, state) {
          return ElevatedButton(
            onPressed: state.stringNumbers.length != 6
                ? deleteIcon != null
                    ? () => context.read<PasscodeCubit>().deletePasscode()
                    : () => context
                        .read<PasscodeCubit>()
                        .enterPasscode(stringNumber)
                : null,
            style: ElevatedButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 32,
              ),
              foregroundColor: Colors.brown,
              backgroundColor: Colors.grey.shade300,
            ),
            child: deleteIcon ?? Text(stringNumber),
          );
        },
      ),
    );
  }
}
