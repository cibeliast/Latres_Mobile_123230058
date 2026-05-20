import 'package:get/get.dart';
import '../services/api_service.dart';

class ShowsController extends GetxController {
  final ApiService _apiService = ApiService();

  var showsList = <dynamic>[].obs;
  var filteredShowsList = <dynamic>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchShows();
  }

  Future<void> fetchShows() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final data = await _apiService.fetchShows();
      showsList.assignAll(data);
      filteredShowsList.assignAll(data);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void searchShows(String query) {
    if (query.trim().isEmpty) {
      filteredShowsList.assignAll(showsList);
    } else {
      final searchResult = showsList.where((show) {
        final name = (show['name'] ?? '').toString().toLowerCase();
        return name.contains(query.toLowerCase());
      }).toList();
      filteredShowsList.assignAll(searchResult);
    }
  }
}
