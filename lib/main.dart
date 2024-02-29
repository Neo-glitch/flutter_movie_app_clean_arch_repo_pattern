// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/network/client/api_client.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/network/network_mapper.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/repository/movies_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:flutter_movie_app_clean_arch_repo_pattern/domain/model/config.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/presentation/app/app.dart';
import 'package:sqflite/sqflite.dart';

// class containing list of providers
// class InitialData {
//   final List<Provider> providers;

//   InitialData({
//     required this.providers,
//   });
// }

// method where all dependencies are defined, and passed to the App Widget
// This is providers package way, not used by us though
// Future<InitialData> _createData() async {
//   final log = Logger(
//       printer: PrettyPrinter(), level: kDebugMode ? Level.trace : Level.off);

//   final config = await _loadConfig(log);

//   final apiClient = ApiClient(
//     baseUrl: "https://moviesdatabase.p.rapidapi.com/",
//     apiKey: config.apiKey,
//     apiHost: config.apiHost,
//   );

//   final networkMapper = NetworkMapper(log: log);
//   final moviesRepo = MoviesRepository(
//     apiClient: apiClient,
//     networkMapper: networkMapper,
//   );

//   return InitialData(
//     providers: [
//       Provider((ref) => log),
//       Provider((ref) => moviesRepo),
//     ],
//   );
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // way of providing providers in provider package
  // final data = await _createData();
  // runApp(
  //      App(
  //      data: data,
  //    ),
  //);
  // speed up sflite operations but only in debug mode
  // await Sqflite.devSetDebugModeOn(kDebugMode);
  runApp(ProviderScope(child: App()));
}

// Future<Config> _loadConfig(Logger log) async {
//   String raw;

//   try {
//     raw = await rootBundle.loadString("assets/config/config.json");

//     final config = json.decode(raw) as Map<String, dynamic>;

//     return Config(
//       apiKey: config["apiKey"] as String,
//       apiHost: config["apiHost"] as String,
//     );
//   } catch (e) {
//     log.e(
//       'Error while loading project configuration, please make sure '
//       'that the file located at /assets/config/config.json '
//       'exists and that it contains the correct configutation.',
//       error: e,
//     );

//     // throw this exception if error occurs
//     rethrow;
//   }
// }
