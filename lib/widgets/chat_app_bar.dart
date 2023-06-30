import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocks/conversations_bloc/conversation_list_bloc.dart';
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
            backgroundColor: Colors.indigo,
            // backgroundImage: AssetImage(AssetsManager.botPicture),
            radius: 30,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.asset(AssetsManager.botPicture),
            ),
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
          MultiBlocListener(
            listeners: [
              BlocListener<ConversationListBloc, ConversationListState>(
                listener: (context, state) {
                  if (state is ConversationCreated) {
                    Future.delayed(Duration.zero, () {
                      // Navigator.of(context).pushNamed('/');
                      Services.confirmSnackBar(
                        context: context,
                        message: "Conversation created succesfully.",
                      );
                      print('worked from Bloc listener');
                    });
                  }
                  if (state is ConversationListError) {
                    Future.delayed(Duration.zero, () {
                      Services.errorSnackBar(
                        context: context,
                        errorMessage: state.message,
                      );
                    });
                  }
                },
              ),
            ],
            child: IconButton(
              onPressed: () async {
                await onSave!();
              },
              icon: const Icon(Icons.save_outlined),
            ),
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
