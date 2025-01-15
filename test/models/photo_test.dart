import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_albums/data/models/photo.dart';

void main() {
  group('Photo Model', () {
    test('should create Photo from json', () {
      final json = {
        'id': 1,
        'albumId': 1,
        'title': 'Test photo',
        'url': 'https://google.com/photo.jpg',
        'thumbnailUrl': 'https://google.com/photo_thumb.jpg',
      };

      final photo = Photo.fromJson(json);

      expect(photo.photoId, 1);
      expect(photo.albumId, 1);
      expect(photo.title, 'Test photo');
      expect(photo.url, 'https://google.com/photo.jpg');
      expect(photo.thumbnailUrl, 'https://google.com/photo_thumb.jpg');
    });
  });
}
