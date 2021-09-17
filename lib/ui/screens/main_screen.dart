import 'package:chat_app/config/custom_color.dart';
import 'package:chat_app/config/custom_text_style.dart';
import 'package:chat_app/ui/pages/chats_page.dart';
import 'package:chat_app/ui/pages/more_page.dart';
import 'package:chat_app/utils/size_config.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      body: pages[currentTab],
      backgroundColor: Colors.white,
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar buildBottomNavigationBar() {
    return BottomNavigationBar(
        onTap: moveTab,
        currentIndex: currentTab,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.white,
        iconSize: 25,
        selectedItemColor: NeutralColor.active,
        unselectedItemColor: NeutralColor.active,
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
                    style: CustomTextStyle
                        .metaData3
                        .copyWith(fontSize: 14, fontFamily: "Lato"),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                    height: 4,
                    width: 4,
                    decoration: BoxDecoration(
                        color: NeutralColor.active, shape: BoxShape.circle),
                  )
                ],
              )
            : ImageIcon(AssetImage("assets/icons/$icon")),
        label: "");
  }
}
