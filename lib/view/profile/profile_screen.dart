import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_management/core/components/profile_item.dart';
import 'package:task_management/core/constants/theme.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({required this.title});
  final String title;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                const Text(
                  'Taha Furkan',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Mobile App Developer',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontFamily: "Poppins"),
                ),
                ProfileListItems(),
              ],
            ),
          )
        ],
      ),
    );
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

class SocialIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SocialIcon(
          color: const Color(0xFF102397),
          iconData: facebook,
          onPressed: () {},
        ),
        SocialIcon(
          color: const Color(0xFFff4f38),
          iconData: googlePlus,
          onPressed: () {},
        ),
        SocialIcon(
          color: const Color(0xFF38A1F3),
          iconData: twitter,
          onPressed: () {},
        ),
        SocialIcon(
          color: const Color(0xFF2867B2),
          iconData: linkedin,
          onPressed: () {},
        )
      ],
    );
  }
}

class SocialIcon extends StatelessWidget {
  final Color color;
  final IconData iconData;
  final Function onPressed;

  SocialIcon(
      {required this.color, required this.iconData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Container(
        width: 45.0,
        height: 45.0,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: RawMaterialButton(
          shape: const CircleBorder(),
          onPressed: () => onPressed,
          child: Icon(iconData, color: Colors.white),
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
        children: const <Widget>[
          ProfileListItem(
            icon: Icons.settings,
            text: 'Settings',
          ),
          ProfileListItem(
            icon: Icons.hail_outlined,
            text: 'Logout',
            hasNavigation: false,
          ),
        ],
      ),
    );
  }
}
