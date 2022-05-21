import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../utils/app_local_files_api.dart';
import '../utils/static_methods.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenericRestAndSocketNotifier extends ChangeNotifier with AppLocalFilesApi {
  final String keyName;
  final Map<String, dynamic> config;

  GenericRestAndSocketNotifier({required this.keyName, required this.config});

  Map<String, String> get authHeaders => config['authHeaders'] ?? {};
  List<String> get keepKeys => config['keepKeys'] ?? [];
  List<String> get excludeKeys => config['excludeKeys'] ?? [];
  bool get writeToLocalStorage => config['writeToLocalStorage'] ?? false;
  bool get autoNotify => config['autoNotify'] ?? false;
  String get ssoToken => config['ssoToken'] ?? "invalidToken";
  String get baseRestUrl => config['baseRestUrl'] ?? "invalidUrl";
  String get baseSocketUrl => config['baseSocketUrl'] ?? "invalidUrl";

  WebSocketChannel? _ws_channel;
  StreamSubscription? _channelListener;
  Stream? stream;
  Map<String, dynamic> _last_data = {};
  Map<String, dynamic> get last_data => _last_data;
  bool _changeSelection = false;
  bool get changeSelection => _changeSelection;
  List<String> _inbound_data = [];
  bool in_dispose = false;
  int get totalUpdates => _inbound_data.length;

  int _activePage = 1;
  int get activePage => _activePage;
  int get totalPages => throw UnimplementedError("Metodo para informar total de paginas");
  int get totalResults => throw UnimplementedError("Metodo para informar total de resultados");
  bool get isReady => throw UnimplementedError("Propriedade para informar da inicializacao");

  List<String> get _keepKeys {
    return keepKeys ?? [];
  }

  List<String> get _excludeKeys {
    return excludeKeys ?? [];
  }

  String? getStringKey(String key) {
    return instanceMap[key];
  }

  final Map<String, dynamic> _initialMap = {"isLoaded": true};

  final Map<String, dynamic> _instanceMap = {};

  UnmodifiableMapView<String, dynamic> get instanceMap => UnmodifiableMapView(_instanceMap);

  Future<void> reloadMap() async {
    await _loadAppState();
  }

  void onAdd(Map<String, dynamic> values) {
    _instanceMap.addAll(values);
  }

  void onNotify() {
    notifyListeners();
  }

  void onSave() {
    _saveAppState();
  }

  void addAndSave(Map<String, dynamic> values) {
    _instanceMap.addAll(values);
    _saveAppState().then((value) => {notifyListeners()});
  }

  void add(Map<String, dynamic> values) {
    _instanceMap.addAll(values);
    _saveAppState().then((value) => {notifyListeners()});
  }

  Future<void> removeKey(String keyName) async {
    _instanceMap.remove(keyName);
    await _saveAppState();
    notifyListeners();
  }

  void del(Map<String, dynamic> values) {
    _instanceMap.remove(values);
    _saveAppState().then((value) => {notifyListeners()});
  }

  void removeAll() {
    Map<String, dynamic> _writeMap = {};
    for (var key in _keepKeys) {
      _writeMap.addAll(_instanceMap[key]);

      if (kDebugMode) {
        print("keeping key: $key");
      }
    }
    _instanceMap.clear();
    _instanceMap.addAll(_initialMap);
    _instanceMap.addAll(_writeMap);
    _saveAppState().then((value) => {notifyListeners()});
  }

  Future<void> _loadAppState() async {
    if (writeToLocalStorage) {
      var sharedPrefs = await SharedPreferences.getInstance();
      if (sharedPrefs.containsKey(keyName)) {
        _instanceMap.addAll(jsonDecode(sharedPrefs.getString(keyName).toString()));
      } else {
        _instanceMap.addAll(_initialMap);
      }
    } else {
      if (kDebugMode) {
        print("save not found");
      }

      _instanceMap.addAll(_initialMap);
    }
  }

  Future<void> _saveAppState() async {
    if (writeToLocalStorage) {
      var sharedPrefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> _writeMap = {};
      _writeMap.addAll(_instanceMap);
      for (var key in _excludeKeys) {
        _writeMap.remove(key);

        if (kDebugMode) {
          print("Removing key: $key");
        }
      }
      await sharedPrefs.setString(keyName, jsonEncode(_writeMap));
    } else {
      if (kDebugMode) {
        print("not write");
      }
    }
  }

  Future<void> selectionChanged() async {
    _changeSelection = false;
  }

  Future<void> onRequestPrevPage() async {
    onRequestPage(_activePage - 1, false);
  }

  Future<void> onRequestNextPage() async {
    onRequestPage(_activePage + 1, false);
  }

  Future<void> onInit() async {
    throw UnimplementedError("Call to initialize");
  }

  Future<void> onRebuildState(String newData) async {
    throw UnimplementedError("Called after new data arrived");
  }

  Future<void> onParseCollection(int page, String collection) async {
    throw UnimplementedError("parse a collection of results");
  }

  Future<void> onRequestPage(int page, bool waitfor) async {
    Uri url = Uri.parse("$baseRestUrl?page=$page");
    final request = await StaticMethods.requestGet(url, authHeaders);

    if (request.statusCode == 200) {
      if (waitfor) {
        await onParseCollection(page, utf8.decode(request.bodyBytes));
        _activePage = page;
        notifyListeners();
      } else {
        onParseCollection(page, utf8.decode(request.bodyBytes)).then((_) => {
              _activePage = page,
              notifyListeners(),
            });
      }
    } else {
      // TODO
    }
  }

  Future<void> closeWs() async {
    _ws_channel?.sink.close(1000);
  }

  @override
  void dispose() {
    in_dispose = true;
    closeWs().then((value) => {
          super.dispose(),
        });
  }

  Future<void> sendMessage(String msg) async {
    _ws_channel?.sink.add(msg);
  }

  Future<void> onStartWs() async {
    final url = Uri.parse("$baseSocketUrl?sso=$ssoToken");

    _ws_channel = WebSocketChannel.connect(url);
    stream = _ws_channel?.stream;
    stream?.listen((message) {
      onRebuildState(message);
    });
  }
}
