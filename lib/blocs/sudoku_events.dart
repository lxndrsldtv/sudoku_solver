import 'package:cross_file/cross_file.dart';
import 'package:image/image.dart';

abstract class SudokuEvent {}

class SudokuStarted extends SudokuEvent {}

class SudokuImageRenderingDone extends SudokuEvent {}

class SudokuCellsRepositioningDone extends SudokuEvent {}

class SudokuReplaceCellValueRequested extends SudokuEvent {
  SudokuReplaceCellValueRequested({required this.index, required this.value});

  final int index;
  final int value;
}

class SudokuSelectImagePressed extends SudokuEvent {}

class SudokuCalculatePressed extends SudokuEvent {}

class SudokuImageHidden extends SudokuEvent {}

class SudokuImagePickerStarted extends SudokuEvent {}

class SudokuImageSelected extends SudokuEvent {
  final Image image;

  SudokuImageSelected({required this.image});
}

class SudokuImageSelectionDone extends SudokuEvent {
  final XFile? imageFile;

  SudokuImageSelectionDone({this.imageFile});
}