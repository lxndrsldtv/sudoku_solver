import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

//------------------------------------------------------------------------------
class SomeEvent {}

class SomeEventOne extends SomeEvent {}

class SomeEventTwo extends SomeEvent {}

//------------------------------------------------------------------------------
class SomeState {}

class SomeStateOne extends SomeState {}

class SomeStateTwo extends SomeState {}

//------------------------------------------------------------------------------
class SomeBloc extends Bloc<SomeEvent, SomeState> {
  SomeBloc() : super(SomeState()) {
    on<SomeEventOne>(_onSomeEventOne);
    on<SomeEventTwo>(_onSomeEventTwo);
  }

  _onSomeEventOne(SomeEventOne event, Emitter<SomeState> emit) {
    emit(SomeStateOne());
    add(SomeEventTwo());
  }

  _onSomeEventTwo(SomeEventTwo event, Emitter<SomeState> emit) {
    emit(SomeStateTwo());
  }
}

//------------------------------------------------------------------------------
void main() {
  group('SomeBloc', () {
    setUp(() => null);

    test('description', () async {
      final blocA = SomeBloc();
      blocA.stream.listen(print);
      blocA.add(SomeEventOne());
      await Future.delayed(Duration.zero);
      blocA.close();
    });

    test('Async with Futures', () async {
      print('1');
      Future(() => print('4'));
      Future.microtask(() => print('3.0'));
      Future(() => print('5'));
      Future.value('3.1').then((value) => print(value));
      scheduleMicrotask(() => print('3.2'));
      print('2');
    });
  });
}
