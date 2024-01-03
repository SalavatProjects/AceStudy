part of 'user_statistics_bloc.dart';

@immutable
sealed class UserStatisticsState {}

final class UserStatisticsInitial extends UserStatisticsState {}

class UserStatisticsIsNotReady extends UserStatisticsState{}

class UserStatisticsIsReady extends UserStatisticsState{
  List<Map<String, dynamic>> statistics;
  UserStatisticsIsReady({required this.statistics});
}