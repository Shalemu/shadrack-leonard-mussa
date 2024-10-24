import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkInfo {
  final Connectivity connectivity;

  NetworkInfo(this.connectivity);

  Future<List<ConnectivityResult>> getConnectivity() async {
    // Get connectivity status as a single value
    List<ConnectivityResult> result = await connectivity.checkConnectivity();
    return result; // Return a single result
  }

  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    // Stream connectivity changes as single values
    return connectivity.onConnectivityChanged;
  }
}
