import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../utils/postgres_conn.dart';

part 'voc_page_event.dart';
part 'voc_page_state.dart';

class VocPageBloc extends Bloc<VocPageEvent, VocPageState> {
  VocPageBloc() : super(VocPageInitial()) {
    on<VocPageEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<VocabulariesGettingReadyEvent>((event, emit) async {
      await Connect.open_connection();
      List vocs = await Connect.connection.mappedResultsQuery('SELECT id, name, icon, type, words_count FROM study_english.dictionary ' 'WHERE user_id = 1 ORDER BY updated_at DESC');
      // print(vocs[0]['dictionary']);
      return emit(VocabulariesIsReady(vocabularies: vocs));
    });
  }
}
