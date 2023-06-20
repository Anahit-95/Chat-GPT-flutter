import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../blocks/bots_bloc/bots_bloc.dart';
import '../blocks/conversations_bloc/conversation_list_bloc.dart';
import '../models/bot_model.dart';
import './conversation_item.dart';

class ConversationList extends StatelessWidget {
  const ConversationList({super.key});

  Bot getBot(String type, List<Bot> botList) {
    Bot currentBot = botList.firstWhere((bot) => bot.title == type);
    return currentBot;
  }

  @override
  Widget build(BuildContext context) {
    final botsBloc = BlocProvider.of<BotsBloc>(context);
    final conversationsBloc = BlocProvider.of<ConversationListBloc>(context);
    return Container(
      color: Theme.of(context).primaryColor,
      child: Container(
        // color: Colors.white,
        decoration: const BoxDecoration(
          color: Colors.white,
          // color: scaffoldBackgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(80),
          ),
        ),
        child: BlocBuilder<ConversationListBloc, ConversationListState>(
          builder: (context, state) {
            if (state is ConversationListLoading) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: SpinKitFadingCircle(
                    color: Theme.of(context).primaryColor.withOpacity(.8),
                    size: 50,
                  ),
                ),
              );
            }
            if (state is ConversationListError) {
              return Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 25,
              ),
              itemCount: conversationsBloc.conversations.length,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                Bot currentBot = getBot(
                  conversationsBloc.conversations[index].type,
                  botsBloc.botList,
                );
                return ConversationItem(
                  conversation: conversationsBloc.conversations[index],
                  currentBot: currentBot,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
