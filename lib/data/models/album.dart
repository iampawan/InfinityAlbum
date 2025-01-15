import 'package:infinity_albums/data/models/photo.dart';

class Album {
  final int id;
  final String title;

  Album({required this.id, required this.title});

  List<Photo> get photos => [
        Photo(id: 1, albumId: id, title: 'Photo 1', url: '', thumbnailUrl: ''),
        Photo(id: 2, albumId: id, title: 'Photo 2', url: '', thumbnailUrl: ''),
        Photo(id: 3, albumId: id, title: 'Photo 3', url: '', thumbnailUrl: ''),
        Photo(id: 4, albumId: id, title: 'Photo 4', url: '', thumbnailUrl: ''),
        Photo(id: 5, albumId: id, title: 'Photo 5', url: '', thumbnailUrl: ''),
        Photo(id: 6, albumId: id, title: 'Photo 6', url: '', thumbnailUrl: ''),
      ];

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
    );
  }
}
