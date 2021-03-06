import 'package:didauday_app/src/core/services/graphql/config/config.dart';
import 'package:didauday_app/src/core/services/graphql/query/query_profile.dart';
import 'package:didauday_app/src/core/services/shared_preferences_service.dart';
import 'package:didauday_app/src/resources/screens/auth/blocs/login_bloc.dart';
import 'package:didauday_app/src/resources/widgets/dialog/loading_dialog.dart';
import 'package:didauday_app/src/resources/widgets/dialog/message_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

  LoginBloc _loginBloc = LoginBloc();

  void _onLogin() async {
    var email = _emailController.text;
    var password = _passwordController.text;
    if (_loginBloc.isValidDataLogin(email, password)) {
      LoadingDialog.showLoadingDialog(context, "Logging in. Please wait...");
      try {
        final userInfo = await _loginBloc.onLogin(email, password);
        await _saveToken(userInfo);

        await _checkProfile();
      } catch (error) {
        LoadingDialog.hideLoadingDialog(context);
        MessageDialog.showMsgDialog(context, "Login", error.toString());
      }
    }
  }

  Future _checkProfile() async {
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        document: QueryProfile.checkProfile,
      ),
    );

    if (!result.hasErrors) {
      bool isComplete = result.data.data["checkProfile"]["is_complete"];
      if (isComplete) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, '/user/update_profile', (_) => false);
      }
    } else {
      MessageDialog.showMsgDialog(
          context, "Login", result.errors[0].toString());
    }
  }

  void _onLoginWithGoogle() async {
    FirebaseUser userInfo;

    try {
      userInfo = await _loginBloc.onLoginWithGoogle();
    } catch (error) {
      print(error);
      MessageDialog.showMsgDialog(
        context,
        "Login with google",
        error,
      );
      return;
    }

    await _saveToken(userInfo);

    try {
      await _checkProfile();
    } catch (error) {
      MessageDialog.showMsgDialog(
        context,
        "Login with google",
        error,
      );
    }
  }

  void _onLoginWithFacebook() async {
    FirebaseUser userInfo;

    try {
      userInfo = await _loginBloc.onLoginWithFacebook();
    } catch (error) {
      MessageDialog.showMsgDialog(
        context,
        "Login with facebook",
        error,
      );
      return;
    }

    await _saveToken(userInfo);

    try {
      await _checkProfile();
    } catch (error) {
      MessageDialog.showMsgDialog(
        context,
        "Login with facebook",
        error,
      );
    }
  }

  Future _saveToken(FirebaseUser userInfo) async {
    var token = await userInfo.getIdToken();
    await sharedPreferenceService.getSharedPreferencesInstance();
    await sharedPreferenceService.setToken(token.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 128,
                  height: 128,
                  child: FlutterLogo(
                    size: 128,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: StreamBuilder<Object>(
                      stream: _loginBloc.emailStream,
                      builder: (context, snapshot) {
                        return TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.email,
                              )),
                        );
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: StreamBuilder<Object>(
                      stream: _loginBloc.passwordStream,
                      builder: (context, snapshot) {
                        return TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              errorText:
                                  snapshot.hasError ? snapshot.error : null,
                              labelText: 'Password',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(
                                Icons.lock,
                              )),
                        );
                      }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/auth/forgot_password');
                      },
                      child: Text(
                        'Forgot password',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                      color: Color(0xfffd5739),
                      onPressed: _onLogin,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  'or',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                      color: Color(0xfffd5739),
                      onPressed: _onLoginWithGoogle,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              'Login with Google',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                  ),
                  child: SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: RaisedButton(
                      color: Color(0xff3a5a99),
                      onPressed: _onLoginWithFacebook,
                      child: Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Text(
                              'Login with Facebook',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'You don\'t have account?',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/auth/register');
                      },
                      child: Text(
                        'Create new account',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
