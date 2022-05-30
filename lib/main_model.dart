import 'dart:async';

import 'package:flutter/material.dart';
import 'package:snapd/snapd.dart';

class MainModel extends ChangeNotifier {
  static const _searchDelay = 1;

  final SnapdClient _client = SnapdClient();

  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  set searchQuery(String value) {
    if (value != _searchQuery) {
      _searchQuery = value;
      _search();
      notifyListeners();
    }
  }

  Timer? _timer;

  final StreamController<List<Snap>> _snapController = StreamController();

  late final Stream<List<Snap>> snapStream;

  MainModel() {
    snapStream = _snapController.stream;
  }

  @override
  void dispose() {
    super.dispose();
    _client.close();
    _snapController.close();
  }

  void _search() {
    _timer?.cancel();

    if (_searchQuery.isNotEmpty) {
      _timer = Timer(const Duration(seconds: _searchDelay), () async {
        final snaps = await _client.find(query: _searchQuery);
        _snapController.sink.add(snaps);
      });
    } else {
      _snapController.sink.add([]);
    }
  }
}
