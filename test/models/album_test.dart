import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_albums/data/models/album.dart';

void main() {
  group('Album Model', () {
    test('should create Album from json', () {
      final json = {
        'id': 1,
        'title': 'Test album',
      };

      final album = Album.fromJson(json);

      expect(album.id, 1);
      expect(album.title, 'Test album');
    });
  });
}
