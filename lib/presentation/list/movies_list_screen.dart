import 'package:flutter/material.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/core/providers.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/data/repository/movies_repository.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/domain/model/movie.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/presentation/list/movie_preview.dart';
import 'package:flutter_movie_app_clean_arch_repo_pattern/presentation/list/movies_list_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hookified_infinite_scroll_pagination/hookified_infinite_scroll_pagination.dart';

class MoviesListScreen extends ConsumerStatefulWidget {
  MoviesListScreen({super.key});

  @override
  ConsumerState<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends ConsumerState<MoviesListScreen> {
  MoviesListModel? _model;
  // to handle pagination, kinda like paging source in android
  final PagingController<int, Movie> _pagingController =
      PagingController(firstPageKey: 1);

  late final Future<void> _future;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    // });

    _pagingController.addPageRequestListener((pageKey) async {
      // called whenEver new page is needed
      try {
        if (_model != null) {
          final movies = await _model!.fetchPage(pageKey);
          _pagingController.appendPage(movies, pageKey + 1);
        }
      } catch (e) {
        _pagingController.error = e;
      }
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _model = MoviesListModel(
      log: ref.watch(logPovider),
      moviesRepo: ref.watch(movieRepoProvider),
    );
    _future = _checkNewData();
    return Scaffold(
        appBar: AppBar(
          title: Text("Upcoming Movies"),
        ),
        // this is similar to swipe refresh layout
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) => RefreshIndicator(
            onRefresh: _refresh,
            child: PagedListView<int, Movie>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Movie>(
                itemBuilder: (context, movie, index) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    child: MoviePreview(movie: movie),
                  );
                },
              ),
            ),
          ),
        ));
  }

  Future<void> _refresh() async {
    await _model?.deletePersistedMovies();
    _pagingController.refresh();
  }

  Future<void> _checkNewData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // this ensures widget is fully shown before executing this code
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final hasNewData = await _model?.hasNewData();

      if (hasNewData == true) {
        scaffoldMessenger.clearSnackBars();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: const Text("Refresh to obtain the new available data"),
            action: SnackBarAction(
              label: "Refresh",
              onPressed: _refresh,
            ),
          ),
        );
      }
    });
  }
}
