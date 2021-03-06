import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/init/task_manager.dart';
import '../../home/home_screen.dart';

import '../../../core/database/db.dart';
import '../../../core/service/firebase_service.dart';
import '../resetpassword/reset_password.dart';
import '../signup/signup.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool? isChecked = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF5967ff),
                Color(0xFF5374ff),
                Color(0xFF5180ff),
                Color(0xFF538bff),
                Color(0xFF5995ff),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ).copyWith(top: 60),
              child: Column(
                children: [
                  Image.asset('assets/images/taskmanagericon.png',
                      width: 150, height: 150),
                  SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Task Manager',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTextField(
                      hintText: 'Enter your email',
                      obscureText: false,
                      prefixedIcon:
                          const Icon(Icons.mail, color: Color(0xFF366EE6)),
                      cont: emailController),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildTextField(
                      hintText: 'Enter your password',
                      obscureText: true,
                      prefixedIcon:
                          const Icon(Icons.lock, color: Color(0xFF366EE6)),
                      cont: passwordController),
                  const SizedBox(
                    height: 7,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResetPasswordScreen(),
                            ));
                      },
                      child: const Text(
                        "Forget Password ?",
                        style: TextStyle(color: Colors.white),
                      )),
                  const SizedBox(
                    height: 7,
                  ),
                  _buildLoginButton(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    '- OR -',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildSignUpQuestion()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required bool obscureText,
      Widget? prefixedIcon,
      String? hintText,
      required TextEditingController cont}) {
    return Material(
      color: Colors.transparent,
      elevation: 2,
      child: TextField(
        controller: cont,
        cursorColor: const Color(0xFF366EE6),
        cursorWidth: 2,
        obscureText: obscureText,
        style: const TextStyle(color: Color(0xFF366EE6)),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
          prefixIcon: prefixedIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color(0xFF366EE6),
            fontWeight: FontWeight.bold,
            fontFamily: 'PTSans',
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Colors.white,
          ),
          elevation: MaterialStateProperty.all(6),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF366EE6),
          ),
        ),
        onPressed: () async {
          await DBHelper.initDb();
          FirebaseService.signIn(
                  emailController.text, passwordController.text, context)
              .whenComplete(() {
            try {
              if (FirebaseService.user != null) {
                Provider.of<TaskManager>(context, listen: false).getTasks();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                    (Route<dynamic> route) => false);
              }
            } on FirebaseAuthException catch (e) {
              final snackBar = SnackBar(content: Text(e.message.toString()));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              print(e.code);
              print(e.message);
            }
          });
        },
      ),
    );
  }

  Widget _buildSignUpQuestion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Dont have an Account? ',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        InkWell(
          child: const Text(
            'Sing Up',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUpScreen(),
              )),
        ),
      ],
    );
  }
}
