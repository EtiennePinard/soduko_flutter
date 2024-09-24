import 'package:flutter/material.dart';
import 'package:sudoku/cubit/board_cubit/game_cubit.dart';

final Color squareColor = Colors.white;
final Color cellStroke = const Color.fromRGBO(135, 135, 135, 1.0);
final Color borderStroke = Colors.black;
final borderSide = BorderSide(color: borderStroke, width: 2.0);
final selectedSquareBorder = Border.all(color: Colors.green, width: 5.0);
final unchangingDigitColor = Colors.black;
final userInputtedDigitsColor = Colors.blueGrey;
final hintDigitsColor = Colors.grey;

class Square extends StatelessWidget {
  final SquareState squareState;
  final int squareIndex;
  final int currentIndex;

  const Square(
      {super.key,
      required this.squareState,
      required this.squareIndex,
      required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    bool displaySquareValue =
        squareState is FinalSquareState || squareState.value != 0;
    final child = displaySquareValue ? squareValue() : hintDigits();

    return Stack(
      children: [
        SizedBox(width: double.infinity, height: double.infinity, child: child),
      ],
    );
  }

  Widget squareValue() {
    Border squareBorder =
        _getBorderFromIndex(squareIndex, borderSide, cellStroke);

    if (squareIndex == currentIndex) {
      squareBorder = selectedSquareBorder;
    }

    return Container(
      decoration: BoxDecoration(color: squareColor, border: squareBorder),
      padding: const EdgeInsets.all(10.0),
      child: FittedBox(
        child: Text(
          squareState.value != 0 ? squareState.value.toString() : "",
          style: TextStyle(
            color: squareState is FinalSquareState
                ? unchangingDigitColor
                : userInputtedDigitsColor,
          ),
        ),
      ),
    );
  }

  Widget hintDigits() {
    Border squareBorder =
        _getBorderFromIndex(squareIndex, borderSide, cellStroke);

    if (squareIndex == currentIndex) {
      squareBorder = selectedSquareBorder;
    }

    String hintDigitsToString = "";
    final hintDigits = (squareState as EditableSquareState).hintNumbers;
    for (int i = 0; i < hintDigits.length; i++) {
      hintDigitsToString += "${hintDigits[i]}";

      if ((i + 1) % 3 == 0) {
        hintDigitsToString += "\n";
      } else {
        hintDigitsToString += " ";
      }
    }

    return Container(
      decoration: BoxDecoration(color: squareColor, border: squareBorder),
      padding: const EdgeInsets.all(10.0),
      child: FittedBox(
        child: Text(
          hintDigitsToString.trim(),
          style: TextStyle(color: hintDigitsColor),
        ),
      ),
    );
  }
}

// A lot of copy and pasting but I don't care
Border _getBorderFromIndex(int index, BorderSide borderSide, Color cellStroke) {
  final cellBorder = BorderSide(color: cellStroke);
  if (index ~/ 9 % 3 == 0) {
    if (index % 3 == 0) {
      // |‾
      return Border(
          left: borderSide,
          top: borderSide,
          bottom: cellBorder,
          right: cellBorder);
    } else if (index % 3 == 2) {
      // ‾|
      return Border(
          right: borderSide,
          top: borderSide,
          bottom: cellBorder,
          left: cellBorder);
    } else {
      // ‾
      return Border(
          top: borderSide,
          bottom: cellBorder,
          left: cellBorder,
          right: cellBorder);
    }
  }

  if (index ~/ 9 % 3 == 1) {
    if (index % 3 == 0) {
      // | (left)
      return Border(
          left: borderSide,
          bottom: cellBorder,
          top: cellBorder,
          right: cellBorder);
    } else if (index % 3 == 2) {
      // | (right)
      return Border(
          right: borderSide,
          bottom: cellBorder,
          top: cellBorder,
          left: cellBorder);
    }
  }

  if (index ~/ 9 % 3 == 2) {
    if (index % 3 == 0) {
      // |_
      return Border(
          left: borderSide,
          bottom: borderSide,
          top: cellBorder,
          right: cellBorder);
    } else if (index % 3 == 2) {
      // _|
      return Border(
          right: borderSide,
          bottom: borderSide,
          top: cellBorder,
          left: cellBorder);
    } else {
      // ‾
      return Border(
          bottom: borderSide,
          top: cellBorder,
          left: cellBorder,
          right: cellBorder);
    }
  }
  return Border.all(color: cellStroke);
}
