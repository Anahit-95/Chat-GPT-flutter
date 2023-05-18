part of 'image_bloc.dart';

abstract class ImageState extends Equatable {
  const ImageState();

  @override
  List<Object> get props => [];
}

class ImageEmpty extends ImageState {}

class ImageLoading extends ImageState {}

class ImageLoaded extends ImageState {
  final String imageUrl;

  const ImageLoaded(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class ImageError extends ImageState {
  final String message;

  const ImageError(this.message);

  @override
  List<Object> get props => [message];
}
