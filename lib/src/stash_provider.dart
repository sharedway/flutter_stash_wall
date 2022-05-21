import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stash_wall/src/stash_controller.dart';
import 'package:stash_wall/src/stash_state.dart';

import '../stash_wall.dart';

class StashProvider extends StatelessWidget {
  final Widget rootWidget;
  final StashState stashState;
  const StashProvider({Key? key, required this.rootWidget, required this.stashState}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => stashState..onInit())],
        child: MaterialApp(
          key: const Key("root_app_material"),
          home: StashController(
            rootWidget: rootWidget,
          ),
        ));
  }
}
