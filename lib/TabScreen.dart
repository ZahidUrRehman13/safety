import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:rabbit/Screens/HomeScreen.dart';
import 'Screens/TabCategoryScreen.dart';
import 'Screens/TabChannelScreen.dart';

final ValueNotifier selectedIndexGlobal = ValueNotifier(0);

class TabScreen extends StatefulWidget {
  TabScreen({super.key, this.pageIndex = 0});
  int pageIndex;

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  final GlobalKey<_TabScreenState> _bottomNavigationKey = GlobalKey();

  static final List<Widget> _widgetOptions = [
    const HomeScreen(),
    const TabCategoryScreen(),
    const TabChannelScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndexGlobal.value = index;
    });
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      switch (widget.pageIndex) {
        case 0:
          selectedIndexGlobal.value = 0;
          break;
        case 1:
          selectedIndexGlobal.value = 1;
          break;
        case 2:
          selectedIndexGlobal.value = 2;
          break;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[selectedIndexGlobal.value],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFd9d9ff),
        selectedItemColor: const Color(0xFFDAA520),
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        // type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndexGlobal.value,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            label: "Safety",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_work),
            label: "More",
          ),
        ],
      ),
    );
  }
}
