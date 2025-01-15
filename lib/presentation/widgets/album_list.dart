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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _infiniteAlbums = List.from(widget.albums);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isLoading) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final minScroll = _scrollController.position.minScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const threshold = 200.0;
    if (currentScroll <= minScroll + 1) {
      _isLoading = true;

      if (currentScroll <= minScroll + 1) {
        _scrollController.animateTo(
          maxScroll + (threshold * 6),
          duration: const Duration(milliseconds: 50),
          curve: Curves.easeOut,
        );
      }

      _isLoading = false;
    }
    // Scrolling down
    if (currentScroll >= maxScroll - threshold) {
      _isLoading = true;
      setState(() {
        _infiniteAlbums.addAll(widget.albums);
      });
      _isLoading = false;
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _infiniteAlbums.length,
      cacheExtent: 500,
      itemBuilder: (context, index) {
        final album = _infiniteAlbums[index];
        return RepaintBoundary(
          child: AlbumItem(
            key: ValueKey('album_${album.albumId}_$index'),
            album: album,
          ),
        );
      },
    );
  }
}
