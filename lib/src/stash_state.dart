import 'package:flutter/foundation.dart';
import 'package:stash_wall/src/notifiers/generic_rest_and_socket_notifier.dart';

class StashState extends GenericRestAndSocketNotifier {
  StashState({required Map<String, dynamic> config}) : super(config: config);

  bool _isReady = false;
  bool _show = true;

  bool get show => _show;

  Future<void> showOverlay() async {
    _show = true;
    notifyListeners();
  }

  Future<void> hideOverlay() async {
    _show = false;
    notifyListeners();
  }

  @override
  Future<void> onInit() async {
    Future.delayed(const Duration(seconds: 20), () {
      _isReady = true;
      notifyListeners();
    });
  }

  @override
  bool get isReady => _isReady;
}
