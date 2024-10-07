import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku/cubit/board_cubit/game_cubit.dart';

import 'game_view.dart';

class SudokuAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SudokuAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<GameCubit>(context).startStopwatch();
    return AppBar(
      backgroundColor: backgroundColor,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          MaterialButton(
            onPressed: () => BlocProvider.of<GameCubit>(context)
                .generateBoard(Random.secure()),
            shape: RoundedRectangleBorder(
                side: const BorderSide(
                    color: Colors.white, width: 3.0, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(30.0)),
            child: Text(
              "New Board",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 40.0,
                  color: Colors.white),
            ),
          ),
        ],
      ),
      actions: [
        BlocBuilder<GameCubit, GameState>(builder: (context, state) {
          return Text(
            formatElapsedTime(state.stopwatch.elapsed),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
                color: Colors.white),
          );
        })
      ],
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

String formatElapsedTime(Duration time) {
  return '${time.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(time.inSeconds.remainder(60)).toString().padLeft(2, '0')}.${(time.inMilliseconds % 1000 ~/ 100).toString()}';
}
