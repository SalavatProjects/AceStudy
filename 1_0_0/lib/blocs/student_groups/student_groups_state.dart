part of 'student_groups_bloc.dart';

@immutable
sealed class StudentGroupsState {}

final class StudentGroupsInitial extends StudentGroupsState {}

final class StudentGroupsIsNotReady extends StudentGroupsState {}

final class StudentGroupsIsReady extends StudentGroupsState {}