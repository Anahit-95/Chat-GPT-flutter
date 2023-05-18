part of 'models_bloc.dart';

abstract class ModelsState extends Equatable {
  const ModelsState();

  @override
  List<Object> get props => [];
}

class ModelsLoading extends ModelsState {}

class ModelsLoaded extends ModelsState {
  final List<ModelsModel> modelsList;
  final String currentModel;

  const ModelsLoaded(this.modelsList, this.currentModel);

  @override
  List<Object> get props => [modelsList];
}

class ModelsError extends ModelsState {
  final String message;

  const ModelsError(this.message);

  @override
  List<Object> get props => [message];
}
