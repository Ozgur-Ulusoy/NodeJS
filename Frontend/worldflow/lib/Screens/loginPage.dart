import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:worldflow/Data/Consts/AppConstants.dart';
import 'package:worldflow/Data/Consts/LocalDatabaseConstants.dart';
import 'package:worldflow/Data/Models/LocalDatabaseModels/UserModel.dart';
import 'package:worldflow/Data/screenUtil.dart';
import 'package:worldflow/Data/Managers/InternetManager.dart';

import '../Data/Managers/HiveManager.dart';
import '../Data/Models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Auth
  final LocalAuthentication auth = LocalAuthentication();
  // ···
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConsts.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(flex: 2, child: Container()),
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
                SizedBox(height: ScreenUtil.height * 0.02),
                // create a text field for email
                SizedBox(
                  width: ScreenUtil.width * 0.8,
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
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
                SizedBox(height: ScreenUtil.height * 0.02),
                // create a text field for password
                SizedBox(
                  width: ScreenUtil.width * 0.8,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
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

                      // login

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

                      if (_emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please enter an email',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        return;
                      }

                      if (_passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please enter a password',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        return;
                      }

                      User? user = await InternetManager.login(
                        _usernameController.text,
                        _emailController.text,
                        _passwordController.text,
                      );
                      print(user);

                      if (user == null) {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Invalid username or password',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        return;
                      } else {
                        // route to main page
                        if (user.isVerified) {
                          UserModel userModel = UserModel(
                            id: user.id,
                            username: user.username,
                            token: user.token,
                          );

                          await HiveGlobal.instance
                              .putData(LocalDatabaseConstants.USER, userModel);
                          await Navigator.pushNamedAndRemoveUntil(
                              context, '/home', (route) => false);
                          print('${user.username} ${user.token} ${user.id}');
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Login successful',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                        } else {
                          await InternetManager.sendEmailVerify(
                              user.email, user.username);
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Sent Verification Email',
                                ),
                                backgroundColor: Colors.blue,
                              ),
                            );
                        }
                      }

                      //
                      final bool canAuthenticateWithBiometrics =
                          await auth.canCheckBiometrics;
                      final bool canAuthenticate =
                          canAuthenticateWithBiometrics ||
                              await auth.isDeviceSupported();
                      // print(canAuthenticate);

                      List<BiometricType> availableBiometrics =
                          await auth.getAvailableBiometrics();
                      // print(availableBiometrics);

                      if (canAuthenticate && availableBiometrics.isNotEmpty) {
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
                Flexible(flex: 2, child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
