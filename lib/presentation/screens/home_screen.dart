import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_albums/blocs/album/album_bloc.dart';
import 'package:infinity_albums/blocs/album/album_state.dart';
import 'package:infinity_albums/presentation/widgets/album_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AlbumLoaded) {
            return AlbumList(albums: state.albums);
          }
          if (state is AlbumError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
