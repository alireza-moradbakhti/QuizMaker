import 'package:flutter/material.dart';
import 'package:quizmaker_bzte/helper/functions.dart';
import 'package:quizmaker_bzte/services/auth.dart';
import 'package:quizmaker_bzte/utils/colors.dart';
import 'package:quizmaker_bzte/views/sign-up.dart';
import 'package:quizmaker_bzte/widgets/widgets.dart';


import 'home.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String? email, password;
  AuthService authService = AuthService();

  bool _isLoading = false;

  signIn() async{
    if(_formKey.currentState!.validate()){
      setState(() {
        _isLoading = true;
      });
      await authService.signInEmailAndPass(email!, password!).then((val){
        if(val != null)
        {
          setState(() {
            _isLoading = false;
          });
          HelperFunctions.saveUserLoggedInDetails(isLoggedIn: true);
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context)=> Home()
          ));
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
      ) : Form(
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
                onTap: (){
                  signIn();
                },
                child:BButton(context: context,label: "Sign In"),
              ), //Sign in button
              const SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 14.5, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 14.5,
                          decoration: TextDecoration.underline,
                          color: Colors.white),
                    ),
                  ),
                ],
              ), // navigation to sign up page

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
