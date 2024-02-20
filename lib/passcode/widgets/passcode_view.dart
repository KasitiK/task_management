import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/passcode/cubit/passcode_cubit.dart';

class PasscodeView extends StatefulWidget {
  const PasscodeView({super.key});

  @override
  State<PasscodeView> createState() => _PasscodeViewState();
}

class _PasscodeViewState extends State<PasscodeView>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );

    _animation = _animationController
        .drive(CurveTween(curve: Curves.elasticIn))
        .drive(Tween<Offset>(begin: Offset.zero, end: const Offset(0.1, 0)))
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            _animationController.reverse();
          }
        },
      );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PasscodeCubit, PasscodeState>(
      listener: (context, state) {
        if (state is PasscodeValidateFaild) {
          _animationController.forward();
        }
      },
      builder: (context, state) {
        return SlideTransition(
          position: _animation,
          child: Wrap(
            spacing: 20,
            children: List.generate(
              6,
              (index) {
                return Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index <= state.stringNumbers.length - 1
                          ? Colors.grey
                          : Colors.grey.shade300),
                  width: (MediaQuery.of(context).size.width - 144 - 100) / 6,
                  height: (MediaQuery.of(context).size.width - 144 - 100) / 6,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
