import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authProject/features/user_auth/firebase_auth_implementation/auth_services.dart';
import 'package:firebase_authProject/features/user_auth/views/home_view.dart';
import 'package:firebase_authProject/features/user_auth/views/signUp_view.dart';
import 'package:firebase_authProject/features/user_auth/widgets/custom_form.dart';
import 'package:firebase_authProject/global/widgets/toast.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isloading = false;
  FirebaseAuthServices _auth = FirebaseAuthServices();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LOGIN"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Login Page",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 5,
              ),
              CustomFormField(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              SizedBox(
                height: 5,
              ),
              CustomFormField(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: _signIn,
                child: _isloading
                    ? const CircularProgressIndicator(
                        color: Colors.blue,
                      )
                    : Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue),
                        child: Center(
                            child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
              ),
              SizedBox(
                height: 3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Dont have an account ? "),
                  GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpView()),
                        (route) => false),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    setState(() {
      _isloading = true;
    });
    String password = _passwordController.text;
    String email = _emailController.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);
    print("${user?.email ?? "no user"}");
    print("${user?.displayName ?? "no user"}");
    if (user != null) {
      showToast(message: "user successfully signed in ! ");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeView()));
    } else {
      print("Some error occured ");
    }
    setState(() {
      _isloading = false;
    });
  }
}
