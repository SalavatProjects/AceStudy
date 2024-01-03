import 'package:bloc/bloc.dart';
import 'package:flutter/physics.dart';
import 'package:meta/meta.dart';

import '../../models/user.dart';
import '../../models/group.dart';
import '../../functions/api.dart';
import '../../functions/from_json.dart';

part 'teacher_groups_event.dart';
part 'teacher_groups_state.dart';

class TeacherGroupsBloc extends Bloc<TeacherGroupsEvent, TeacherGroupsState> {
  TeacherGroupsBloc() : super(TeacherGroupsInitial()) {
    on<TeacherGroupsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<TeacherGroupsGettingReadyEvent>((event, emit) async {
      emit(TeacherGroupsIsNotReady());
      User user = User();
      List<Group> groups = FromJson.getGroups(await Api.getGroups(user.getId));
      emit(TeacherGroupsIsReady(groups: groups));
    },);
  }
}
