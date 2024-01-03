import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../functions/from_json.dart';
import '../../functions/api.dart';
import '../../models/vocabulary.dart';
import '../../models/mistake_statistics.dart';
import '../../models/user.dart';

part 'user_statistics_event.dart';
part 'user_statistics_state.dart';

class UserStatisticsBloc extends Bloc<UserStatisticsEvent, UserStatisticsState> {
  UserStatisticsBloc() : super(UserStatisticsInitial()) {
    on<UserStatisticsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<UserStatisticsGettingReadyEvent>((event, emit) async {
      emit(UserStatisticsIsNotReady()); 
      User user = User();
      List<Map<String, dynamic>> statistics = FromJson.getVocabulariesMistakeStatistic(await Api.getUserMistakesStatistics(user.getId));
      // print(statistics[0]['mistake_statistics']);
      emit(UserStatisticsIsReady(statistics: statistics));
    },
    );
  }
}
