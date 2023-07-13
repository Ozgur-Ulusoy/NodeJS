import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:worldflow/Data/screenUtil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();

  // Auth
  final LocalAuthentication auth = LocalAuthentication();
  // ···
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 81, 105, 208),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: Container()),
              Text(
                'WorldFlow',
                style: TextStyle(
                  fontSize: ScreenUtil.textScaleFactor * 50,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: ScreenUtil.height * 0.1),
              // create a text field for username
              SizedBox(
                width: ScreenUtil.width * 0.8,
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    hintText: 'Username',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil.height * 0.1),
              // LOGIN BUTTON HERE
              SizedBox(
                width: ScreenUtil.width * 0.8,
                child: ElevatedButton(
                  onPressed: () async {
                    // final response = await BiometricStorage().canAuthenticate();
                    // print(response);

                    // return;
                    if (_usernameController.text.isEmpty) {
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please enter a username',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      return;
                    }
                    final bool canAuthenticateWithBiometrics =
                        await auth.canCheckBiometrics;
                    final bool canAuthenticate =
                        canAuthenticateWithBiometrics ||
                            await auth.isDeviceSupported();
                    print(canAuthenticate);

                    List<BiometricType> availableBiometrics =
                        await auth.getAvailableBiometrics();
                    print(availableBiometrics);

                    for (var element in availableBiometrics) {}

                    if (canAuthenticate) {
                      final bool didAuthenticate = await auth.authenticate(
                          localizedReason: 'Please authenticate to login',
                          options: const AuthenticationOptions(
                            biometricOnly: true,
                          ));
                      if (didAuthenticate) {
                        // print auth data

                        // Navigator.pushNamed(context, '/main');
                        print('Authenticated');
                        // get the biometric data
                        // final List<BiometricType> availableBiometrics =
                        //     await auth.getAvailableBiometrics();
                      }
                    }

                    // Navigator.pushNamed(context, '/main');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Login'),
                ),
              ),
              Expanded(flex: 2, child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
