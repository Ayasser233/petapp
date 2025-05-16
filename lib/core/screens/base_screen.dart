import 'package:flutter/material.dart';
import 'package:petapp/core/widgets/nav_bar.dart';

class BaseScreen extends StatelessWidget {
  final int navBarIndex;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? floatingActionButton;
  
  const BaseScreen({
    super.key, 
    required this.navBarIndex,
    required this.body,
    this.appBar,
    this.floatingActionButton,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      bottomNavigationBar: CommonBottomNavBar(currentIndex: navBarIndex),
      floatingActionButton: floatingActionButton,
    );
  }
}