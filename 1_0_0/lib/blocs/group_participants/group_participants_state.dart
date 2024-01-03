part of 'group_participants_bloc.dart';

@immutable
sealed class GroupParticipantsState {}

final class GroupParticipantsInitial extends GroupParticipantsState {}

final class GroupParticipantsIsNotReady extends GroupParticipantsState {}

final class GroupParticipantsIsReady extends GroupParticipantsState {
  List<GroupMember> participants;
  GroupParticipantsIsReady({required this.participants});
}