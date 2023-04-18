import 'package:flutter/material.dart';

import '../models/models_model.dart';
import '../services/api_services.dart';

class ModelsProvider with ChangeNotifier {
  List<ModelsModel> modelsList = [];

  // String currentModel = 'text-davinci-003';
  String currentModel = 'gpt-3.5-turbo-0301';

  List<ModelsModel> get getModelsList {
    return modelsList;
  }

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelsList = await ApiService.getModels();
    return modelsList;
  }
}
