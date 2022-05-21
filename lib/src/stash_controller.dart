import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../stash_wall.dart';

class StashController extends StatefulWidget {
  final Widget rootWidget;

  const StashController({Key? key, required this.rootWidget}) : super(key: key);

  @override
  State<StashController> createState() => _StashControllerState();
}

class _StashControllerState extends State<StashController> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.rootWidget,
        Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Container(
              color: Colors.indigo,
              child: const Text(
                "teste",
                style: TextStyle(fontSize: 18, color: Colors.amber),
              ),
            )),
        AnimatedPositioned(
            right: 0,
            left: 0,
            top: (!context.watch<StashState>().isReady) ? 0 : (MediaQuery.of(context).size.height),
            bottom: 0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutQuad,
            child: Container(
              color: Colors.black.withOpacity(0.6),
              alignment: Alignment.center,
            )),
      ],
    );
  }
}
