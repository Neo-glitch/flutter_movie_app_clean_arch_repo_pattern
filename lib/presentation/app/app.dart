import 'package:flutter/material.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/main.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/presentation/list/movies_list_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  // way of doing things in provider package
  // final InitialData data;
  // const App({super.key, required this.data});

  App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Movies App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MoviesListScreen(),
    );
  }
}
