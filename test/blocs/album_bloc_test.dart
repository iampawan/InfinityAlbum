import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_albums/blocs/album/album_bloc.dart';
import 'package:infinity_albums/blocs/album/album_event.dart';
import 'package:infinity_albums/blocs/album/album_state.dart';
import 'package:infinity_albums/data/models/album.dart';
import 'package:infinity_albums/data/respositories/album_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'album_bloc_test.mocks.dart';

@GenerateMocks([AlbumRepository])
void main() {
  late MockAlbumRepository mockAlbumRepository;
  late AlbumBloc bloc;

  setUp(() {
    mockAlbumRepository = MockAlbumRepository();
    bloc = AlbumBloc(mockAlbumRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('Album bloc tests', () {
    test('Initial state is AlbumInitial', () {
      expect(bloc.state, isA<AlbumInitial>());
    });

    blocTest<AlbumBloc, AlbumState>(
      'emits [AlbumLoading, AlbumLoaded] when LoadAlbums is added',
      build: () {
        when(mockAlbumRepository.getAlbums()).thenAnswer(
          (_) async => [
            Album()
              ..id = 1
              ..title = 'Album 1',
          ],
        );
        return bloc;
      },
      act: (bloc) => bloc.add(LoadAlbums()),
      expect: () => [
        isA<AlbumLoading>(),
        isA<AlbumLoaded>(),
      ],
    );
  });
}
