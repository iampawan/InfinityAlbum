import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinity_albums/blocs/album/album_bloc.dart';
import 'package:infinity_albums/blocs/album/album_event.dart';
import 'package:infinity_albums/data/respositories/album_repository.dart';
import 'package:infinity_albums/data/services/isar_service.dart';
import 'package:infinity_albums/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Albums',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => AlbumBloc(
          AlbumRepository(isarService: IsarService()),
        )..add(LoadAlbums()),
        child: const HomeScreen(),
      ),
    );
  }
}
