import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinity_albums/data/models/photo.dart';

class PhotoCard extends StatelessWidget {
  final Photo photo;
  const PhotoCard({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: CachedNetworkImage(
              imageUrl: "https://picsum.photos/300/200?random=${photo.id}",
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
              errorWidget: (context, url, error) => const Center(
                    child: Center(
                      child: Icon(Icons.photo, size: 100, color: Colors.grey),
                    ),
                  )),
        ),
      ),
    );
  }
}
