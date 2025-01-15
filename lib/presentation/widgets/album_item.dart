import 'package:flutter/material.dart';
import 'package:infinity_albums/data/models/album.dart';
import 'package:infinity_albums/presentation/widgets/photo_list.dart';

class AlbumItem extends StatefulWidget {
  const AlbumItem({super.key, required this.album});

  final Album album;

  @override
  State<AlbumItem> createState() => _AlbumItemState();
}

class _AlbumItemState extends State<AlbumItem> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            widget.album.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: PhotoList(albumId: widget.album.id),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Divider(
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(AlbumItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only rebuild if album actually changed
    if (oldWidget.album.albumId != widget.album.albumId) {
      setState(() {});
    }
  }
}
