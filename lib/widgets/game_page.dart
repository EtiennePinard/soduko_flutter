import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku/cubit/board_cubit/game_cubit.dart';
import 'package:sudoku/widgets/game_view.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GameCubit>(create: (_) => GameCubit(),
    child: const GameView(),);
  }
}
