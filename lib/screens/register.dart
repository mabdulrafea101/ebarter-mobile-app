import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommerce/logic/signup/bloc/signup_bloc.dart';
import 'package:fluttercommerce/screens/home.dart';
import 'package:fluttercommerce/screens/login.dart';
import 'package:fluttercommerce/utils/navigator.dart';
import 'package:fluttercommerce/widgets/submitbutton.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNamefirstNameController =
      TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupLodaded) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        } else if (state is SignupFaluire) {
          final snackBar = SnackBar(content: Text(state.error));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        body: BlocBuilder<SignupBloc, SignupState>(
          builder: (context, state) {
            if (state is SignupLoading) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.redAccent,
              ));
            }
            return Center(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Welcome",
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: Text(
                          "Register account",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      _buildTextFormField(
                          hint: "Name", controller: _firstNameController),
                      SizedBox(height: 24),
                      _buildTextFormField(
                          hint: "Surname",
                          controller: _lastNamefirstNameController),
                      SizedBox(height: 24),
                      _buildTextFormField(
                          hint: "Email", controller: _emailController),
                      SizedBox(height: 24),
                      _buildTextFormField(
                          hint: "Username", controller: _userNameController),
                      SizedBox(height: 24),
                      _buildTextFormField(
                          hint: "Password", controller: _passwordController),
                      SizedBox(height: 24),
                      BlocBuilder<SignupBloc, SignupState>(
                        builder: (context, state) {
                          if (state is SignupFaluire) {
                            return Text(state.error,
                                style: TextStyle(color: Colors.red));
                          }
                          return Text('');
                        },
                      ),
                      SubmitButton(
                        title: "Register",
                        act: () {
                          BlocProvider.of<SignupBloc>(context)
                              .add(SignupButtonPressed(
                            token: 'token',
                            username: _userNameController.text,
                            firstName: _firstNameController.text,
                            lastName: _lastNamefirstNameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                          ));
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 48.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Already exist account? ",
                              style: TextStyle(fontSize: 17),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildTextFormField({
    String hint,
    TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      // style: TextStyleUtile.normulTextStyle(
      //     fontSize: 14, color: kDarkLightTextColor),
      // onChanged: isIdField ? _checkIdIsExist : null,
      decoration: InputDecoration(
        fillColor: Colors.white,
        contentPadding: EdgeInsets.only(left: 20, top: 15),
        hintText: hint,
        labelText: hint,
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear,
            size: 16,
          ),
          onPressed: () => controller.clear(),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines == 1 ? 50 : 18),
          borderSide: BorderSide(color: Theme.of(context).accentColor),
        ),
      ),
      validator: (value) {
        return value == null ? 'Please fill the field' : null;
      },
    );
  }
}
