import 'package:flutter/material.dart';
import 'package:kidnaphotspots/ui/shared/ui_helpers.dart';
import 'package:kidnaphotspots/ui/widgets/busy_button.dart';
import 'package:kidnaphotspots/ui/widgets/input_field.dart';
import 'package:kidnaphotspots/viewmodels/signup_view_model.dart';

import 'package:provider_architecture/provider_architecture.dart';

class SignUpView extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final matricController = TextEditingController();

  final matricFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignUpViewModel>.withConsumer(
      viewModel: SignUpViewModel(),
      builder: (context, model, child) => Scaffold(
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
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 38,
                        ),
                      ),
                      verticalSpaceLarge,
                      //  Add additional user data here to save (episode 2)
                      InputField(
                        textInputAction: TextInputAction.next,
                        nextFocusNode: matricFocusNode,
                        placeholder: 'Email',
                        controller: emailController,
                      ),
                      verticalSpaceSmall,

                      InputField(
                        textInputAction: TextInputAction.done,
                        // nextFocusNode: confirmPasswordFocusNode,
                        placeholder: 'Password',
                        password: true,
                        controller: passwordController,
                        additionalNote:
                            'Password has to be a minimum of 6 characters.',
                      ),
                      verticalSpaceMedium,
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BusyButton(
                            title: 'Sign Up',
                            busy: model.busy,
                            onPressed: () {
                              model.register(
                                email: emailController.text,
                                password: passwordController.text,
                                matricNo: matricController.text,
                              );
                            },
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
