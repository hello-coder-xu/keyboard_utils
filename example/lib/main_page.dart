import 'package:flutter/material.dart';
import 'package:keyboard_utils_example/input_page.dart';
import 'package:keyboard_utils_example/normal_page.dart';

class BarItemModel {
  String label;
  IconData iconData;

  BarItemModel(this.label, this.iconData);
}

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  int currentIndex = 0;

  List<BarItemModel> get barItems => [
        BarItemModel('home', Icons.home),
        BarItemModel('search', Icons.search),
        BarItemModel('collection', Icons.collections_outlined),
        BarItemModel('mine', Icons.people),
      ];

  double get tempSafeHeight => MediaQuery.of(context).padding.bottom;

  @override
  Widget build(BuildContext context) {
    bool isToInputPage = currentIndex == 0;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: Text('当前选中的下标：$currentIndex'),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: Text('当前底部安全距离：$tempSafeHeight'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return isToInputPage
                          ? const InputPage()
                          : const NormalPage();
                    },
                  ),
                );
              },
              child: Text('跳转到${isToInputPage ? "input" : "normal"}'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: barItems
            .map((e) =>
                BottomNavigationBarItem(icon: Icon(e.iconData), label: e.label))
            .toList(),
      ),
    );
  }
}
