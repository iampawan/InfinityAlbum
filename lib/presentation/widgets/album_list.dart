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
  late ScrollController _scrollController;
  late List<Album> _infiniteAlbums;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _infiniteAlbums = List.from(widget.albums);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    if (currentScroll >= maxScroll - 200) {
      setState(() {
        _infiniteAlbums.addAll(widget.albums);
      });
    }

    if (currentScroll <= 200) {
      setState(() {
        _infiniteAlbums.insertAll(0, widget.albums);
        _scrollController.jumpTo(_scrollController.position.pixels + 100);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _infiniteAlbums.length,
      itemBuilder: (context, index) {
        final album = _infiniteAlbums[index];
        return AlbumItem(album: album);
      },
    );
  }
}
