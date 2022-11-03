import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  CommunityBloc() : super(CommunityLoading());

  @override
  Stream<CommunityState> mapEventToState(event) async* {
     if (event is CommunityUpdate) {
      yield* mapCommunityUpdateToState(event);
    }
  }

  Stream<CommunityState> mapCommunityUpdateToState(CommunityUpdate event) async* {
    try {
      yield CommunityLoaded(
        updateAt: DateTime.now(),
      );
    } catch (_) {}
  }
}
