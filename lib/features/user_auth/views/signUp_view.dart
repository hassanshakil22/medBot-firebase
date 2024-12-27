import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authProject/features/user_auth/firebase_auth_implementation/auth_services.dart';
import 'package:firebase_authProject/features/user_auth/views/home_view.dart';
import 'package:firebase_authProject/features/user_auth/views/login_view.dart';
import 'package:firebase_authProject/features/user_auth/widgets/custom_form.dart';
import 'package:firebase_authProject/global/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool _isloading = false;
  FirebaseAuthServices _auth = FirebaseAuthServices();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up Page",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 5,
              ),
              CustomFormField(
                controller: _usernameController,
                hintText: "Username",
                isPasswordField: false,
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
                onTap: _signUp,
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
                        child: const Center(
                            child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ))),
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: _signInWithGoogle,
                child: _isloading
                    ? const CircularProgressIndicator(
                        color: Colors.blue,
                      )
                    : Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.red),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.google,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Sign in with google",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account ? "),
                  GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginView()),
                        (route) => false),
                    child: const Text(
                      "Login",
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

  Future<void> _signUp() async {
    setState(() {
      _isloading = true;
    });
    String username = _usernameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;

    User? user =
        await _auth.signUpWithEmailAndPassword(email, password, username);
    if (user != null) {
      showToast(message: "user successfully created ! ");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeView()));
    } else {
      print("Some error occured ");
    }
    setState(() {
      _isloading = false;
    });
  }

  _signInWithGoogle() async {
    setState(() {
      _isloading = true;
    });
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? _googleSignInAccount =
          await _googleSignIn.signIn();

      if (_googleSignInAccount != null) {
        final GoogleSignInAuthentication _googleSignInAuthentication =
            await _googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: _googleSignInAuthentication.idToken,
            accessToken: _googleSignInAuthentication.accessToken);
        await FirebaseAuth.instance.signInWithCredential(credential);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const HomeView()));
      }
    } catch (e) {
      print(e);
      showToast(message: "Error occured : $e");
    }
    setState(() {
      _isloading = false;
    });
  }
}
