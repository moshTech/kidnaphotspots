import 'package:flutter/material.dart';
import 'package:kidnaphotspots/ui/shared/ui_helpers.dart';
import 'package:kidnaphotspots/ui/views/signup_view.dart';
import 'package:kidnaphotspots/ui/widgets/busy_button.dart';
import 'package:kidnaphotspots/ui/widgets/input_field.dart';
import 'package:kidnaphotspots/ui/widgets/text_link.dart';
import 'package:kidnaphotspots/viewmodels/login_view_model.dart';

import 'package:provider_architecture/provider_architecture.dart';

import 'forget_password_view.dart';

class LoginView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final matricController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LoginViewModel>.withConsumer(
      viewModel: LoginViewModel(),
      builder: (context, model, child) => Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset(
                'assets/images/kidnapped.jpg',
                fit: BoxFit.cover,
                // color: Colors.black87,
                colorBlendMode: BlendMode.darken,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Login',
                          style: TextStyle(fontSize: 38, color: Colors.white),
                        ),
                        verticalSpaceLarge,
                        InputField(
                          textInputAction: TextInputAction.done,
                          placeholder: 'Email (e.g - test@gmail.com)',
                          controller: emailController,
                        ),
                        verticalSpaceSmall,
                        InputField(
                          textInputAction: TextInputAction.done,
                          placeholder: 'Password',
                          password: true,
                          controller: passwordController,
                        ),
                        verticalSpaceMedium,
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BusyButton(
                              title: 'Login',
                              busy: model.busy,
                              onPressed: () {
                                model.login(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  matricNo: matricController.text,
                                );
                              },
                            ),
                          ],
                        ),
                        verticalSpaceMedium,
                        TextLink(
                          'Create an Account.',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpView()));
                          },
                        ),
                        verticalSpaceMedium,
                        TextLink(
                          'Forget password?',
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgetPasswordView()));
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
