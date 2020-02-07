import 'package:flutter/material.dart';
import 'package:kidnaphotspots/ui/shared/ui_helpers.dart';
import 'package:kidnaphotspots/ui/widgets/busy_button.dart';
import 'package:kidnaphotspots/ui/widgets/input_field.dart';
import 'package:kidnaphotspots/viewmodels/forget_password_view_model.dart';
import 'package:provider_architecture/viewmodel_provider.dart';

class ForgetPasswordView extends StatelessWidget {
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ForgetPasswordViewModel>.withConsumer(
      viewModel: ForgetPasswordViewModel(),
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
                          'Forget Password',
                          style: TextStyle(fontSize: 38, color: Colors.white),
                        ),
                        verticalSpaceLarge,
                        InputField(
                          textInputAction: TextInputAction.done,
                          placeholder: 'Email (e.g - test@gmail.com)',
                          controller: emailController,
                        ),
                        verticalSpaceMedium,
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BusyButton(
                              title: 'Reset',
                              busy: model.busy,
                              onPressed: () {
                                model.resetPassword(
                                  email: emailController.text,
                                );
                              },
                            ),
                          ],
                        ),
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
