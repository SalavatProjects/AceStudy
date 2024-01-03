import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/group_member.dart';

part 'group_participants_event.dart';
part 'group_participants_state.dart';

class GroupParticipantsBloc extends Bloc<GroupParticipantsEvent, GroupParticipantsState> {
  GroupParticipantsBloc() : super(GroupParticipantsInitial()) {
    on<GroupParticipantsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GroupParticipantsGettingReadyEvent>((event, emit) {
      emit(GroupParticipantsIsNotReady());
      emit(GroupParticipantsIsReady(participants: event.participants));
    },);
  }
}
