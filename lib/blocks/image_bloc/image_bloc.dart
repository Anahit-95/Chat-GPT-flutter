import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/constants.dart';
import '../../services/api_services.dart';

part 'image_event.dart';
part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  String imageUrl = '';
  CroppedFile? croppedImageFile;
  String? dropValue;

  ImageBloc() : super(const ImageEmpty('')) {
    on<SetSizeValue>(_onSetSizeValue);
    on<ImageGenerate>(_onImageGenerate);
    on<ImageEdit>(_onImageEdit);
    on<ReturnNetworkImage>(_onReturnNetworkImage);
    on<ShareImage>(_onShareImage);
    on<DownloadImage>(_onDownloadImage);
    on<SetImage>(_onSetImage);
  }

  void _onSetSizeValue(SetSizeValue event, Emitter<ImageState> emit) {
    dropValue = event.dropValue;
    if (imageUrl.isEmpty && croppedImageFile == null) {
      emit(ImageEmpty(dropValue));
    } else {
      emit(ImageState(dropValue));
    }
  }

  Future<void> _onImageGenerate(
      ImageGenerate event, Emitter<ImageState> emit) async {
    emit(ImageLoading(event.size));
    try {
      imageUrl = await ApiService.generateImage(event.text, event.size);
      emit(ImageLoaded(
        imageUrl,
      ));
    } catch (error) {
      emit(ImageError(
        error.toString(),
      ));
    }
  }

  Future<void> _cropImage(path) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: path,
      compressQuality: 90,
      compressFormat: ImageCompressFormat.png,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Image Editor",
          toolbarColor: btnColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: "Image Editor",
        ),
      ],
    );
    if (croppedFile != null) {
      croppedImageFile = croppedFile;
    }
  }

  FutureOr<void> _onImageEdit(ImageEdit event, Emitter<ImageState> emit) async {
    // emit(ImageLoading());
    try {
      if (croppedImageFile == null) {
        CachedNetworkImageProvider imageProvider =
            CachedNetworkImageProvider(imageUrl);
        imageProvider.resolve(const ImageConfiguration());
        ImageStream imageStream =
            imageProvider.resolve(const ImageConfiguration());
        Completer<Uint8List> completer = Completer();
        imageStream.addListener(
            ImageStreamListener((imageInfo, synchronousCall) async {
          ByteData? byteData =
              await imageInfo.image.toByteData(format: ImageByteFormat.png);
          Uint8List pngBytes = byteData!.buffer.asUint8List();
          completer.complete(pngBytes);
        }));
        Uint8List pngBytes = await completer.future;

        final directory = await getTemporaryDirectory();
        const filename = 'temp_image.png';
        final file = await File('${directory.path}/$filename').create();
        await file.writeAsBytes(pngBytes);
        await _cropImage(file.path);
      } else {
        await _cropImage(croppedImageFile!.path);
      }
      if (croppedImageFile == null) {
        emit(ImageLoaded(imageUrl));
      } else {
        emit(ImageLoadEditted(croppedFile: croppedImageFile!));
      }
    } catch (e) {
      emit(ImageError('Permission denied.'));
    }
  }

  FutureOr<void> _onReturnNetworkImage(
      ReturnNetworkImage event, Emitter<ImageState> emit) {
    croppedImageFile = null;
    imageCache.clear;
    emit(ImageLoaded(
      imageUrl,
    ));
  }

  FutureOr<void> _onShareImage(
      ShareImage event, Emitter<ImageState> emit) async {
    try {
      if (croppedImageFile == null) {
        CachedNetworkImageProvider imageProvider =
            CachedNetworkImageProvider(imageUrl);
        imageProvider.resolve(const ImageConfiguration());
        ImageStream imageStream =
            imageProvider.resolve(const ImageConfiguration());
        Completer<Uint8List> completer = Completer();
        imageStream.addListener(
            ImageStreamListener((imageInfo, synchronousCall) async {
          ByteData? byteData =
              await imageInfo.image.toByteData(format: ImageByteFormat.png);
          Uint8List pngBytes = byteData!.buffer.asUint8List();
          completer.complete(pngBytes);
        }));
        Uint8List pngBytes = await completer.future;

        final directory = await getTemporaryDirectory();
        const filename = 'shared_image.png';
        final file = await File('${directory.path}/$filename').create();
        await file.writeAsBytes(pngBytes);
        final xFile = XFile(file.path);
        await Share.shareXFiles([xFile], text: 'AI generated Image');
        emit(ImageSuccess('Image shared.'));
      } else {
        final xFile = XFile(croppedImageFile!.path);
        await Share.shareXFiles([xFile], text: 'AI generated Image');
        emit(ImageSuccess('Image shared.'));
      }
    } catch (e) {
      log('Failed to take a screenshot');
      emit(ImageError('Failed to share image.'));
      // Services.errorSnackBar(
      //   context: context,
      //   errorMessage: 'Failed to take a screenshot.',
      // );
    }
  }

  FutureOr<void> _onDownloadImage(
      DownloadImage event, Emitter<ImageState> emit) async {
    var result = await Permission.storage.request();
    if (result.isGranted) {
      try {
        const foldername = 'AI Image';
        if (croppedImageFile == null) {
          final directory = await getTemporaryDirectory();
          final String appDocPath = directory.path;
          final String folderPath = '$appDocPath/$foldername';
          final filename = "${DateTime.now().millisecondsSinceEpoch}.png";
          if (!(await Directory(folderPath).exists())) {
            await Directory(folderPath).create(recursive: true);
          }
          final Completer<void> completer = Completer<void>();
          final imageProvider = CachedNetworkImageProvider(imageUrl);
          final imageStream = imageProvider
              .resolve(createLocalImageConfiguration(event.context));
          imageStream.addListener(ImageStreamListener((imageInfo, _) async {
            final ByteData? bytes =
                await imageInfo.image.toByteData(format: ImageByteFormat.png);
            final Uint8List pngBytes = bytes!.buffer.asUint8List();
            File savedFile = File('$folderPath/$filename');
            await savedFile.writeAsBytes(pngBytes);
            await GallerySaver.saveImage(savedFile.path, albumName: foldername);
            completer.complete();
          }));
          // Future.delayed(Duration.zero, () {
          //   Services.confirmSnackBar(
          //     context: event.context,
          //     message: 'Downloaded to $folderPath',
          //   );
          // });
          emit(ImageSuccess('Downloaded to $folderPath'));

          await completer.future;
        } else {
          await GallerySaver.saveImage(croppedImageFile!.path,
              albumName: foldername);
          emit(ImageSuccess('Downloaded to ${croppedImageFile!.path}'));
          // Future.delayed(Duration.zero, () {
          //   Services.confirmSnackBar(
          //     context: event.context,
          //     message: 'Downloaded to ${croppedImageFile!.path}',
          //   );
          // });
        }
      } catch (e) {
        emit(ImageError('Failed to download.'));
        // Services.errorSnackBar(
        //   context: context,
        //   errorMessage: 'Failed to download.',
        // );
      }
    } else {
      emit(ImageError('Permission denied.'));
      // Services.errorSnackBar(
      //   context: context,
      //   errorMessage: 'Permission denied.',
      // );
    }
  }

  FutureOr<void> _onSetImage(SetImage event, Emitter<ImageState> emit) {
    imageUrl =
        'https://oaidalleapiprodscus.blob.core.windows.net/private/org-qPD56hjUC1p5xB0qKd3BGgK3/user-lcaYguhJf9kc6GsW8HnXYaCT/img-dNe7VRrXIGDAinJpzVh5DfE8.png?st=2023-06-22T12%3A23%3A33Z&se=2023-06-22T14%3A23%3A33Z&sp=r&sv=2021-08-06&sr=b&rscd=inline&rsct=image/png&skoid=6aaadede-4fb3-4698-a8f6-684d7786b067&sktid=a48cca56-e6da-484e-a814-9c849652bcb3&skt=2023-06-21T23%3A49%3A27Z&ske=2023-06-22T23%3A49%3A27Z&sks=b&skv=2021-08-06&sig=8ThKl%2BgCEeqx9LcQ3IWoP9KDMGQNNRVQ%2B%2BZbasrUpZk%3D';
    emit(ImageLoaded(imageUrl));
  }
}
