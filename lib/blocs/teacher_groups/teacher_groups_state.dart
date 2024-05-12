part of 'teacher_groups_bloc.dart';

@immutable
sealed class TeacherGroupsState {}

final class TeacherGroupsInitial extends TeacherGroupsState {}

final class TeacherGroupsIsNotReady extends TeacherGroupsState {}

final class TeacherGroupsIsReady extends TeacherGroupsState {
  List<Group> groups;
  TeacherGroupsIsReady({required this.groups});
}
