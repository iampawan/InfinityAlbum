import 'package:flutter/material.dart';
import 'package:infinity_albums/data/models/album.dart';

class AlbumItem extends StatelessWidget {
  const AlbumItem({super.key, required this.album});

  final Album album;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            album.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
