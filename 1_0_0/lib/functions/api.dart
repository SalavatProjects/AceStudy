import 'dart:convert';

import 'http_client_for_api.dart';

import 'package:http/http.dart' as http;
import '../config/constants.dart';

class Api{

  static Future getJsonUserData(int userId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'get_user_data');
    httpClientApi.setParameters = 'user_id=$userId';
    return await httpClientApi.getWithReturnData();
  }

  static Future checkUserSmartphoneType(int userId, String smartphoneType) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'check_user_smartphone_type');
    httpClientApi.setBodyMap = {
      'user_id': userId,
      'smartphone_type': smartphoneType
    };
    await httpClientApi.postWithoutReturnData();
  }

  static Future setUserAppVesrion(int userId, String appVersion) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'set_user_app_version');
    httpClientApi.setBodyMap = {
      'user_id': userId,
      'app_version': appVersion
    };
    await httpClientApi.postWithoutReturnData();
  }

  static Future getJsonConfig() async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'get_config');
    httpClientApi.setBodyMap = {};
    return await httpClientApi.postWithReturnData();
  }

  static Future getJsonUserVocabulariesWords(int userId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'user_dicts_words');
    httpClientApi.setParameters = 'user_id=$userId';
    return await httpClientApi.getWithReturnData();
  }

  static Future<void> insertVocabulary(String vocabularyName, 
  String vocabularyType, 
  String icon, 
  int userId) async
  {
    HttpClientApi httpClientApi = HttpClientApi(url: 'insert_vocabulary');
    httpClientApi.setBodyMap = {
      'vocabulary_name': vocabularyName,
      'vocabulary_type': vocabularyType,
      'vocabulary_icon': icon,
      'user_id': userId
      };
    await httpClientApi.postWithoutReturnData();
  }

  static Future<void> deleteVocabulary(int vocabularyId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'delete_vocabulary');
    httpClientApi.setParameters = 'vocabulary_id=$vocabularyId';
    await httpClientApi.getWithoutReturnData();
  }

  static Future<void> insertWordsTranslations(
  int vocabularyId, 
  String vocabularyName, 
  Map<String, List<String>> wordsTranslations
  ) async{
    HttpClientApi httpClientApi = HttpClientApi(url: 'insert_words_translations');
    httpClientApi.setBodyMap = {
    'vocabulary_id': vocabularyId,
    'vocabulary_name' : vocabularyName, 
    'words_translations': wordsTranslations
    };
    await httpClientApi.postWithoutReturnData();
  }

  static Future<void> insertInStudentMistakes(int userId, 
  int vocabularyId,
  int? groupId,
  Map<String, List<String>>? wordErrors, 
  Map<String, int> usersAttemptNumber
  ) async{
    HttpClientApi httpClientApi = HttpClientApi(url: 'insert_in_student_mistakes');
    httpClientApi.setBodyMap = {
      'user_id': userId,
      'vocabulary_id': vocabularyId,
      'group_id': groupId,
      'word_errors': wordErrors,
      'users_attempt_number': usersAttemptNumber
    };
    await httpClientApi.postWithoutReturnData();
  }

  static Future checkLoginIsExist(String login) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'check_login_is_exist');
    httpClientApi.setParameters = 'login=$login';
    return await httpClientApi.getWithReturnData();
  }

  static Future checkUserLoginIsExist(int userId, String login) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'check_user_login_is_exist');
    httpClientApi.setParameters = 'user_id=$userId&login=$login';
    return await httpClientApi.getWithReturnData();
  }

  static Future checkPhoneIsExist(String phone) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'check_phone_is_exist');
    httpClientApi.setParameters = 'phone=$phone';
    return await httpClientApi.getWithReturnData();
  }

  static Future<void> send4DigitCode(String phone, int code, bool isReg) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'handle_4_digit_code');
    httpClientApi.setParameters = 'phone=$phone&code=$code&is_reg=$isReg';
    await httpClientApi.getWithoutReturnData();
  }

  static Future<void> saveUser(String name, String surname, String login, String phone, String password, 
  bool isPrivacyPolicyAgree) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'save_user');
    httpClientApi.setBodyMap = {
      'name' : name,
      'surname' : surname,
      'login' : login,
      'phone' : phone,
      'password' : password,
      'privacy_policy' : isPrivacyPolicyAgree
    };
    await httpClientApi.postWithoutReturnData();
  }

  static Future<void> saveUserPassword(String phone, String password) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'save_user_password');
    httpClientApi.setBodyMap = {
      'phone' : phone,
      'password' : password
    };
    await httpClientApi.postWithoutReturnData();
  }

  static Future<void> updateUser(
  int userId, 
  String name, 
  String surname,
  String login) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'update_user');
    httpClientApi.setParameters = 'user_id=$userId&name=$name&surname=$surname&login=$login';
    await httpClientApi.getWithoutReturnData();
    }

  static Future getUserId(String phone) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'get_user_id');
    httpClientApi.setParameters = 'phone=$phone';
    return await httpClientApi.getWithReturnData();
  }

  static Future checkIfUserExist(int userId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'check_if_user_exist');
    httpClientApi.setParameters = 'user_id=$userId';
    return await httpClientApi.getWithReturnData();
  }

  static Future logIn(String phone, String password) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'log_in');
    httpClientApi.setBodyMap = {
      'phone' : phone,
      'password' : password
    };
    return await httpClientApi.postWithReturnData();
  }

  static Future<void> setUpdateToFalse(int userId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'updating_to_false');
    httpClientApi.setParameters = 'user_id=$userId';
    await httpClientApi.getWithoutReturnData();
  }

  static Future getUserVocabulariesCounts(int userId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'get_user_vocabularies_counts');
    httpClientApi.setParameters = 'user_id=$userId';
    return await httpClientApi.getWithReturnData();
  }

  static Future getUserMistakesStatistics(int userId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'get_user_mistakes_statistics');
    httpClientApi.setBodyMap = {
      'user_id': userId
    };
    return await httpClientApi.postWithReturnData();
  }

  static Future<void> clearVocabularyStatistics(int userId, int vocabularyId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'clear_vocabulary_statistics');
    httpClientApi.setParameters = 'user_id=$userId&vocabulary_id=$vocabularyId';
    await httpClientApi.getWithoutReturnData();
  }

  static Future checkUserBalance(int userId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'check_user_balance');
    httpClientApi.setBodyMap = {
      'user_id': userId
    };
    return await httpClientApi.postWithReturnData();
  }

  static Future<void> activateTeacherRole(int userId, bool isTrial) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'activate_teacher_role');
    httpClientApi.setBodyMap = {
      'user_id': userId,
      'is_trial': isTrial,
    };
    await httpClientApi.postWithoutReturnData();
  }

  static Future<void> checkUserRoleTime(int userId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'check_user_role_time');
    httpClientApi.setBodyMap = {
      'user_id': userId
    };
    await httpClientApi.postWithoutReturnData();
    /* Map _bodyMap = {
      'user_id': userId
    };
    var response = await http.post(Uri.parse('${Constants.getScheme}://${Constants.getAddress}/${Constants.getApi}/check_user_role_time'),
    body: jsonEncode(_bodyMap));
    print(response.body); */
  }

  static Future getGuide() async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'get_guide');
    httpClientApi.setBodyMap = {};
    return await httpClientApi.postWithReturnData();
  }

  static Future createGroup(
    int userId,
    String name,
    String icon
  ) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'create_group');
    httpClientApi.setBodyMap = {
      'user_id' : userId,
      'name' : name,
      'icon' : icon,
    };
    await httpClientApi.postWithoutReturnData();
  }

  static getGroups(int userId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'get_groups');
    httpClientApi.setParameters = 'user_id=$userId';
    return await httpClientApi.getWithReturnData();
  }

  static deleteGroup(int groupId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'delete_group');
    httpClientApi.setBodyMap = {
      'group_id' : groupId
    };
    await httpClientApi.postWithoutReturnData();
  }

  static serchParticipants(int userId, String login) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'search_participants');
    httpClientApi.setBodyMap = {
      'user_id': userId,
      'login': login
    };
    return await httpClientApi.postWithReturnData();
  }

  static updateGroup(int groupId, List<int> vocabulariesId, List<int> groupMembersId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'update_group');
    httpClientApi.setBodyMap = {
      'group_id': groupId,
      'vocabularies_id': vocabulariesId,
      'group_members_id': groupMembersId
    };
    await httpClientApi.postWithoutReturnData();
  }
  
  static Future getUserGroups(int userId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'get_user_groups');
    httpClientApi.setBodyMap = {
      'user_id': userId
    };
    return await httpClientApi.postWithReturnData();
  }

  static Future getStudentsStatisticsByVocabulary(int groupId, int vocabularyId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'get_students_statistics_by_vocabulary');
    httpClientApi.setBodyMap = {
      'group_id': groupId,
      'vocabulary_id': vocabularyId
    };
    return await httpClientApi.postWithReturnData();
  }

  static Future clearStudentStatistics(int studentId, int vocabularyId, int groupId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'clear_student_statistics');
    httpClientApi.setBodyMap = {
      'student_id': studentId,
      'vocabulary_id': vocabularyId,
      'group_id': groupId
    };
    await httpClientApi.postWithoutReturnData();
  }

  static Future getStudentStatisticByGroup(int userId, int groupId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'get_student_statistic_by_group');
    httpClientApi.setBodyMap = {
      'user_id': userId,
      'group_id': groupId
    };
    return await httpClientApi.postWithReturnData();
  }
}