part of 'image_bloc.dart';

class ImageState extends Equatable {
  final String? dropValue;
  const ImageState(this.dropValue);

  @override
  List<Object> get props => [dropValue!];
}

class ImageEmpty extends ImageState {
  const ImageEmpty([String? dropValue]) : super(dropValue);
}

class ImageLoading extends ImageState {
  const ImageLoading([String? dropValue]) : super(dropValue);
}

class ImageLoaded extends ImageState {
  final String imageUrl;

  const ImageLoaded(this.imageUrl, [String? dropValue]) : super(dropValue);

  @override
  List<Object> get props => [imageUrl];
}

class ImageLoadEditted extends ImageState {
  final CroppedFile croppedFile;
  const ImageLoadEditted({
    String? dropValue,
    required this.croppedFile,
  }) : super(dropValue);

  @override
  List<Object> get props => [croppedFile];
}

class ImageError extends ImageState {
  final String message;

  const ImageError(this.message, [String? dropValue]) : super(dropValue);

  @override
  List<Object> get props => [message];
}

class ImageSuccess extends ImageState {
  final String message;

  const ImageSuccess(this.message, [String? dropValue]) : super(dropValue);

  @override
  List<Object> get props => [message];
}
