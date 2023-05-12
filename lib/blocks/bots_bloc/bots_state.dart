part of 'bots_bloc.dart';

abstract class BotsState extends Equatable {
  const BotsState();

  @override
  List<Object> get props => [];
}

class BotsLoading extends BotsState {}

class BotsLoaded extends BotsState {
  final List<Bot> bots;

  const BotsLoaded(this.bots);

  @override
  List<Object> get props => [bots];
}

class BotsError extends BotsState {
  final String message;

  const BotsError(this.message);

  @override
  List<Object> get props => [message];
}
