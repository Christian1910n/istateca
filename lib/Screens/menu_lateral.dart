import 'package:flutter/material.dart';
import 'package:proyectoistateca/Screens/home_screen.dart';
import 'package:proyectoistateca/widgets/widget_menu_lateral.dart';

class MenuLateralScreen extends StatefulWidget {
  static String id = 'menu_lateral';

  @override
  State<MenuLateralScreen> createState() => _MenuLateralScreenState();
}

class _MenuLateralScreenState extends State<MenuLateralScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        drawer: CustomDrawer(),
      ),
    );
  }
}
