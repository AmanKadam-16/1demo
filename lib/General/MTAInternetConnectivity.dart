import 'package:connectivity_plus/connectivity_plus.dart';
import '../widgets/mtaToast.dart';
import 'MTAResult.dart';

class MTAInternetConnectivity {
  /// Checks if the device is connected to the internet.
  ///
  /// Returns a boolean indicating internet connectivity.
  /// Displays a toast message if no internet is available.
  Future<bool> isConnectedToInternet() async {
    try {
      final MTAResult result = await isInternetAvailable();

      if (!result.IsResultPass) {
        _showErrorToast(result.ErrorMessage);
        return false;
      }
      return true;
    } catch (e) {
      _showErrorToast('Failed to check internet connection');
      return false;
    }
  }

  /// Checks the specific type of internet connectivity.
  ///
  /// Returns an MTAResult with detailed connectivity information.
  Future<MTAResult> isInternetAvailable() async {
    final MTAResult result = MTAResult();

    try {
      final List<ConnectivityResult> connectivityResults = await Connectivity().checkConnectivity();

      if (connectivityResults.isEmpty || 
          connectivityResults.every((result) => result == ConnectivityResult.none)) {
        result.IsResultPass = false;
        result.ErrorMessage = 'No internet connection';
      } else {
        result.IsResultPass = true;
        result.ResultMessage = _getConnectivityMessage(connectivityResults.first);
      }
    } catch (e) {
      result.IsResultPass = false;
      result.ErrorMessage = 'Error checking internet connection: ${e.toString()}';
      _showErrorToast('Network was not found');
    }

    return result;
  }

  /// Returns a descriptive message for the connectivity result.
  String _getConnectivityMessage(ConnectivityResult connectivityResult) {
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
      MTAToast().ShowToast('Connected to mobile network');
        return 'Connected to mobile network';
      case ConnectivityResult.wifi:
      MTAToast().ShowToast('Connected to WiFi network');
        return 'Connected to WiFi network';
      case ConnectivityResult.ethernet:
      MTAToast().ShowToast('Connected to Ethernet network');
        return 'Connected to Ethernet network';
      case ConnectivityResult.vpn:
      MTAToast().ShowToast('Connected to VPN network');
        return 'Connected to VPN network';
      case ConnectivityResult.bluetooth:
      MTAToast().ShowToast('Connected to Bluetooth network');
        return 'Connected to Bluetooth network';
      case ConnectivityResult.other:
      MTAToast().ShowToast('Connected to another network');
        return 'Connected to another network';
      default:
      MTAToast().ShowToast('Unknown connectivity');
        return 'Unknown connectivity';
    }
  }

  /// Helper method to display an error toast.
  void _showErrorToast(String message) {
    MTAToast().ShowToast(message);
  }
}