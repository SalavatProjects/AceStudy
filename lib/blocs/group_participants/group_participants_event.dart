part of 'group_participants_bloc.dart';

@immutable
sealed class GroupParticipantsEvent {}

class GroupParticipantsGettingReadyEvent extends GroupParticipantsEvent{
  List<GroupMember> participants;
  GroupParticipantsGettingReadyEvent({required this.participants});
}