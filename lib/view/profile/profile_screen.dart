import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:task_management/core/database/db.dart';
import 'package:task_management/core/init/task_manager.dart';
import '../../core/components/widget/profile_item.dart';
import '../../core/constants/theme.dart';
import '../../core/service/firebase_service.dart';
import '../authentication/resetpassword/reset_password.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({required this.title});
  final String title;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditingText = false;
  late TextEditingController _editingController;
  String initialText = FirebaseService.name;

  @override
  void initState() {
    super.initState();

    _editingController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _editingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAppPrimaryColor,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppBarButton(
                        icon: Icons.arrow_back,
                      ),
                    ],
                  ),
                ),
                AvatarImage(),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(height: 30),
                _editTitleTextField(),
                const SizedBox(height: 20),
                const Text(
                  'Mobile App Developer',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontFamily: "Poppins"),
                ),
                ProfileListItems(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _editTitleTextField() {
    if (_isEditingText) {
      return Center(
        child: TextField(
          onSubmitted: (newValue) {
            setState(() {
              initialText = newValue;
              _isEditingText = false;
              FirebaseService.firestore
                  .collection("Users")
                  .doc(FirebaseService.user!.uid)
                  .set({
                "name": newValue,
              });
            });
          },
          autofocus: true,
          controller: _editingController,
        ),
      );
    }
    return InkWell(
        onTap: () {
          setState(() {
            _isEditingText = true;
          });
        },
        child: Text(
          initialText,
          style: const TextStyle(
            color: lightblue,
            fontSize: 30.0,
          ),
        ));
  }
}

class AppBarButton extends StatelessWidget {
  final IconData icon;

  AppBarButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kAppPrimaryColor,
            boxShadow: [
              BoxShadow(
                color: kLightBlack,
                offset: const Offset(1, 1),
                blurRadius: 10,
              ),
              BoxShadow(
                color: kWhite,
                offset: const Offset(-1, -1),
                blurRadius: 10,
              ),
            ]),
        child: Icon(
          icon,
          color: fCL,
        ),
      ),
    );
  }
}

class AvatarImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      padding: const EdgeInsets.all(8),
      decoration: avatarDecoration,
      child: Container(
        decoration: avatarDecoration,
        padding: const EdgeInsets.all(3),
        child: Container(
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage("assets/images/avatar.png"))),
        ),
      ),
    );
  }
}

class ProfileListItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResetPasswordScreen(),
                  ));
            },
            child: const ProfileListItem(
              icon: Icons.password,
              text: 'Reset Password',
            ),
          ),
          GestureDetector(
            onTap: () async {
              await DBHelper.deleteDb();
              Provider.of<TaskManager>(context, listen: false).deleteAllTask();
              await FirebaseService.logOut(context);
            },
            child: const ProfileListItem(
              icon: Icons.hail_outlined,
              text: 'Logout',
              hasNavigation: false,
            ),
          ),
        ],
      ),
    );
  }
}
