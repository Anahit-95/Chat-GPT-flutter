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
      elevation: 2,
      title: Text(title),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/');
          },
          child: Image.asset(AssetsManager.openaiLogo),
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
