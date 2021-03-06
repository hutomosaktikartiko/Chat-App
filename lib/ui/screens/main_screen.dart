import 'package:flutter/material.dart';

import '../../utils/size_config.dart';
import '../pages/chats_page.dart';
import '../pages/more_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 0;

  List<Widget> pages = [ChatsPage(), MorePage()];

  void moveTab(int index) {
    setState(() {
      currentTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Init Size Config
    SizeConfig().init(context);
    return Scaffold(
      body: pages[currentTab],
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
        onTap: moveTab,
        currentIndex: currentTab,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconSize: 25,
        selectedItemColor: Theme.of(context).primaryColorLight,
        unselectedItemColor: Theme.of(context).iconTheme.color,
        items: [
          buildBottomNavigationbarItem(
              icon: "icon_chat.png",
              isSelected: currentTab == 0,
              label: "Chats"),
          buildBottomNavigationbarItem(
              icon: "icon_more.png",
              isSelected: currentTab == 1,
              label: "More"),
        ]);
  }

  BottomNavigationBarItem buildBottomNavigationbarItem(
      {required String icon, required bool isSelected, required String label}) {
    return BottomNavigationBarItem(
        icon: (isSelected)
            ? Column(
                children: [
                  Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        ?.copyWith(fontSize: 14, fontFamily: "Lato"),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    height: 4,
                    width: 4,
                    decoration: BoxDecoration(
                        color: Theme.of(context).iconTheme.color, shape: BoxShape.circle),
                  )
                ],
              )
            : ImageIcon(AssetImage("assets/icons/$icon")),
        label: "");
  }
}
