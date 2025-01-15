import 'package:infinity_albums/data/models/album.dart';
import 'package:isar/isar.dart';

part 'photo.g.dart';

@Collection()
class Photo {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int photoId;

  @Index()
  late int albumId;
  late String title;
  late String url;
  late String thumbnailUrl;

  final album = IsarLink<Album>();

  Photo();

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo()
      ..photoId = json['id']
      ..albumId = json['albumId']
      ..title = json['title']
      ..url = json['url']
      ..thumbnailUrl = json['thumbnailUrl'];
  }
}
