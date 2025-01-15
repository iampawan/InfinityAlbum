import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_albums/data/models/album.dart';
import 'package:infinity_albums/data/models/photo.dart';
import 'package:infinity_albums/data/respositories/album_repository.dart';
import 'package:infinity_albums/data/services/isar_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'album_repository_test.mocks.dart';

@GenerateMocks([Dio, IsarService])
void main() {
  late AlbumRepository albumRepository;
  late MockDio mockDio;
  late MockIsarService mockIsarService;

  const String baseUrl = 'https://jsonplaceholder.typicode.com';

  setUp(() {
    mockDio = MockDio();
    mockIsarService = MockIsarService();
    albumRepository = AlbumRepository(
      dio: mockDio,
      isarService: mockIsarService,
    );
  });

  group('Album repository', () {
    test('returns cached albums when available', () async {
      final cachedAlbums = [
        Album()
          ..albumId = 1
          ..title = 'Cached Album',
      ];

      // Mock Isar service to return cached albums
      when(mockIsarService.getAlbums()).thenAnswer((_) async => cachedAlbums);

      final result = await albumRepository.getAlbums();

      expect(result, equals(cachedAlbums));
      verify(mockIsarService.getAlbums()).called(1);
      verifyNever(mockDio.get(any)); // API should not be called
    });
    test('getAlbums returns list of albums', () async {
      when(mockIsarService.getAlbums()).thenAnswer((_) async => []);

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
      verify(mockIsarService.getAlbums()).called(1);
      verify(mockIsarService.saveAlbums(any)).called(1);
    });

    test('throws exception when both cache and API fail', () async {
      when(mockIsarService.getAlbums()).thenThrow(Exception('Cache error'));
      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
      ));

      expect(() => albumRepository.getAlbums(), throwsException);
    });
  });

  group('getPhotosForAlbum', () {
    const albumId = 1;

    test('returns cached photos when available', () async {
      final cachedPhotos = [
        Photo()
          ..photoId = 1
          ..albumId = albumId
          ..title = 'Cached Photo'
          ..url = 'test.com'
          ..thumbnailUrl = 'test.com/thumb',
      ];

      when(mockIsarService.hasPhotosForAlbum(albumId))
          .thenAnswer((_) async => true);

      when(mockIsarService.getPhotosByAlbumId(albumId))
          .thenAnswer((_) async => cachedPhotos);

      final result = await albumRepository.getPhotosForAlbum(albumId);

      expect(result, equals(cachedPhotos));
      verify(mockIsarService.getPhotosByAlbumId(albumId)).called(1);
      verifyNever(mockDio.get(any));
    });

    test('fetches from API when cache is empty', () async {
      when(mockIsarService.hasPhotosForAlbum(albumId))
          .thenAnswer((_) async => false);

      when(mockDio.get(
        'https://jsonplaceholder.typicode.com/photos',
        queryParameters: {'albumId': albumId},
      )).thenAnswer((_) async => Response(
            data: [
              {
                'id': 1,
                'albumId': albumId,
                'title': 'API Photo',
                'url': 'test.com',
                'thumbnailUrl': 'test.com/thumb'
              }
            ],
            statusCode: 200,
            requestOptions: RequestOptions(
              path: 'https://jsonplaceholder.typicode.com/photos',
            ),
          ));

      final result = await albumRepository.getPhotosForAlbum(albumId);

      expect(result.length, 1);
      expect(result.first.title, 'API Photo');
      verifyNever(mockIsarService.getPhotosByAlbumId(albumId));
      verify(mockIsarService.savePhotos(any, albumId)).called(1);
    });

    test('throws exception when both cache and API fail', () async {
      when(mockIsarService.getPhotosByAlbumId(albumId))
          .thenThrow(Exception('Cache error'));
      when(mockDio.get(any)).thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
      ));

      expect(() => albumRepository.getPhotosForAlbum(albumId), throwsException);
    });
  });
}
