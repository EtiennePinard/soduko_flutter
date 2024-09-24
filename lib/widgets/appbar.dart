import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku/cubit/board_cubit/game_cubit.dart';

import 'game_view.dart';

class SudokuAppbar extends StatelessWidget implements PreferredSizeWidget {
  const SudokuAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => BlocProvider.of<GameCubit>(context).generateBoard(Random.secure()),
            child: Text(
              "New Board",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 40.0,
                color: Colors.white
              ),
            ),
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
