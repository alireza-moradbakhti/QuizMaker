import 'package:flutter/material.dart';
import 'package:quizmaker_bzte/services/auth.dart';
import 'package:quizmaker_bzte/utils/colors.dart';
import 'package:quizmaker_bzte/views/signin.dart';
import 'package:quizmaker_bzte/widgets/widgets.dart';
import '../helper/functions.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  String? email, password, name;
  AuthService authService = AuthService();
  bool _isLoading = false;

  signUp() async{
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
       authService.signUpEmailAndPass(email!, password!).then((value) => {
        if(value != null)
          {
            setState(() {
              _isLoading = false;
            }),
            HelperFunctions.saveUserLoggedInDetails(isLoggedIn: true),
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()))
          }

      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: appBar(context),
        centerTitle: true,
        backgroundColor: hexStringToColor("CB2B93"),
        elevation: 0.0,
      ),
      body: _isLoading ? Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor("CB2B93"),
            hexStringToColor("9546C4"),
            hexStringToColor("5E61F4"),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ) :
      Form(
        key: _formKey,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4"),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(),
              TextFormField(
                validator: (val) {
                  return val!.isEmpty ? "Enter Your Name!" : null;
                },
                decoration: const InputDecoration(
                  hintText: "Name",
                ),
                onChanged: (val) {
                  name = val;
                },
              ), //Name Field
              const SizedBox(
                height: 6,
              ),
              TextFormField(
                validator: (val) {
                  return val!.isEmpty ? "Enter The Email" : null;
                },
                decoration: const InputDecoration(
                  hintText: "Email",
                ),
                onChanged: (val) {
                  email = val;
                },
              ), //Email Field
              const SizedBox(
                height: 6,
              ),
              TextFormField(
                obscureText: true,
                validator: (val) {
                  return val!.isEmpty ? "Enter The Password" : null;
                },
                decoration: const InputDecoration(
                  hintText: "Password",
                ),
                onChanged: (val) {
                  password = val;
                },
              ), //Password Field
              const SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () {
                  signUp();
                },
                child: BButton(context: context,label: "Sign Up")
              ), //Sign up button
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 14.5),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => SignIn()));
                    },
                    child: const Text(
                      "Sign in",
                      style: TextStyle(
                          fontSize: 14.5,
                          decoration: TextDecoration.underline,
                          color: Colors.black),
                    ),
                  ),
                ],
              ), // navigation to sign in page

              const SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
    );
  }
}
