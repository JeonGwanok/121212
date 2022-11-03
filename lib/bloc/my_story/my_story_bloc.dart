import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc.dart';

class MyStoryBloc extends Bloc<MyStoryEvent, MyStoryState> {
  MyStoryBloc() : super(MyStoryLoading());

  @override
  Stream<MyStoryState> mapEventToState(event) async* {
     if (event is MyStoryUpdate) {
      yield* mapMyStoryUpdateToState(event);
    }
  }

  Stream<MyStoryState> mapMyStoryUpdateToState(MyStoryUpdate event) async* {
    try {
      yield MyStoryLoaded(
        updateAt: DateTime.now(),
      );
    } catch (_) {}
  }
}
