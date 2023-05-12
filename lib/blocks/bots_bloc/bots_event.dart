part of 'bots_bloc.dart';

abstract class BotsEvent extends Equatable {
  const BotsEvent();

  @override
  List<Object> get props => [];
}

class FetchBots extends BotsEvent {}

class AddBot extends BotsEvent {
  final Bot bot;

  const AddBot(this.bot);

  @override
  List<Object> get props => [bot];
}
