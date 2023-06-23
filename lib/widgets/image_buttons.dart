import 'package:chat_gpt_api/blocks/image_bloc/image_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants/constants.dart';

class ImageButtons extends StatelessWidget {
  const ImageButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final imageBloc = BlocProvider.of<ImageBloc>(context);
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.download_for_offline_rounded,
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(8),
              backgroundColor: btnColor,
            ),
            onPressed: () async {
              imageBloc.add(DownloadImage(context: context));
              // await downloadImage();
            },
            label: const Text('Download'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              imageBloc.add(ImageEdit());
            },
            icon: const Icon(Icons.edit),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(8),
              backgroundColor: btnColor,
            ),
            label: const Text('Edit'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.share,
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(8),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () async {
              imageBloc.add(ShareImage());
            },
            label: const Text('Share'),
          ),
        ),
      ],
    );
  }
}
