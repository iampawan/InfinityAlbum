import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object?> get props => [];
}

class LoadAlbums extends AlbumEvent {}

class LoadPhotosForAlbum extends AlbumEvent {
  final int albumId;

  const LoadPhotosForAlbum(this.albumId);

  @override
  List<Object?> get props => [albumId];
}
