import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';
import '../controllers/favorites_controller.dart';

class DetailScreen extends StatelessWidget {
  final int showId;
  const DetailScreen({super.key, required this.showId});

  String _stripHtmlTags(String? htmlString) {
    if (htmlString == null) return '';
    return htmlString.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();
    final FavoritesController favoritesController = Get.put(FavoritesController());

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        title: const Text(
          'Detail TV Show',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: apiService.fetchShowDetails(showId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurpleAccent),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat detail:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                      ),
                      onPressed: () {
                        Get.off(() => DetailScreen(showId: showId));
                      },
                      child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Data detail tidak tersedia.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final show = snapshot.data!;
          final String name = show['name'] ?? 'Unknown';
          final String imageUrl = show['image']?['original'] ?? show['image']?['medium'] ?? '';
          final dynamic ratingVal = show['rating']?['average'];
          final String rating = ratingVal != null ? ratingVal.toString() : 'N/A';
          final List<dynamic> genres = show['genres'] ?? [];
          final String summary = _stripHtmlTags(show['summary']);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner/Poster Image
                if (imageUrl.isNotEmpty)
                  Image.network(
                    imageUrl,
                    width: double.infinity,
                    height: 380,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.grey[800],
                      child: const Icon(Icons.movie, size: 80, color: Colors.grey),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    height: 250,
                    color: Colors.grey[800],
                    child: const Icon(Icons.movie, size: 80, color: Colors.grey),
                  ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Obx(() {
                            final isFav = favoritesController.isFavorite(showId);
                            return IconButton(
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border_rounded,
                                color: isFav ? Colors.red : Colors.grey,
                                size: 36,
                              ),
                              onPressed: () {
                                favoritesController.toggleFavorite(show);
                              },
                            );
                          }),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 22),
                          const SizedBox(width: 6),
                          Text(
                            rating,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E2F),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              show['status'] ?? 'Running',
                              style: const TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (genres.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: genres.map<Widget>((genre) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.deepPurpleAccent.withOpacity(0.2),
                                border: Border.all(color: Colors.deepPurpleAccent.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                genre.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 24),

                      const Text(
                        'Sinopsis',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        summary.isNotEmpty ? summary : 'Sinopsis tidak tersedia.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[300],
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
