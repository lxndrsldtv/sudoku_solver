import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver/models/sudoku_model.dart';

// class Solution {
//   double findMedianSortedArrays(List<int> nums1, List<int> nums2) {
//     nums1.addAll(nums2);
//     nums1.sort();
//     final summaryLength = nums1.length;
//     final middlePointIndex = summaryLength ~/ 2;
//     return summaryLength.isEven
//         ? (nums1[middlePointIndex - 1] + nums1[middlePointIndex]) / 2
//         : nums1[middlePointIndex].toDouble();
//   }
//
//   int maxScore(List<int> nums) {
//     List<int> localNums = List<int>.from(nums);
//     int indexOfFirstElement = 0;
//     int indexOfSecondElement = indexOfFirstElement + 1;
//     int iterationCount = 0;
//
//     void
//
//     localNums[0].gcd(localNums[1]);
//     return 0;
//   }
// }

void main() {
  test(
      'List of SudokuCells must be received from correct List<int> '
      'using extension function', () async {
    final cells = [1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4]
        .mapToSudokuCellModelList();
    expect(cells.length, 16);
  });

  test(
      'Mapping list of int to list of SudokuCellModels must throw exception, '
      'if incoming list is not correct', () async {
    expect([1, 2, 3, 4, 1].mapToSudokuCellModelList, throwsAssertionError);
  });

  // test('Median of two sorted arrays', () async {
  //   expect(Solution().findMedianSortedArrays([1, 3], [2]), 2.0);
  //   expect(Solution().findMedianSortedArrays([1, 2], [3, 4]), 2.5);
  //   expect(
  //       Solution().findMedianSortedArrays(
  //           [1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4],
  //           [1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4]),
  //       2.5);
  // });
  //
  // test('Max score', () async {
  //   expect(Solution().maxScore([1, 2]), 1);
  //   // expect(Solution().maxScore([1, 2]), 2.5);
  //   // expect(
  //   //     Solution().maxScore([1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4]),
  //   //     2.5);
  // });
}
