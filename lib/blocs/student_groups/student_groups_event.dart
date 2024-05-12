part of 'student_groups_bloc.dart';

@immutable
sealed class StudentGroupsEvent {}

class StudentGroupsGettingReadyEvent extends StudentGroupsEvent {}