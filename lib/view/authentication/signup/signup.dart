import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/utils.dart';
import '../../home/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool? isChecked = false;
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
                    'Sing Up',
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
                  _buildTextField(
                      hintText: 'Enter your Name',
                      obscureText: false,
                      prefixedIcon: const Icon(Icons.mail, color: Colors.white),
                      cont: namecontroller),
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
                      prefixedIcon: const Icon(Icons.mail, color: Colors.white),
                      cont: email),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Password',
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
                      hintText: 'Enter your password',
                      obscureText: true,
                      prefixedIcon: const Icon(Icons.lock, color: Colors.white),
                      cont: password),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _buildSignUpButton(),
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
        cursorColor: Colors.white,
        cursorWidth: 2,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          fillColor: const Color(0xFF5180ff),
          prefixIcon: prefixedIcon,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
            fontFamily: 'PTSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
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
          'Sign Up',
          style: TextStyle(
            fontFamily: 'PT-Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onPressed: () async {
          try {
            await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: email.text, password: password.text)
                .whenComplete(() {
              user = FirebaseAuth.instance.currentUser;
              firestore.collection("Users").doc(user!.uid).set({
                "name": namecontroller.text,
              });
              name = namecontroller.text;
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ));
            });
          } on FirebaseAuthException catch (e) {
            if (e.code == 'weak-password') {
              print('The password provided is too weak.');
            } else if (e.code == 'email-already-in-use') {
              print('The account already exists for that email.');
            }
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}
