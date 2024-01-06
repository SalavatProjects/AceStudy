import 'package:ace_study/functions/from_json.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/physics.dart';
import 'package:meta/meta.dart';

import '../../models/user.dart';
import '../../models/group.dart';
import '../../functions/api.dart';

part 'student_groups_event.dart';
part 'student_groups_state.dart';

class StudentGroupsBloc extends Bloc<StudentGroupsEvent, StudentGroupsState> {
  StudentGroupsBloc() : super(StudentGroupsInitial()) {
    on<StudentGroupsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<StudentGroupsGettingReadyEvent>((event, emit) async {
      emit(StudentGroupsIsNotReady());
      User user = User();
      List<Group> groups = FromJson.getGroups(await Api.getUserGroups(user.getId));
      emit(StudentGroupsIsReady(groups: groups));
    });
  }
}
