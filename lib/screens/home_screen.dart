import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/search/search_delegate.dart';
import 'package:peliculas_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(
      context,
    );

    print(moviesProvider.onDisplayMovies);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Peliculas en cine"),
          elevation: 15,
          actions: [
            IconButton(
                onPressed: ()=> showSearch(context: context, delegate: MovieSearchDelegate()), 
                icon: const Icon(Icons.search_outlined),
                
                )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Tarjetas principales
              CardSwiper(movies: moviesProvider.onDisplayMovies),
              //Listado horizaontal de peliculas
              MovieSlider(movies: moviesProvider.popularMovies, title: 'Populares',onNextPage: () =>moviesProvider.getPopulaMovies() ),
              /* MovieSlider(movies: moviesProvider.popularMovies, title: 'Picantes'),
              MovieSlider(movies: moviesProvider.popularMovies), */
              /*  MovieSlider(),
              MovieSlider(),
              MovieSlider(), */
            ],
          ),
        ));
  }
}
