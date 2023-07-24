import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../api.dart';
import '../data.dart';

part 'voc_page_event.dart';
part 'voc_page_state.dart';

class VocPageBloc extends Bloc<VocPageEvent, VocPageState> {
  VocPageBloc() : super(VocPageInitial()) {
    on<VocPageEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<VocabulariesGettingReadyEvent>((event, emit) async {
      await open_connection();
      List vocs = await connection.mappedResultsQuery('SELECT id, name, icon, type, words_count FROM test.dictionary ' +
      'WHERE user_id = 4');
      vocabularies = Vocabularies.fromJson(vocs);
      print(vocabularies);
      emit(VocabulariesIsReady());
    });
  }
}
