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
  double get h => WidgetsBinding.instance.window.physicalSize.height;
  double get w => WidgetsBinding.instance.window.physicalSize.width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: w,
      height: h,
      child: Stack(
        textDirection: TextDirection.ltr,
        alignment: Alignment.center,
        children: [
          widget.rootWidget,
          Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Container(
                color: Colors.indigo,
                child: Row(
                  children: [
                    const Text(
                      "teste",
                      style: TextStyle(fontSize: 18, color: Colors.amber),
                    ),
                    TextButton(
                        onPressed: () {
                          context.read<StashState>().showOverlay();
                        },
                        child: const Text("Show")),
                  ],
                ),
              )),
          AnimatedPositioned(
              right: 0,
              left: 0,
              top: (context.watch<StashState>().show) ? 0 : (h),
              bottom: 0,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutQuad,
              child: Container(
                color: Colors.black.withOpacity(0.6),
                alignment: Alignment.center,
                child: ListView(
                  children: [
                    TextButton(
                        onPressed: () {
                          context.read<StashState>().hideOverlay();
                        },
                        child: Text("Hide"))
                  ],
                ),
              )),
        ],
      ),
    );
    ;
  }
}
