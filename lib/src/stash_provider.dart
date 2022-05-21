import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stash_wall/src/stash_controller.dart';
import 'package:stash_wall/src/stash_state.dart';

import '../stash_wall.dart';

class StashProvider extends StatelessWidget {
  final Widget rootWidget;
  final Map<String, dynamic> config;
  const StashProvider({Key? key, required this.rootWidget, required this.config}) : super(key: key);

  String get gameId => config['gameId'] ?? "universal_game_id";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => StashState(keyName: "app_stash_state_notifier_$gameId", config: config)..onInit())],
        child: StashController(
          rootWidget: rootWidget,
        ));
  }
}
