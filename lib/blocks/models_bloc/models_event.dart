part of 'models_bloc.dart';

abstract class ModelsEvent extends Equatable {
  const ModelsEvent();

  @override
  List<Object> get props => [];
}

class FetchModels extends ModelsEvent {}

class SetCurrentModel extends ModelsEvent {
  final String newModel;

  const SetCurrentModel(this.newModel);

  @override
  List<Object> get props => [newModel];
}
