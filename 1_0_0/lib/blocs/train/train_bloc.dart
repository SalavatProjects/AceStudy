import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'train_event.dart';
part 'train_state.dart';

class TrainBloc extends Bloc<TrainEvent, TrainState> {
  TrainBloc() : super(TrainInitial()) {
    on<TrainEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<TrainPageIsGettingReadyEvent>((event, emit) async {
      
      emit(TrainIsReady());
    },);
  }
}
