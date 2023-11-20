part of 'train_bloc.dart';

@immutable
sealed class TrainEvent {}

final class TrainPageIsGettingReadyEvent extends TrainEvent{}
