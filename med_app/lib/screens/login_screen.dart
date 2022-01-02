import 'package:flutter/material.dart';
import 'package:med_app/screens/event.screen.dart';
import 'package:med_app/shared/authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLogin = true;
  String _message = "";
  String? _userId;
  String? _email;
  String? _password;
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();

  late Authentication auth;

  @override
  void initState() {
    auth = Authentication();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Container(
        padding: EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              children: [
                emailInput(),
                passwordInput(),
                mainButton(),
                secondaryButton(),
                validationMessage()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget emailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: TextFormField(
        controller: txtEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(hintText: 'Email', icon: Icon(Icons.email)),
        validator: (String? text) => text!.isEmpty ? ' Email is required' : '',
      ),
    );
  }

  Widget passwordInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: TextFormField(
        controller: txtPassword,
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration:
            InputDecoration(hintText: 'Password', icon: Icon(Icons.password)),
        validator: (String? text) =>
            text!.isEmpty ? ' Password is required' : '',
      ),
    );
  }

  Widget mainButton() {
    String buttonText = _isLogin ? 'Login' : 'Sign up';
    return Padding(
      padding: const EdgeInsets.only(top: 40.0),
      child: Container(
        height: 40,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Theme.of(context).focusColor),
            ),
          ),
          onPressed: submit,
          child: Text(buttonText),
        ),
      ),
    );
  }

  Widget secondaryButton() {
    String buttonText = _isLogin ? "Sign up" : "Login";
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isLogin = !_isLogin;
        });
      },
      child: Text(buttonText),
    );
  }

  Widget validationMessage() {
    return Text(
      _message,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void submit() async {
    setState(() {
      _message = "";
    });
    try {
      if (_isLogin == true) {
        _userId = await auth.login(txtEmail.text, txtPassword.text);
        print('Login for user $_userId');
      }
      if (_userId != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => EventScreen()));
      } else {
        _userId = await auth.signUp(txtEmail.text, txtPassword.text);
        print('Sign up for user $_userId');
      }
    } catch (errorMessage) {
      print('Error: $errorMessage');
      setState(() {
        _message = errorMessage.toString();
      });
    }
  }
}
