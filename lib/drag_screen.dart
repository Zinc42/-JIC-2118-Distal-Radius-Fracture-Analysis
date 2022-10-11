import 'package:flutter/material.dart';
import 'dart:io';

class DragScreen extends StatefulWidget {
  const DragScreen({Key? key}) : super(key: key);
  static const String id = "drag_screen";

  @override
  State<DragScreen> createState() => _DragScreenState();
}

class _DragScreenState extends State<DragScreen> {

  @override
  Widget build(BuildContext context) => _DragScreenView(state: this);

}

class _DragScreenView extends StatefulWidget {
  const _DragScreenView({super.key, required this.state});
  final _DragScreenState state;

  @override
  Widget build(BuildContext context) {
    return(
      Scaffold()
    );
  }

}
