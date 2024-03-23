class Urls{
  static const String _baseUrl = "https://task.teamrabbil.com/api/v1/";
  static String registio = "$_baseUrl/registration";
  static String login = "$_baseUrl/login";
  static String addNewTask = "$_baseUrl/createTask";
  static String taskcountBystatus = "$_baseUrl/taskStatusCount";
  static String newTaskList = "$_baseUrl/listTaskByStatus/New";
  static String completedTaskList = "$_baseUrl/listTaskByStatus/Completed";
  static String progressTaskList = "$_baseUrl/listTaskByStatus/Progress";
  static String cancelTaskList = "$_baseUrl/listTaskByStatus/Cancled";
  static String deleateTaskList(String id) => "$_baseUrl/deleteTask/$id";
  static String updateProfile = '$_baseUrl/profileUpdate';
  static String updateTaskStatus(String id, String status) => "$_baseUrl/updateTaskStatus/$id/$status";

}