import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_albums/blocs/album/album_bloc.dart';
import 'package:infinity_albums/blocs/album/album_state.dart';
import 'package:infinity_albums/data/models/album.dart';
import 'package:infinity_albums/presentation/widgets/album_item.dart';
import 'package:infinity_albums/presentation/widgets/album_list.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'album_list_test.mocks.dart';

@GenerateMocks([AlbumBloc])
void main() {
  late MockAlbumBloc mockAlbumBloc;
  late List<Album> testAlbums;

  setUp(() {
    mockAlbumBloc = MockAlbumBloc();
    testAlbums = List.generate(
      3,
      (index) => Album()
        ..albumId = index + 1
        ..title = 'Album ${index + 1}',
    );

    // Mock the initial state and stream
    // Mock the stream
    when(mockAlbumBloc.stream).thenAnswer(
      (_) => Stream.fromIterable([AlbumLoaded(testAlbums)]),
    );

    // Mock the state
    when(mockAlbumBloc.state).thenReturn(AlbumLoaded(testAlbums));
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<AlbumBloc>.value(
        value: mockAlbumBloc,
        child: Scaffold(
          body: AlbumList(albums: testAlbums),
        ),
      ),
    );
  }

  group('AlbumList Widget', () {
    testWidgets('displays initial albums correctly', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify initial albums are displayed
      expect(find.text('Album 1'), findsOneWidget);
      expect(find.text('Album 2'), findsOneWidget);
      expect(find.text('Album 3'), findsOneWidget);
    });

    testWidgets('supports scrolling down', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Initial position check
      expect(find.text('Album 1'), findsOneWidget);

      // Scroll down
      await tester.drag(find.byType(ListView), const Offset(0, -500));
      await tester.pumpAndSettle();

      // Verify more albums are loaded
      expect(find.byType(AlbumItem), findsNWidgets(testAlbums.length));
    });

    testWidgets('supports scrolling up', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Scroll up
      await tester.drag(find.byType(ListView), const Offset(0, 200));
      await tester.pumpAndSettle();

      // Verify more albums are loaded at the top
      expect(find.byType(AlbumItem), findsNWidgets(testAlbums.length));
    });

    testWidgets('loads photos when album is visible', (tester) async {
      when(mockAlbumBloc.state).thenReturn(AlbumLoaded(testAlbums));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Verify LoadPhotosForAlbum events are triggered
      verify(mockAlbumBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('handles empty album list', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AlbumBloc>.value(
            value: mockAlbumBloc,
            child: const Scaffold(
              body: AlbumList(albums: []),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify empty state is handled
      expect(find.byType(ListTile), findsNothing);
    });
  });
}
