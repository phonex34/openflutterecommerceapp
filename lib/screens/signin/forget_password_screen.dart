import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openflutterecommerce/screens/signin/forget_password.dart';
import 'package:openflutterecommerce/screens/signin/signup.dart';
import 'package:openflutterecommerce/screens/signin/views/right_arrow_action.dart';
import 'package:openflutterecommerce/screens/signin/views/service_button.dart';
import 'package:openflutterecommerce/screens/signin/views/sign_in_field.dart';
import 'package:openflutterecommerce/screens/signin/views/signin_button.dart';
import 'package:openflutterecommerce/screens/signin/views/title.dart';

import '../../config/routes.dart';
import '../../config/theme.dart';
import 'validator.dart';

class ForgetPasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForgetPasswordScreenState();
  }
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = new TextEditingController();
  final GlobalKey<SignInFieldState> emailKey = new GlobalKey();

  double sizeBetween;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    sizeBetween = height / 20;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        brightness: Brightness.light,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.black),
      ),
      backgroundColor: AppColors.background,
      body: BlocConsumer<ForgetPasswordBloc, SignInState>(
        listener: (context, state) {
          if (state is FinishedState) Navigator.of(context).pop();
        },
        builder: (context, state) {
          if (state is ProcessingState)
            return Center(
              child: CircularProgressIndicator(),
            );
          return SingleChildScrollView(
            child: Container(
              height: height * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SignInTitle("Sign in"),
                  SizedBox(
                    height: sizeBetween,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                    child: Text(
                        "Please enter your email address. You will receive a link to create a new password via email"),
                  ),
                  SignInField(
                    key: emailKey,
                    controller: emailController,
                    hint: "Email",
                    validator: Validator.validateEmail,
                    keyboard: TextInputType.emailAddress,
                  ),
                  RightArrowAction(
                    "Already have an account",
                    onClick: _showSignInScreen,
                  ),
                  SignInButton("SEND", onPressed: _validateAndSend),
                  SizedBox(
                    height: sizeBetween * 2,
                  ),
                  Center(
                    child: Text("Or sign up with social account"),
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ServiceButton(
                            serviceType: ServiceType.Google,
                            onPressed: () {
                              BlocProvider.of<SignUpBloc>(context)
                                  .add(SignUpWithGoogle());
                            },
                          ),
                          ServiceButton(
                            serviceType: ServiceType.Facebook,
                            onPressed: () {
                              BlocProvider.of<SignUpBloc>(context)
                                  .add(SignUpWithFB());
                            },
                          ),
                        ],
                      )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showSignInScreen() {
    Navigator.of(context).pushNamed(OpenFlutterEcommerceRoutes.SIGNIN);
  }

  void _validateAndSend() {
    if (emailKey.currentState.validate() != null) {
      return;
    }
    BlocProvider.of<SignUpBloc>(context).add(SendEmailPressed(
      emailController.text,
    ));
  }
}