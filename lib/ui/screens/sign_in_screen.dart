import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/sign_in_controller.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_bar_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final SignInController signInController = Get.find<SignInController>();

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 90),
              Text(
                'Login',
                style: textTheme.titleLarge
                    ?.copyWith(fontSize: 28, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              _buildSignInForm(),
              const SizedBox(height: 24),
              Center(
                child: Column(
                  children: [
                    _buildSignUpSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpSection() {
    return RichText(
      text: TextSpan(
        text: "Don't have an Account? ",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.5,
        ),
        children: [
          TextSpan(
              text: "Sign Up",
              style: const TextStyle(color: AppColors.themeColor),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignUp),
        ],
      ),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _emailTEController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'Email'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _passwordTEController,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Password'),
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return 'Enter your password';
              }
              if (value!.length <= 4) {
                return 'Enter a password which is more than 3 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          GetBuilder<SignInController>(
            builder: (controller) {
              return Visibility(
                visible: !controller.inProgress,
                replacement: const CenteredCircularProgressIndicator(),
                child: ElevatedButton(
                  onPressed: _onTapNextButton,
                  child: const Icon(Icons.arrow_circle_right_outlined),
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  void _onTapNextButton() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _signIn();
  }

  // Future<void> _signIn() async {
  //   _inProgress = true;
  //   setState(() {});
  //
  //   Map<String, dynamic> requestBody = {
  //     'email': _emailTEController.text.trim(),
  //     'password': _passwordTEController.text,
  //   };
  //
  //   final NetworkResponse response =
  //       await NetworkCaller.postRequest(url: Urls.login, body: requestBody);
  //   _inProgress = false;
  //   setState(() {});
  //   if (response.isSuccess) {
  //     await AuthController.saveAccessToken(
  //         response.responseData['data']['token']);
  //
  //     final firstName = response.responseData['data']['user']['firstName'];
  //     final lastName = response.responseData['data']['user']['lastName'];
  //     final email = response.responseData['data']['user']['email'];
  //     AuthController.saveUserData(firstName, lastName, email);
  //
  //     Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const MainBottomNavBarScreen(
  //             // firstName: firstName,
  //             // lastName: lastName,
  //             // email: email,
  //           ),
  //         ),
  //         (value) => false);
  //   } else {
  //     showSnackBarMessage(context, response.errorMessage, true);
  //   }
  // }


  Future<void> _signIn() async {
    final bool result = await signInController.signIn(
      _emailTEController.text.trim(),
      _passwordTEController.text,
    );

    if (result) {
      Get.offAll(const MainBottomNavBarScreen());
      showSnackBarMessage(context, 'Login Successful');
    } else {
      showSnackBarMessage(context, signInController.errorMessage!, true);
    }
  }

  void _onTapSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }
}
