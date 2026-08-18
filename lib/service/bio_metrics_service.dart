import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final bool canAuthenticate =
          await auth.canCheckBiometrics || await auth.isDeviceSupported();
      final biometrics = await auth.getAvailableBiometrics();
      print(biometrics);
      if (!canAuthenticate) {
        return false;
      }

      final bool authenticated = await auth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        // options: AuthenticationOptions(
        //   biometricOnly: true,
        //   stickyAuth: true,
        //   useErrorDialogs: true,
        //),
      );

      return authenticated;
    } catch (e) {
      print('Biometric error: $e');
      return false;
    }
  }
}