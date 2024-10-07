import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:sudoku/widgets/board_view.dart';
import 'package:sudoku_tools/sudoku_tools.dart';

part 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameInitial.initial());

  void _createTimerCallback(Stopwatch stopwatch) {
    Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      // Update elapsed time only if the stopwatch is running
      if (stopwatch.isRunning) {
        emit(GameInitial(
            state.boardStates, state.solution, state.boardIndex, stopwatch));
      }
    });
  }

  void startStopwatch() {
    final stopwatch = Stopwatch();
    _createTimerCallback(stopwatch);
    stopwatch.start();
  }

  void endStopwatch() {
    state.stopwatch.stop();
  }

  void changeHintDigits(int hintDigitToUpdate) {
    final currentBoard = state.boardStates[state.boardIndex];
    final currentSquare = currentBoard.squareStates[currentBoard.currentIndex];
    if (currentSquare is FinalSquareState) {
      return; // Cannot edit a square which has a number set from the beginning
    }

    List<int> hintDigits = <int>[];
    hintDigits.addAll((currentSquare as EditableSquareState).hintNumbers);

    if (!hintDigits.contains(hintDigitToUpdate)) {
      hintDigits.add(hintDigitToUpdate); // Add it if it does not contain it
    } else {
      hintDigits.remove(hintDigitToUpdate); // Remove it if it does contain it
    }
    hintDigits.sort();

    currentBoard.squareStates[currentBoard.currentIndex] =
        EditableSquareState(currentSquare.value, hintDigits);

    final boardStates = state.boardStates;
    boardStates[state.boardIndex] =
        BoardState(currentBoard.squareStates, currentBoard.currentIndex);

    emit(GameInitial(
        boardStates, state.solution, state.boardIndex, state.stopwatch));
  }

  void changeCurrentIndex(int indexToChangeTo) {
    final currentBoard = state.boardStates[state.boardIndex];
    final boardStates = state.boardStates;
    boardStates[state.boardIndex] =
        BoardState(currentBoard.squareStates, indexToChangeTo);
    emit(GameInitial(
        boardStates, state.solution, state.boardIndex, state.stopwatch));
  }

  void changeSquareState(int squareIndex, int numberToChangeTo) {
    final currentBoard = state.boardStates[state.boardIndex];
    if (currentBoard.squareStates[currentBoard.currentIndex]
        is FinalSquareState) {
      return; // Cannot edit a square which has a number set from the beginning
    }

    // We want to clear the hint numbers when we assign a value to a square
    currentBoard.squareStates[currentBoard.currentIndex] =
        EditableSquareState(numberToChangeTo, const <int>[]);

    final boardStates = state.boardStates;
    boardStates[state.boardIndex] =
        BoardState(currentBoard.squareStates, currentBoard.currentIndex);

    emit(GameInitial(
        boardStates, state.solution, state.boardIndex, state.stopwatch));
  }

  void generateBoard(Random? random) {
    final board = generateRandomUniqueSolutionSudoku(random ?? Random());

    List<SquareState> squareStates =
        List.filled(81, FinalSquareState.invalid());

    for (int index = 0; index < 81; index++) {
      if (board[index] == 0) {
        squareStates[index] = const EditableSquareState(0, <int>[]);
      } else {
        squareStates[index] = FinalSquareState(board[index]);
      }
    }

    final solution = backtrackSolveSudoku(board);

    if (!solution) {
      throw StateError(
          "The sudoku library generated an unsolvable board, or the solving function has a bug in it.");
    }

    state.stopwatch.reset();
    emit(GameInitial([BoardState(squareStates, 0)], board, 0, state.stopwatch));
  }

  void almostSolveSudoku() {
    final currentBoard = state.boardStates[state.boardIndex];

    for (int index = 0; index < boardSize; index++) {
      if (currentBoard.squareStates[index] is FinalSquareState) {
        continue; // Cannot edit a square which has a number set from the beginning
      }

      currentBoard.squareStates[index] =
          EditableSquareState(state.solution[index], List.empty());
    }

    const int indexToLeaveBlank =
        42; // The answer to everything and the universe

    currentBoard.squareStates[indexToLeaveBlank] =
        const EditableSquareState(0, <int>[]);

    final boardStates = state.boardStates;
    boardStates[state.boardIndex] =
        BoardState(currentBoard.squareStates, currentBoard.currentIndex);

    emit(GameInitial(
        boardStates, state.solution, state.boardIndex, state.stopwatch));
  }
}
