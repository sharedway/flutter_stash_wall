import 'package:flutter/foundation.dart';
import 'package:stash_wall/src/notifiers/generic_rest_and_socket_notifier.dart';

class StashState extends GenericRestAndSocketNotifier {
  StashState({required String keyName, required Map<String, dynamic> config}) : super(keyName: keyName, config: config);

  @override
  bool get isReady => false;
}
