import 'package:flutter/material.dart';
import 'package:home_app/widget/common/welcome_card.dart';
import 'package:home_app/widget/otp/pin_form.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: [
            const WelcomeCard(),
            const SizedBox(
              height: 10,
            ),
            PinForm()
          ],
        ));
  }
}
