import 'package:bloc/bloc.dart';
import 'package:flutter/physics.dart';
import 'package:meta/meta.dart';

import '../../models/vocabulary.dart';

part 'group_vocabularies_event.dart';
part 'group_vocabularies_state.dart';

class GroupVocabulariesBloc extends Bloc<GroupVocabulariesEvent, GroupVocabulariesState> {
  GroupVocabulariesBloc() : super(GroupVocabulariesInitial()) {
    on<GroupVocabulariesEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GroupVocabulariesGettingReadyEvent>((event, emit) {
      emit(GroupVocabulariesIsNotReady());
      emit(GroupVocabulariesIsReady(vocabularies: event.vocabularies));
    },);
  }
}
