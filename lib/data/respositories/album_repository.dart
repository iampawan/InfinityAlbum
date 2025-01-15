import 'package:dio/dio.dart';
import 'package:infinity_albums/data/models/album.dart';
import 'package:infinity_albums/data/models/photo.dart';
import 'package:infinity_albums/data/services/isar_service.dart';

class AlbumRepository {
  final Dio _dio;
  final IsarService _isarService;

  // Dummy Url for now as we are just using placeholders
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  AlbumRepository({Dio? dio, IsarService? isarService})
      : _dio = dio ?? Dio(),
        _isarService = isarService ?? IsarService();

  // Get all albums from the API
  Future<List<Album>> getAlbums() async {
    try {
      // Check local database first
      final cachedAlbums = await _isarService.getAlbums();
      if (cachedAlbums.isNotEmpty) {
        return cachedAlbums;
      }

      // Fetch from API if cache is empty
      final response = await _dio.get('$baseUrl/albums');
      final albums =
          (response.data as List).map((json) => Album.fromJson(json)).toList();

      await _isarService.saveAlbums(albums);
      return albums;
    } catch (e) {
      throw Exception('Failed to load albums');
    }
  }

  // Get All Photos for a specific album
  Future<List<Photo>> getPhotosForAlbum(int albumId) async {
    try {
      // Check local database first
      final hasCache = await _isarService.hasPhotosForAlbum(albumId);
      if (hasCache) {
        return await _isarService.getPhotosByAlbumId(albumId);
      }

      // Fetch from API if cache is empty
      final response = await _dio.get(
        '$baseUrl/photos',
        queryParameters: {'albumId': albumId},
      );

      final photos =
          (response.data as List).map((json) => Photo.fromJson(json)).toList();

      // Save to local database
      await _isarService.savePhotos(photos, albumId);
      return photos;
    } catch (e) {
      throw Exception(
          'Failed to load photos for album $albumId: ${e.toString()}');
    }
  }
}
