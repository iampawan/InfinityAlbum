import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_albums/blocs/album/album_bloc.dart';
import 'package:infinity_albums/blocs/album/album_event.dart';
import 'package:infinity_albums/blocs/album/album_state.dart';
import 'package:infinity_albums/presentation/widgets/photo_card.dart';

class PhotoList extends StatefulWidget {
  final int albumId;

  const PhotoList({super.key, required this.albumId});

  @override
  State<PhotoList> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 101,
      viewportFraction: 0.32,
    );

    context.read<AlbumBloc>().add(LoadPhotosForAlbum(widget.albumId));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, state) {
        if (state is AlbumLoaded) {
          final album = state.albums.firstWhere((e) => e.id == widget.albumId);

          final photos = album.photos.toList();

          return PageView.builder(
            controller: _pageController,
            itemBuilder: (context, index) {
              if (photos.isEmpty) {
                return const Center(
                  child: Text('No photos available'),
                );
              }
              final photo = photos[index % photos.length];
              return PhotoCard(photo: photo);
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
