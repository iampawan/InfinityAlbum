import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_albums/data/respositories/album_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'album_repository_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late AlbumRepository albumRepository;
  late MockDio mockDio;

  const String baseUrl = 'https://jsonplaceholder.typicode.com';

  setUp(() {
    mockDio = MockDio();
    albumRepository = AlbumRepository(mockDio);
  });

  group('Album repository', () {
    test('getAlbums returns list of albums', () async {
      when(mockDio.get('$baseUrl/albums')).thenAnswer(
        (_) async => Response(
            requestOptions: RequestOptions(
              path: '$baseUrl/albums',
            ),
            data: [
              {'id': 1, 'title': 'Album 1'},
            ],
            statusCode: 200),
      );

      final albums = await albumRepository.getAlbums();
      expect(albums.length, 1);
      expect(albums.first.title, 'Album 1');
    });
    test('getPhotosForAlbum returns list of photos', () async {
      const albumId = 1;
      when(mockDio.get(
        'https://jsonplaceholder.typicode.com/photos',
        queryParameters: {'albumId': albumId},
      )).thenAnswer((_) async => Response(
            data: [
              {
                'id': 1,
                'albumId': albumId,
                'title': 'Photo 1',
                'url': 'http://example.com/photo1.jpg',
                'thumbnailUrl': 'http://example.com/thumb1.jpg',
              }
            ],
            statusCode: 200,
            requestOptions: RequestOptions(
              path: 'https://jsonplaceholder.typicode.com/photos',
            ),
          ));

      final photos = await albumRepository.getPhotosForAlbum(albumId);
      expect(photos.length, 1);
      expect(photos.first.title, 'Photo 1');
    });

    test('getAlbums throws exception on error', () {
      when(mockDio.get('https://jsonplaceholder.typicode.com/albums'))
          .thenThrow(DioException(
        requestOptions: RequestOptions(
          path: 'https://jsonplaceholder.typicode.com/albums',
        ),
      ));

      expect(() => albumRepository.getAlbums(), throwsException);
    });
  });
}
