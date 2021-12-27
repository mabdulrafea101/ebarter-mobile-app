import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommerce/logic/authentication/bloc/authentication_bloc.dart';
import 'package:fluttercommerce/logic/login/bloc/login_bloc.dart';
import 'package:fluttercommerce/screens/home.dart';
import 'package:fluttercommerce/screens/register.dart';
import 'package:fluttercommerce/utils/navigator.dart';
import 'package:fluttercommerce/utils/progressdialog.dart';
import 'package:fluttercommerce/widgets/edittext.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  ProgressDialog progressDialog;

  AuthenticationBloc _authenticationBloc;

  LoginBloc _loginBloc;

  @override
  void initState() {
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _authenticationBloc.add(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context, ProgressDialogType.Normal);
    progressDialog.setMessage('Logging in...');
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationAuthenticated) {
          Nav.route(context, Home());
        }
      },
      child: Scaffold(
        body: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Center(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Text("Welcome",
                          style: Theme.of(context).textTheme.headline1),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text("Login to your account",
                            style: Theme.of(context).textTheme.subtitle1),
                      ),
                      EditText(
                        title: "Email",
                        controller: _emailController,
                      ),
                      EditText(
                        title: "Password",
                        controller: _passwordController,
                      ),
                      MaterialButton(
                        onPressed: _onLoginButtonPressed,
                        child: Text('Login'),
                      ),
                      // title: "Login", act: _onLoginButtonPressed()),
                      // Padding(
                      //   padding: const EdgeInsets.all(32.0),
                      //   child: Text("Forgot your password?"),
                      // ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Don't have an account?  ",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17),
                            ),
                          ),
                        ],
                      ),
                      _buildLoginMessage()
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _onLoginButtonPressed() {
    // addUserToken(context);
    print('${_emailController.text} email--------');
    _loginBloc.add(
      LoginButtonPressed(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );

    // }
  }

  Padding _buildLoginMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      // child: BlocBuilder<LoginBloc, LoginState>(
      //   builder: (context, state) {
      //     if (state is LoginFailure) {
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoggedIn) {}
          if (state is LoginFailure) {
            return Text(
              state.error,
              style: TextStyle(
                color: Colors.red,
              ),
            );
          }
          return Text('');
        },
      ),
      // }
      // return Text('xyz');
      // },
    );
    // );
  }
}
