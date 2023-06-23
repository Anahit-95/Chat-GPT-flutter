// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'image_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();

  @override
  List<Object> get props => [];
}

class SetSizeValue extends ImageEvent {
  final String? dropValue;

  const SetSizeValue(this.dropValue);
  @override
  List<Object> get props => [dropValue!];
}

class ImageGenerate extends ImageEvent {
  final String text;
  final String size;

  const ImageGenerate({required this.text, required this.size});

  @override
  List<Object> get props => [text, size];
}

class ImageEdit extends ImageEvent {}

class ReturnNetworkImage extends ImageEvent {}

class ShareImage extends ImageEvent {}

class DownloadImage extends ImageEvent {
  BuildContext context;
  DownloadImage({
    required this.context,
  });
  @override
  List<Object> get props => [context];
}

class SetImage extends ImageEvent {}
