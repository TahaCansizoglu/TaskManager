import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_management/view/authentication/signin/signin.dart';
import '../signup/signup.dart';
import '../../home/home_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
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
                  const Text(
                    'Reset Password',
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
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
                        fontFamily: 'PT-Sans',
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
                    height: 7,
                  ),
                  _buildResetButton(),
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

  Widget _buildResetButton() {
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
          'Reset',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF366EE6),
          ),
        ),
        onPressed: () async {
          try {
            await FirebaseAuth.instance
                .sendPasswordResetEmail(email: emailController.text)
                .then((value) {
              final snackBar = SnackBar(
                  content: Text(
                      "A password reset ling has been send to ${emailController.text}"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Future.delayed(
                  Duration(seconds: 2),
                  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(),
                      )));
            });
          } on FirebaseAuthException catch (e) {
            final snackBar = SnackBar(content: Text(e.message.toString()));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            print(e.code);
            print(e.message);
          }
        },
      ),
    );
  }
}
