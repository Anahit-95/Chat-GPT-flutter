import 'package:chat_gpt_api/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/assets_manager.dart';
import '../widgets/bot_list.dart';
import '../widgets/conversation_list.dart';

class HomePageDraft extends StatefulWidget {
  const HomePageDraft({super.key});

  @override
  State<HomePageDraft> createState() => _HomePageDraftState();
}

class _HomePageDraftState extends State<HomePageDraft> {
  int _selectedPageIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: const <Widget>[BotPage(), ConversationListPage()],
    );
  }

  void pageChanged(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _selectedPageIndex = index;
      pageController.animateToPage(
        (index),
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildPageView(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -0.5),
              color: Colors.indigo.withOpacity(.1),
              spreadRadius: 0.5,
              blurRadius: 4,
            ),
          ],
        ),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          // backgroundColor: scaffoldBackgroundColor,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).primaryColor.withOpacity(.4),
          currentIndex: _selectedPageIndex,
          onTap: (index) {
            bottomTapped(index);
          },

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Assistants',
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.chat_bubble_2),
              label: 'Conversations',
            )
          ],
        ),
      ),
    );
  }
}

class BotPage extends StatelessWidget {
  const BotPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),
                ListTile(
                  title: Text(
                    'Hi Friend!',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Choose bot to have conversation',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Colors.white54),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.indigo,
                    radius: 30,
                    backgroundImage: AssetImage(AssetsManager.botPicture),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const BotList(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class ConversationListPage extends StatelessWidget {
  const ConversationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            // borderRadius: const BorderRadius.only(
            //   bottomRight: Radius.circular(50),
            // ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              ListTile(
                title: Text(
                  'My conversations',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(color: Colors.white),
                ),
                subtitle: Text(
                  'Continue your conversations',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: Colors.white54),
                ),
                trailing: CircleAvatar(
                  backgroundColor: Colors.indigo,
                  radius: 30,
                  backgroundImage: AssetImage(AssetsManager.botPicture),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        // SizedBox(height: 20),
        const ConversationList(),
      ],
    );
  }
}
