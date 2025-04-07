import 'package:sudoku_solver/src/models/sudoku_cell_dto.dart';

// hard (seems)
// final List<int> sudokuHard = [
//    0, 0, 0,  3, 0, 7,  0, 0, 0,
//    0, 1, 0,  4, 0, 0,  6, 0, 0,
//    7, 0, 0,  0, 0, 0,  0, 9, 0,

//    9, 0, 0,  0, 0, 0,  5, 0, 7,
//    0, 7, 3,  1, 6, 0,  0, 0, 4,
//    0, 0, 0,  0, 0, 0,  0, 0, 6,

//    0, 8, 0,  0, 0, 1,  4, 0, 0,
//    0, 6, 0,  0, 7, 5,  0, 0, 0,
//    0, 0, 0,  0, 0, 0,  0, 0, 2
// ];

const List<SudokuCellDTO> cellDTOs = [
  SudokuCellDTO(subgridIndex: 0, subgridCellIndex: 4, value: 1),
  SudokuCellDTO(subgridIndex: 0, subgridCellIndex: 6, value: 7),
  SudokuCellDTO(subgridIndex: 1, subgridCellIndex: 0, value: 3),
  SudokuCellDTO(subgridIndex: 1, subgridCellIndex: 2, value: 7),
  SudokuCellDTO(subgridIndex: 1, subgridCellIndex: 3, value: 4),
  SudokuCellDTO(subgridIndex: 2, subgridCellIndex: 3, value: 6),
  SudokuCellDTO(subgridIndex: 2, subgridCellIndex: 7, value: 9),
  SudokuCellDTO(subgridIndex: 3, subgridCellIndex: 0, value: 9),
  SudokuCellDTO(subgridIndex: 3, subgridCellIndex: 4, value: 7),
  SudokuCellDTO(subgridIndex: 3, subgridCellIndex: 5, value: 3),
  SudokuCellDTO(subgridIndex: 4, subgridCellIndex: 3, value: 1),
  SudokuCellDTO(subgridIndex: 4, subgridCellIndex: 4, value: 6),
  SudokuCellDTO(subgridIndex: 5, subgridCellIndex: 0, value: 5),
  SudokuCellDTO(subgridIndex: 5, subgridCellIndex: 2, value: 7),
  SudokuCellDTO(subgridIndex: 5, subgridCellIndex: 5, value: 4),
  SudokuCellDTO(subgridIndex: 5, subgridCellIndex: 8, value: 6),
  SudokuCellDTO(subgridIndex: 6, subgridCellIndex: 1, value: 8),
  SudokuCellDTO(subgridIndex: 6, subgridCellIndex: 4, value: 6),
  SudokuCellDTO(subgridIndex: 7, subgridCellIndex: 2, value: 1),
  SudokuCellDTO(subgridIndex: 7, subgridCellIndex: 4, value: 7),
  SudokuCellDTO(subgridIndex: 7, subgridCellIndex: 5, value: 5),
  SudokuCellDTO(subgridIndex: 8, subgridCellIndex: 0, value: 4),
  SudokuCellDTO(subgridIndex: 8, subgridCellIndex: 8, value: 2),
];
