import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var username = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSession = prefs.getBool('loginData') ?? false;
    if (hasSession) {
      isLoggedIn.value = true;
      username.value = prefs.getString('username') ?? 'User';
    }
  }

  Future<bool> login(String inputUsername, String inputPassword) async {
    if (inputUsername.trim().isEmpty || inputPassword.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Username dan Password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginData', true);
    await prefs.setString('username', inputUsername);
    
    username.value = inputUsername;
    isLoggedIn.value = true;
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
    
    isLoggedIn.value = false;
    username.value = '';
    
    Get.snackbar(
      'Success',
      'Berhasil Logout',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
