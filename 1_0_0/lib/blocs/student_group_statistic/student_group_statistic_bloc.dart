import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../functions/api.dart';
import '../../functions/from_json.dart';

part 'student_group_statistic_event.dart';
part 'student_group_statistic_state.dart';

class StudentGroupStatisticBloc extends Bloc<StudentGroupStatisticEvent, StudentGroupStatisticState> {
  StudentGroupStatisticBloc() : super(StudentGroupStatisticInitial()) {
    on<StudentGroupStatisticEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<StudentGroupStatisticGettingReadyEvent>((event, emit) async {
      emit(StudentGroupStatisticIsNotReady());

      List<Map<String, dynamic>> _statistics;
      _statistics = FromJson.getVocabulariesMistakeStatistic(await Api.getStudentStatisticByGroup(event.userId, event.groupId));
      // print(_statistics);

      emit(StudentGroupStatisticIsReady(statistics: _statistics));
    },);
  }
}
