part of 'teacher_groups_bloc.dart';

@immutable
sealed class TeacherGroupsEvent {}

class TeacherGroupsGettingReadyEvent extends TeacherGroupsEvent {}