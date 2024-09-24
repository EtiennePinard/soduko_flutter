import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const shortcuts = <ShortcutActivator, Intent>{
  SingleActivator(LogicalKeyboardKey.arrowDown):
      ArrowIntent(LogicalKeyboardKey.arrowDown),
  SingleActivator(LogicalKeyboardKey.arrowUp):
      ArrowIntent(LogicalKeyboardKey.arrowUp),
  SingleActivator(LogicalKeyboardKey.arrowLeft):
      ArrowIntent(LogicalKeyboardKey.arrowLeft),
  SingleActivator(LogicalKeyboardKey.arrowRight):
      ArrowIntent(LogicalKeyboardKey.arrowRight),
  SingleActivator(LogicalKeyboardKey.digit0): DigitIntent(0),
  SingleActivator(LogicalKeyboardKey.digit1): DigitIntent(1),
  SingleActivator(LogicalKeyboardKey.digit2): DigitIntent(2),
  SingleActivator(LogicalKeyboardKey.digit3): DigitIntent(3),
  SingleActivator(LogicalKeyboardKey.digit4): DigitIntent(4),
  SingleActivator(LogicalKeyboardKey.digit5): DigitIntent(5),
  SingleActivator(LogicalKeyboardKey.digit6): DigitIntent(6),
  SingleActivator(LogicalKeyboardKey.digit7): DigitIntent(7),
  SingleActivator(LogicalKeyboardKey.digit8): DigitIntent(8),
  SingleActivator(LogicalKeyboardKey.digit9): DigitIntent(9),
  SingleActivator(LogicalKeyboardKey.backspace): BackSpaceIntent(),
  SingleActivator(LogicalKeyboardKey.digit1, shift: true): HintDigitIntent(1),
  SingleActivator(LogicalKeyboardKey.digit2, shift: true): HintDigitIntent(2),
  SingleActivator(LogicalKeyboardKey.digit3, shift: true): HintDigitIntent(3),
  SingleActivator(LogicalKeyboardKey.digit4, shift: true): HintDigitIntent(4),
  SingleActivator(LogicalKeyboardKey.digit5, shift: true): HintDigitIntent(5),
  SingleActivator(LogicalKeyboardKey.digit6, shift: true): HintDigitIntent(6),
  SingleActivator(LogicalKeyboardKey.digit7, shift: true): HintDigitIntent(7),
  SingleActivator(LogicalKeyboardKey.digit8, shift: true): HintDigitIntent(8),
  SingleActivator(LogicalKeyboardKey.digit9, shift: true): HintDigitIntent(9),
};

class ArrowIntent extends Intent {
  final LogicalKeyboardKey arrow;

  const ArrowIntent(this.arrow);
}

class DigitIntent extends Intent {
  final int digitInputted;

  const DigitIntent(this.digitInputted);
}

class BackSpaceIntent extends Intent {
  const BackSpaceIntent();
}

class HintDigitIntent extends Intent {
  final int digitInputted;

  const HintDigitIntent(this.digitInputted);
}