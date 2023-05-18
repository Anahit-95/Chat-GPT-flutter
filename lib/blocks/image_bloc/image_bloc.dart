import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../services/api_services.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  String imageUrl = '';

  ImageBloc() : super(ImageEmpty()) {
    on<ImageGenerate>(_onImageGenerate);
  }

  Future<void> _onImageGenerate(
      ImageGenerate event, Emitter<ImageState> emit) async {
    emit(ImageLoading());
    try {
      imageUrl = await ApiService.generateImage(event.text, event.size);
      emit(ImageLoaded(imageUrl));
    } catch (error) {
      emit(ImageError(error.toString()));
    }
  }
}
