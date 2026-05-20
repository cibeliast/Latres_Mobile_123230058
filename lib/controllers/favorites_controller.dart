import 'package:get/get.dart';
import 'package:hive/hive.dart';

class FavoritesController extends GetxController {
  late Box _favoritesBox;
  var favoritesList = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    _favoritesBox = Hive.box('favorites');
    loadFavorites();
  }

  void loadFavorites() {
    favoritesList.assignAll(_favoritesBox.values.toList());
  }
  bool isFavorite(int id) {
    return favoritesList.any((show) => show['id'] == id);
  }
  Future<void> toggleFavorite(Map<String, dynamic> show) async {
    final int id = show['id'];
    
    if (isFavorite(id)) {
      await _favoritesBox.delete(id);
      loadFavorites();
      Get.snackbar(
        'Favorites',
        '${show['name']} dihapus dari Favorit',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      final showData = {
        'id': show['id'],
        'name': show['name'],
        'image': show['image'],
        'rating': show['rating'],
        'genres': show['genres'],
        'summary': show['summary'],
      };
      await _favoritesBox.put(id, showData);
      loadFavorites();
      Get.snackbar(
        'Favorites',
        '${show['name']} ditambahkan ke Favorit',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> removeFavorite(int id, String name) async {
    if (_favoritesBox.containsKey(id)) {
      await _favoritesBox.delete(id);
      loadFavorites();
      Get.snackbar(
        'Favorites',
        '$name dihapus dari Favorit',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }
}
