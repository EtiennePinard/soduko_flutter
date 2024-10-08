part of 'game_cubit.dart';

@immutable
abstract class GameState {
  final List<BoardState> boardStates;
  final int boardIndex;
  final List<int> solution;
  final Stopwatch stopwatch;
  final Timer timer;

  const GameState(this.boardStates, this.solution, this.boardIndex,
      this.stopwatch, this.timer);
}

@immutable
final class BoardState {
  final List<SquareState> squareStates;
  final int currentIndex;

  const BoardState(this.squareStates, this.currentIndex);
}

@immutable
abstract class SquareState extends Equatable {
  final int value;

  const SquareState._(this.value);
}

@immutable
final class FinalSquareState extends SquareState {
  const FinalSquareState(int value) : super._(value);

  static FinalSquareState invalid() => const FinalSquareState(-1);

  @override
  List<Object?> get props => [super.value];
}

@immutable
final class EditableSquareState extends SquareState {
  // Add the hint numbers later
  final List<int> hintNumbers;

  const EditableSquareState(int value, this.hintNumbers) : super._(value);

  @override
  List<Object?> get props => [super.value];
}

class GameInitial extends GameState {
  const GameInitial(super.boardStates, super.solution, super.boardIndex,
      super.stopwatch, super.timer);

  static GameInitial initial() => GameInitial(List.empty(), List.empty(), -1,
      Stopwatch(), Timer(Duration.zero, () => ()));
}
