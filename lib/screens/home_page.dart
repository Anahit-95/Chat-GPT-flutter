import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './bot_page.dart';
import './conversations_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
