import 'package:face_book_clone/core/colors/app_colors.dart';
import 'package:face_book_clone/features/home/ui/add_page.dart';
import 'package:face_book_clone/features/home/ui/home_page.dart';
import 'package:face_book_clone/features/home/ui/profile_page.dart';
import 'package:face_book_clone/features/home/ui/search_page.dart';
import 'package:flutter/material.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {
  int currentIndex = 0;
  PageController pageCon = PageController();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: PageView(
        controller: pageCon,
        children: [HomePage(), AddPage(), SearchPostsPage(), ProfilePage()],
        onPageChanged: (value) => setState(() {
          currentIndex = value;
        }),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) => setState(() {
          currentIndex = value;
          pageCon.jumpToPage(value);
        }),
        elevation: 0,
        backgroundColor: kWhiteColor.withOpacity(0.8),
        selectedIndex: currentIndex,
        indicatorColor: kPrimaryColor.withOpacity(0.2),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: "Home",
            selectedIcon: Icon(Icons.home, color: kPrimaryColor),
          ),
          NavigationDestination(
            icon: Icon(Icons.add),
            label: "add",
            selectedIcon: Icon(Icons.add, color: kPrimaryColor),
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: "Search",
            selectedIcon: Icon(Icons.search, color: kPrimaryColor),
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: "Profile",
            selectedIcon: Icon(Icons.person, color: kPrimaryColor),
          ),
        ],
      ),
    );
  }
}
