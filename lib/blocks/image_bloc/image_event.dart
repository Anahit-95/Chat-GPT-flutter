part of 'image_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class ImageGenerate extends ImageEvent {
  final String text;
  final String size;

  const ImageGenerate({required this.text, required this.size});

  @override
  List<Object> get props => [text, size];
}
