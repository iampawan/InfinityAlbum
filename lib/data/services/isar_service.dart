import 'package:infinity_albums/data/models/album.dart';
import 'package:infinity_albums/data/models/photo.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> db;

  IsarService() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [AlbumSchema, PhotoSchema],
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  Future<void> saveAlbums(List<Album> albums) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.albums.putAll(albums);
    });
  }

  Future<List<Album>> getAlbums() async {
    final isar = await db;
    return isar.albums.where().findAll();
  }

  Future<void> savePhotos(List<Photo> photos, int albumId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      // Get the album first
      final album =
          await isar.albums.filter().albumIdEqualTo(albumId).findFirst();

      if (album != null) {
        // Link photos to album
        for (var photo in photos) {
          photo.album.value = album;
        }

        // Save photos
        await isar.photos.putAll(photos);

        // Update album's photo links
        album.photos.addAll(photos);
        await album.photos.save();
      }
    });
  }

  Future<List<Photo>> getPhotosByAlbumId(int albumId) async {
    final isar = await db;
    final album =
        await isar.albums.filter().albumIdEqualTo(albumId).findFirst();

    if (album != null) {
      await album.photos.load();
      return album.photos.toList();
    }
    return [];
  }

  Future<bool> hasPhotosForAlbum(int albumId) async {
    final photos = await getPhotosByAlbumId(albumId);
    return photos.isNotEmpty;
  }

  // Clear all data
  Future<void> clear() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.albums.clear();
      await isar.photos.clear();
    });
  }
}
