import 'package:equatable/equatable.dart';

abstract class AlbumEvent extends Equatable {
  const AlbumEvent();

  @override
  List<Object?> get props => [];
}

class LoadAlbums extends AlbumEvent {}

class LoadPhotos extends AlbumEvent {
  final int albumId;

  const LoadPhotos(this.albumId);

  @override
  List<Object?> get props => [albumId];
}
