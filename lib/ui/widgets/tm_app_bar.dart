import 'package:flutter/material.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/profile_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import '../utils/app_colors.dart';

class TMAppbar extends StatelessWidget implements PreferredSizeWidget {
  const TMAppbar({
    super.key,
    this.isProfileScreenOpen = false,
  });

  final bool isProfileScreenOpen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(isProfileScreenOpen) {
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        title: TmAppBarBody(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TmAppBarBody extends StatefulWidget{
  const TmAppBarBody({super.key});

  @override
  State<TmAppBarBody> createState() => _TmAppBarBodyState();
}

class _TmAppBarBodyState extends State<TmAppBarBody> {
  String fullName = "...";
  String email = "...";

  @override
  void initState() {
    initUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          backgroundColor: Colors.white,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$fullName',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$email',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        IconButton(
            onPressed: () async {
              await AuthController.clearUserData();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const SignInScreen()),
                    (predicate) => false,
              );
            },
            icon: const Icon(Icons.logout))
      ],
    );
  }

  void initUserInfo() {
    AuthController.getUserData().then((value) {
      setState(() {
        fullName = "${value['firstName']} ${value['lastName']}";
        email = "${value['email']}";
      });
    });
  }
}

