import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/models_model.dart';
import '../../services/api_services.dart';

part 'models_event.dart';
part 'models_state.dart';

class ModelsBloc extends Bloc<ModelsEvent, ModelsState> {
  List<ModelsModel> modelsList = [];
  String currentModel = 'gpt-3.5-turbo-0301';

  ModelsBloc() : super(ModelsLoading()) {
    on<FetchModels>(_fetchModels);
    on<SetCurrentModel>(_setCurrentModel);
  }

  Future<void> _fetchModels(
      FetchModels event, Emitter<ModelsState> emit) async {
    emit(ModelsLoading());
    if (modelsList.isEmpty) {
      try {
        modelsList = await ApiService.getModels();
        emit(ModelsLoaded(modelsList, currentModel));
      } catch (e) {
        emit(const ModelsError('Failed to fetch models'));
      }
    } else {
      emit(ModelsLoaded(modelsList, currentModel));
    }
  }

  void _setCurrentModel(SetCurrentModel event, Emitter<ModelsState> emit) {
    currentModel = event.newModel;
    emit(ModelsLoaded(modelsList, event.newModel));
  }
}
