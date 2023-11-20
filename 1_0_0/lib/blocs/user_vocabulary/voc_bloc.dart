import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
// import 'package:logger/logger.dart';

import '../../functions/api.dart';
import '../../functions/from_json.dart';
import '../../models/vocabulary.dart';

part 'voc_event.dart';
part 'voc_state.dart';

class VocPageBloc extends Bloc<VocPageEvent, VocPageState> {
  VocPageBloc() : super(VocPageInitial()) {
    on<VocPageEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<VocabulariesGettingReadyEvent>((event, emit) async {
      emit(VocabulariesIsNotReady());
      List<Vocabulary>? vocs = FromJson.getUserVocabularies(await Api.getJsonUserVocabulariesWords(1));
      // Logger().t(vocs);
      return emit(VocabulariesIsReady(vocabularies: vocs));
    });
  }
}
