import 'package:chat_gpt_api/blocks/conversations_bloc/conversation_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../blocks/bots_bloc/bots_bloc.dart';
import '../blocks/chat_bloc/chat_bloc.dart';
import '../constants/constants.dart';
import '../models/bot_model.dart';
import '../providers/bots_provider.dart';
import '../services/assets_manager.dart';
import '../services/db_services.dart';
import '../widgets/bot_widget.dart';
import '../widgets/text_widget.dart';
import 'conversation_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<ConversationListBloc>(context).add(FetchConversations());
  }

  Bot getBot(String type, List<Bot> botList) {
    Bot currentBot = botList.firstWhere((bot) => bot.title == type);
    return currentBot;
  }

  @override
  Widget build(BuildContext context) {
    final botsBloc = BlocProvider.of<BotsBloc>(context);
    final conversationsBloc = BlocProvider.of<ConversationListBloc>(context);
    // print(conversationsBloc.conversations);
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text('Home'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.openaiLogo),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const Text(
                'Choose bot to have conversation with',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<BotsBloc, BotsState>(
                builder: (context, state) {
                  if (state is BotsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is BotsLoaded) {
                    return Row(
                      children: [
                        Flexible(
                          child: GridView.builder(
                            itemCount: state.bots.length,
                            padding: const EdgeInsets.only(bottom: 20),
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 5 / 3,
                            ),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => BotWidget(
                              bot: state.bots[index],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  if (state is BotsError) {
                    return Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'My Conversations',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child:
                      BlocBuilder<ConversationListBloc, ConversationListState>(
                    builder: (context, state) {
                      if (state is ConversationListLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is ConversationListError) {
                        return Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        );
                      }
                      return ListView.builder(
                          itemCount: conversationsBloc.conversations.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            Bot currentBot = getBot(
                              conversationsBloc.conversations[index].type,
                              botsBloc.botList,
                            );
                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 81, 103, 230),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider(
                                            create: (context) =>
                                                ChatBloc(bot: currentBot),
                                            child: ConversationScreen(
                                              conversationId: conversationsBloc
                                                  .conversations[index].id,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    trailing: InkWell(
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Are you sure?'),
                                              content: state
                                                      is ConversationListLoading
                                                  ? const CircularProgressIndicator(
                                                      color: btnColor,
                                                    )
                                                  : const Text(
                                                      'Are you sure, you want to delete this conversation?'),
                                              actions: [
                                                TextButton(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: btnColor,
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child:
                                                        const Text('Cancel')),
                                                ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: btnColor,
                                                    ),
                                                    onPressed: () async {
                                                      conversationsBloc.add(
                                                        DeleteConversation(
                                                          id: conversationsBloc
                                                              .conversations[
                                                                  index]
                                                              .id,
                                                        ),
                                                      );
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text("Ok")),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Icon(
                                        Icons.highlight_remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: currentBot.color,
                                      child: Icon(
                                        currentBot.iconData,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      conversationsBloc
                                          .conversations[index].title,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    subtitle: Text(conversationsBloc
                                        .conversations[index].type),
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            );
                          });
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
