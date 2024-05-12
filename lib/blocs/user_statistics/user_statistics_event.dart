part of 'user_statistics_bloc.dart';

@immutable
sealed class UserStatisticsEvent {}

class UserStatisticsGettingReadyEvent extends UserStatisticsEvent{}