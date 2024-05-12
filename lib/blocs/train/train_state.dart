part of 'train_bloc.dart';

@immutable
sealed class TrainState {}

final class TrainInitial extends TrainState {}

final class TrainIsReady extends TrainState {
  
}