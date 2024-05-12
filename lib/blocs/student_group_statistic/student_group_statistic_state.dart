part of 'student_group_statistic_bloc.dart';

@immutable
sealed class StudentGroupStatisticState {}

final class StudentGroupStatisticInitial extends StudentGroupStatisticState {}

final class StudentGroupStatisticIsNotReady extends StudentGroupStatisticState {}

final class StudentGroupStatisticIsReady extends StudentGroupStatisticState {
  List<Map<String, dynamic>> statistics;
  StudentGroupStatisticIsReady({required this.statistics});
}