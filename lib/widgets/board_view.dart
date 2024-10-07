import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:sudoku/cubit/board_cubit/game_cubit.dart';
import 'package:sudoku/widgets/shortcuts.dart';
import 'package:sudoku/widgets/square.dart';

import 'appbar.dart';

const int boardSize = 81;

// TODO: Make a timer to measure your time to complete a sudoku

class BoardView extends StatelessWidget {
  const BoardView({super.key});

  @override
  Widget build(BuildContext context) {
    final gameCubit = context.read<GameCubit>();
    if (gameCubit.state.boardIndex == -1) {
      gameCubit.generateBoard(Random.secure());
    }

    return BlocBuilder<GameCubit, GameState>(builder: (context, state) {
      final boardState = state.boardStates[state.boardIndex];

      final selectedSquare = boardState.currentIndex;

      if (isBoardSolved(state)) {
        // This scheduler binding is done so that we don't push anything
        // on top of the current frame before it is done being rendered
        SchedulerBinding.instance.addPostFrameCallback((_) async {
          await _gameWon(context, gameCubit);
        });
      }

      return FocusableActionDetector(
        autofocus: true,
        shortcuts: shortcuts,
        actions: {
          ArrowIntent:
              CallbackAction<ArrowIntent>(onInvoke: (ArrowIntent intent) {
            switch (intent.arrow) {
              case LogicalKeyboardKey.arrowUp:
                if (selectedSquare ~/ 9 > 0) {
                  gameCubit.changeCurrentIndex(selectedSquare - 9);
                }
                break;

              case LogicalKeyboardKey.arrowRight:
                if (selectedSquare < 80) {
                  gameCubit.changeCurrentIndex(selectedSquare + 1);
                }
                break;

              case LogicalKeyboardKey.arrowDown:
                if (selectedSquare ~/ 9 < 8) {
                  gameCubit.changeCurrentIndex(selectedSquare + 9);
                }
                break;

              case LogicalKeyboardKey.arrowLeft:
                if (selectedSquare > 0) {
                  gameCubit.changeCurrentIndex(selectedSquare - 1);
                }
                break;
            }
            return null;
          }),
          DigitIntent:
              CallbackAction<DigitIntent>(onInvoke: (DigitIntent intent) {
            // Note: Digit is always valid so no need for checks
            return gameCubit.changeSquareState(
                selectedSquare, intent.digitInputted);
          }),
          BackSpaceIntent: CallbackAction<BackSpaceIntent>(
              onInvoke: (BackSpaceIntent intent) {
            return gameCubit.changeSquareState(selectedSquare, 0);
          }),
          HintDigitIntent: CallbackAction<HintDigitIntent>(
              onInvoke: (HintDigitIntent intent) {
            return gameCubit.changeHintDigits(intent.digitInputted);
          })
        },
        child: Center(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: LayoutGrid(
              columnSizes: List.filled(9, 9.fr),
              rowSizes: List.filled(9, 9.fr),
              children: List.generate(81, (index) {
                final squareState = boardState.squareStates[index];
                return GestureDetector(
                  onTap: () => gameCubit.changeCurrentIndex(index),
                  child: Square(
                      squareState: squareState,
                      squareIndex: index,
                      currentIndex: boardState.currentIndex),
                );
              }),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _gameWon(BuildContext context, GameCubit gameCubit) async {
    gameCubit.endStopwatch();
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Column(
                children: [
                  const Text("You won!"),
                  Text("Time: ${formatElapsedTime(gameCubit.state.stopwatch.elapsed)}")
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Start again?"))
              ],
            ));
    gameCubit.generateBoard(Random.secure());
  }

  bool isBoardSolved(GameState state) {
    for (int index = 0; index < boardSize; index++) {
      if (state.boardStates[state.boardIndex].squareStates[index].value !=
          state.solution[index]) {
        return false;
      }
    }
    return true;
  }
}
