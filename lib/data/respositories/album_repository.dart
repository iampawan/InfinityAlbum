import 'package:dio/dio.dart';
import 'package:infinity_albums/data/models/album.dart';
import 'package:infinity_albums/data/models/photo.dart';

class AlbumRepository {
  final Dio _dio;

  // Dummy Url for now as we are just using placeholders
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  AlbumRepository([Dio? dio]) : _dio = dio ?? Dio();

  // Get all albums from the API
  Future<List<Album>> getAlbums() async {
    try {
      final response = await _dio.get('$baseUrl/albums');
      final albums =
          (response.data as List).map((json) => Album.fromJson(json)).toList();

      return albums;
    } catch (e) {
      throw Exception('Failed to load albums - $e');
    }
  }

  // Get All Photos for a specific album
  Future<List<Photo>> getPhotosForAlbum(int albumId) async {
    try {
      final response = await _dio.get('$baseUrl/photos', queryParameters: {
        'albumId': albumId,
      });

      final photos =
          (response.data as List).map((json) => Photo.fromJson(json)).toList();

      return photos;
    } catch (e) {
      throw Exception('Failed to load photos - $e');
    }
  }
}
