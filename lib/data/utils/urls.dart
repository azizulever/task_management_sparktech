class Urls {
  static const String _baseUrl = 'http://206.189.138.45:8052';
  static const String registration = '$_baseUrl/user/register';
  static const String login = '$_baseUrl/user/login';
  static String getEmail(String email) {
    return '$_baseUrl/RecoverVerifyEmail/$email';
  }

  static const String recoverResetPassword = '$_baseUrl/RecoverResetPassword';
  static const String addNewTask = '$_baseUrl/task/create-task';

  static const String newTaskList = '$_baseUrl/task/get-all-task';
  static const String completedTaskList =
      '$_baseUrl/listTaskByStatus/Completed';
  static const String taskStatusCount = '$_baseUrl/taskStatusCount';
  static String changeStatus(String taskId, String status) =>
      '$_baseUrl/updateTaskStatus/$taskId/$status';

  static String deleteTask(String taskId) =>
      '$_baseUrl/task/delete-task/$taskId';
}
