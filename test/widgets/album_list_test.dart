import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinity_albums/data/models/album.dart';
import 'package:infinity_albums/presentation/widgets/album_list.dart';

void main() {
  group('Album List', () {
    testWidgets('should display album list', (widgetTester) async {
      final albums = [
        Album(id: 1, title: "Album 1"),
        Album(id: 2, title: "Album 2")
      ];

      await widgetTester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: AlbumList(
            albums: albums,
          ),
        ),
      ));

      expect(find.byType(AlbumList), findsOneWidget);
      expect(find.text("Album 1"), findsOneWidget);
      expect(find.text("Album 2"), findsOneWidget);
    });

    testWidgets(
      'AlbumList supports scrolling',
      (widgetTester) async {
        final albums = List.generate(
          50,
          (index) => Album(id: index, title: 'Album $index'),
        );

        await widgetTester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: AlbumList(
              albums: albums,
            ),
          ),
        ));

        expect(find.text('Album 0'), findsOneWidget);

        await widgetTester.drag(find.byType(ListView), const Offset(0, -300));
        await widgetTester.pump();

        expect(find.text('Album 0'), findsNothing);
        expect(find.byType(ListView), findsOneWidget);
      },
    );
  });
}
