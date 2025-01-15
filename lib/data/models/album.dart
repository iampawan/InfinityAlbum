import 'package:infinity_albums/data/models/photo.dart';
import 'package:isar/isar.dart';

part 'album.g.dart';

@Collection()
class Album {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late int albumId;
  late String title;

  @Backlink(to: 'album')
  final photos = IsarLinks<Photo>();

  // Empty constructor for Isar
  Album();

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album()
      ..albumId = json['id']
      ..title = json['title'];
  }
}
