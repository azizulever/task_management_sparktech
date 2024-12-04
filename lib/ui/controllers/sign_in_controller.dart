import 'package:get/get.dart';
import 'package:task_manager/data/models/network_response.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';


class SignInController extends GetxController {
  bool _inProgress = false;
  String? _errorMessage;

  String? get errorMessage=> _errorMessage;

  bool get inProgress => _inProgress;

  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;
    _inProgress = true;
    update();
    Map<String, dynamic> requestBody = {
      "email": email,
      "password": password,
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.login,
      body: requestBody,
    );

    if (response.isSuccess) {
      await AuthController.saveAccessToken(
          response.responseData['data']['token']);

      final firstName = response.responseData['data']['user']['firstName'];
      final lastName = response.responseData['data']['user']['lastName'];
      final email = response.responseData['data']['user']['email'];
      AuthController.saveUserData(firstName, lastName, email);
      // LoginModel loginModel = LoginModel.fromJson(response.responseData);
      // await AuthController.saveAccessToken(loginModel.token!);
      // await AuthController.saveUserData(loginModel.data!);
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    _inProgress = false;
    update();
    return isSuccess;
  }
}