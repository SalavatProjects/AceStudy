part of 'student_group_statistic_bloc.dart';

@immutable
sealed class StudentGroupStatisticEvent {}

class StudentGroupStatisticGettingReadyEvent extends StudentGroupStatisticEvent {
  int userId;
  int groupId;
  StudentGroupStatisticGettingReadyEvent({
    required this.userId,
    required this.groupId
  });
}