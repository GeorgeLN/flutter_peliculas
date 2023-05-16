import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:peliculas/providers/movies_provider.dart';
import 'package:peliculas/searchs/search_delegate.dart';
import 'package:peliculas/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>(context);
    //print(moviesProvider.onDisplayMovies);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en cine'),
        centerTitle: true,
        elevation: 0,
        
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            
            onPressed: () {
              showSearch(
                context: context,
                delegate: MovieSearchDelegate(),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
          //Tarjetas principales.
            CardSwiper(movies: moviesProvider.onDisplayMovies),

          //Slider de películas.
            MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Más populares!',
              onNextPage: () {
                return moviesProvider.getPopularMovies();
              },
            ),

          //Listado horizontal de películas.
          ], //Children[]
        ),
      ),
    );
  }
}