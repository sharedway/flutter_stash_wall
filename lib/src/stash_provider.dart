import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stash_wall/src/stash_controller.dart';
import 'package:stash_wall/src/stash_state.dart';

import '../stash_wall.dart';

class StashProvider extends StatelessWidget {
  final Widget rootWidget;
  const StashProvider({Key? key, required this.rootWidget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => StashState(keyName: "location_state_notifier_", config: {})..onInit())],
        child: StashController(
          rootWidget: rootWidget,
        ));
  }
}
