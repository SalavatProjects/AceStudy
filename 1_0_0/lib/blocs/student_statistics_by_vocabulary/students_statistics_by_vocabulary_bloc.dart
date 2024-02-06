import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/vocabulary.dart';
import '../../functions/api.dart';
import '../../functions/from_json.dart';

part 'students_statistics_by_vocabulary_event.dart';
part 'students_statistics_by_vocabulary_state.dart';

class StudentsStatisticsByVocabularyBloc extends Bloc<StudentsStatisticsByVocabularyEvent, StudentsStatisticsByVocabularyState> {
  StudentsStatisticsByVocabularyBloc() : super(StudentsStatisticsByVocabularyInitial()) {
    on<StudentsStatisticsByVocabularyEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<StudentsStatisticsByVocabularyGettingReadyEvent>((event, emit) async {
      emit(StudentsStatisticsByVocabularyIsNotReady());
      Map statistics;
      /* print(event.groupId);
      print(event.vocabulary.getId); */
      // print(await Api.getStudentsStatisticsByVocabulary(event.groupId, event.vocabulary.getId));
      statistics = FromJson.getStudentsStatisticsByVocabularyFromJson(await Api.getStudentsStatisticsByVocabulary(event.groupId, event.vocabulary.getId));
      // print(statistics);

      emit(StudentsStatisticsByVocabularyIsReady(statistics: statistics));
    },);
  }
}
