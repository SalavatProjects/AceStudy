import 'package:bloc/bloc.dart';
import 'package:flutter/physics.dart';
// import 'package:json_serializable/type_helper.dart';
import 'package:meta/meta.dart';

part 'student_groups_event.dart';
part 'student_groups_state.dart';

class StudentGroupsBloc extends Bloc<StudentGroupsEvent, StudentGroupsState> {
  StudentGroupsBloc() : super(StudentGroupsInitial()) {
    on<StudentGroupsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<StudentGroupsGettingReadyEvent>((event, emit) async {
      emit(StudentGroupsIsNotReady());

      emit(StudentGroupsIsReady());
    });
  }
}
