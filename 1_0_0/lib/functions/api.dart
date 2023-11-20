import 'http_client_for_api.dart';

class Api{

  static Future getJsonUserData(int userId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'get_user_data');
    httpClientApi.setParameters = 'user_id=$userId';
    return await httpClientApi.getWithReturnData();
  }

  static Future getJsonUserVocabulariesWords(int userId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'user_dicts_words');
    httpClientApi.setParameters = 'user_id=$userId';
    return await httpClientApi.getWithReturnData();
  }

  static Future<void> insertVocabulary(String vocabularyName, String vocabularyType, int userId) async
  {
    HttpClientApi httpClientApi = HttpClientApi(url: 'insert_vocabulary');
    httpClientApi.setBodyMap = {
      'vocabulary_name': vocabularyName,
      'vocabulary_type': vocabularyType,
      'user_id': userId
      };
    await httpClientApi.postWithoutReturnData();
  }

  static Future<void> deleteVocabulary(int vocabularyId) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'delete_vocabulary');
    httpClientApi.setParameters = 'vocabulary_id=$vocabularyId';
    await httpClientApi.getWithoutReturnData();
  }

  static Future<void> insertWordsTranslations(int vocabularyId, Map<String, List<String>> wordsTranslations) async{
    HttpClientApi httpClientApi = HttpClientApi(url: 'insert_words_translations');
    httpClientApi.setBodyMap = {'vocabulary_id': vocabularyId, 'words_translations': wordsTranslations};
    await httpClientApi.postWithoutReturnData();
  }

  static Future<void> insertInStudentMistakes(int userId, int vocabularyId, Map<String, List<String>> wordErrors, int attemptNumber) async{
    HttpClientApi httpClientApi = HttpClientApi(url: 'insert_in_student_mistakes');
    httpClientApi.setBodyMap = {
      'user_id': userId,
      'vocabulary_id': vocabularyId,
      'word_errors': wordErrors,
      'attempt_number': attemptNumber
    };
    await httpClientApi.postWithoutReturnData();
  }

  static Future checkLoginIsUnique(String login) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'check_login_is_unique');
    httpClientApi.setParameters = 'login=$login';
    return await httpClientApi.getWithReturnData();
  }

  static Future checkPhoneIsUnique(String phone) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'check_phone_is_unique');
    httpClientApi.setParameters = 'phone=$phone';
    return await httpClientApi.getWithReturnData();
  }

  static Future<void> send4DigitCode(String phone, int code, bool isReg) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'handle_4_digit_code');
    httpClientApi.setParameters = 'phone=$phone&code=$code&is_reg=$isReg';
    await httpClientApi.getWithoutReturnData();
  }

  static Future<void> saveUser(String name, String surname, String login, String phone, String password) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'save_user');
    httpClientApi.setBodyMap = {
      'name' : name,
      'surname' : surname,
      'login' : login,
      'phone' : phone,
      'password' : password
    };
    await httpClientApi.postWithoutReturnData();
  }

  static Future getUserId(String login) async {
    HttpClientApi httpClientApi = HttpClientApi(url: 'get_user_id');
    httpClientApi.setParameters = 'login=$login';
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
}