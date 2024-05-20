import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


const backgroundDark = Color(0xFF171B10);
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _email,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration (
            hintText: 'Enter your email here',
          ),
        ),
      
        TextField(
          controller: _password,
          obscureText: true,
          enableSuggestions: false,
          autocorrect: false,
          decoration: const InputDecoration (
            hintText: 'Enter your password here',
          ),
        ),
      
        TextButton(
          onPressed: () async {
            final email = _email.text;
            final password = _password.text;          
            try {
              await FirebaseAuth.instance.signInWithEmailAndPassword(
                email: email, 
                password: password
              );
            } on FirebaseAuthException catch (e){
              print(e.code);
              if (e.code == 'invalid-credential') {
                print('Invalid Credential');
              }
            } 
          },
          child: const Text('Login'),
        ),
      ]
    );
  }
}