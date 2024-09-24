import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sudoku/cubit/board_cubit/game_cubit.dart';
import 'package:sudoku/widgets/appbar.dart';
import 'package:sudoku/widgets/board_view.dart';

const backgroundColor = Color(0xFF757575);

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const SudokuAppbar(),
      body: BlocProvider<GameCubit>.value(
        value: BlocProvider.of<GameCubit>(context),
        child: const BoardView(),
      ));
  }
}
