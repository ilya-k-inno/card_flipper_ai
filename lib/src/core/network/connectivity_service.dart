import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityService {
  Stream<bool> get onConnectivityChanged;

  Future<bool> get isConnected;

  void dispose();
}

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _subscription;
  final _controller = StreamController<bool>.broadcast();

  ConnectivityServiceImpl() {
    _subscription = _connectivity.onConnectivityChanged.listen((result) {
      _controller.add(_isConnected(result));
    });
  }

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _isConnected(result);
  }

  bool _isConnected(ConnectivityResult result) {
    return result == ConnectivityResult.wifi ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.mobile;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
