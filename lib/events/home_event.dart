import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateLocationEvent extends HomeEvent {}

class PlaceOrderEvent extends HomeEvent {}

class SelectTanksEvent extends HomeEvent {
  final int numberOfTanks;

  SelectTanksEvent(this.numberOfTanks);

  @override
  List<Object?> get props => [numberOfTanks];
}
