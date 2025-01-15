import 'package:flutter/widgets.dart';
import 'package:infinity_albums/data/models/album.dart';
import 'package:infinity_albums/presentation/widgets/album_item.dart';

class AlbumList extends StatefulWidget {
  final List<Album> albums;

  const AlbumList({super.key, required this.albums});

  @override
  State<AlbumList> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.albums.length,
      itemBuilder: (context, index) {
        final album = widget.albums[index];
        return AlbumItem(album: album);
      },
    );
  }
}
