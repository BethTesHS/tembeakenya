import 'package:flutter/material.dart';
import 'package:tembeakenya/assets/colors.dart';
// import 'package:tembeakenya/views/verify_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsUtil.backgroundColorLight,
        title: const Text('Home Page',
            style: TextStyle(color: ColorsUtil.textColorLight)),
      ),
      body: Column(children: [
        const Text('Welcome'),
        TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/register/',
                (route) => false
              );
            },
            child: const Text("Register")
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login/',
                (route) => false
              );
            },
            child: const Text("Login")
          )
        ]
      ),
    );
  }
}
