class SudokuCellDto {
  final int subgridIndex;
  final int subgridCellIndex;
  final int value;

  const SudokuCellDto({required this.subgridIndex, required this.subgridCellIndex, required this.value});

  @override
  String toString() {
    return '($subgridIndex:$subgridCellIndex:$value)';
  }
}
