import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_albums/blocs/album/album_event.dart';
import 'package:infinity_albums/blocs/album/album_state.dart';
import 'package:infinity_albums/data/respositories/album_repository.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;

  AlbumBloc(this.albumRepository) : super(AlbumInitial()) {
    on<LoadAlbums>(_onLoadAlbums);
    on<LoadPhotosForAlbum>(_onLoadPhotosForAlbum);
  }

  FutureOr<void> _onLoadAlbums(
      LoadAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final albums = await albumRepository.getAlbums();
      emit(AlbumLoaded(albums));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }

  FutureOr<void> _onLoadPhotosForAlbum(
      LoadPhotosForAlbum event, Emitter<AlbumState> emit) async {
    try {
      await albumRepository.getPhotosForAlbum(event.albumId);
      final albums = await albumRepository.getAlbums();
      emit(AlbumLoaded(albums));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }
}
