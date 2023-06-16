import 'package:flutter/material.dart';

import '../services/assets_manager.dart';
import '../services/services.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final String title;
  final bool showModels;
  final Future<void> Function()? onSave;
  final void Function()? onClear;
  const ChatAppBar({
    super.key,
    required this.title,
    this.showModels = false,
    this.onSave,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      title: Text(title),
      leading: Padding(
        padding: const EdgeInsets.only(
          left: 10.0,
          bottom: 5.0,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/');
          },
          child: CircleAvatar(
            backgroundImage: AssetImage(AssetsManager.openaiLogo),
            radius: 30,
          ),
        ),
      ),
      actions: [
        if (showModels)
          IconButton(
            onPressed: () async {
              await Services.showModalSheet(context: context);
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
          ),
        if (onSave != null)
          IconButton(
            onPressed: () async {
              await onSave!();
            },
            icon: const Icon(Icons.save_outlined),
          ),
        if (onClear != null)
          IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.delete_outline),
          ),
      ],
    );
  }
}
