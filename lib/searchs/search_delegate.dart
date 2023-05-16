import 'package:flutter/material.dart';

import 'package:peliculas/models/models.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate{
  
  @override
  
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),

      onPressed: () {
        close(context, null); //Regresar al "HomeScreen".
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResult');
  }

  Widget _emptyContainer() {
    return Container(
      child: const Center( 
        child: Icon(Icons.movie_creation_outlined, color: Colors.black38, size: 130),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty) {
      return _emptyContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.searchMovies(query),

      builder: (context, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return _emptyContainer();
        }

        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, i) {
            return _MovieItem(movie: movies[i]);
          },
        );
      },
    );
  }
}

class _MovieItem extends StatelessWidget {

  final Movie movie;

  const _MovieItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {

    movie.heroId = 'search-${movie.id}';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,

        child: FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'),
          image: NetworkImage(movie.fullPosterImg),
          width: 75,
          fit: BoxFit.cover,
        ),
      ),

      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),

      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}