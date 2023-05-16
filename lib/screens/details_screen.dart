import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/widgets/widgets.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    //TODO: Cambiar String por una instancia de "movie".
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    //final Cast movie = ModalRoute.of(context)!.settings.arguments as Cast;
    //print(movie.title);

    return Scaffold(
      body: CustomScrollView(
        slivers: [ //Silders son widgets pre-programados cuando se hace un Scroll en el contenido padre.
          _CustomAppBar(),

          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(),
              _Overview(),
              //_Overview(),
              //_Overview(),
              CastingCards(movieId: movie.id),
            ]), //Funciona como si fuera un children[]
          ),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        
        title: Container(
          width:  double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
          color: Colors.black12,

          child: Text(
            movie.title,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),

        background: FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'),
          image: NetworkImage(movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),

      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
          
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                height: 150,
              ),
            ),
          ),

          const SizedBox(width: 20),

          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 190),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: textTheme.titleLarge, overflow: TextOverflow.ellipsis, maxLines: 2),
          
                const SizedBox(height: 5),
          
                Text(movie.originalTitle, style: textTheme.titleSmall, overflow: TextOverflow.ellipsis, maxLines: 2),
          
                const SizedBox(height: 5),
          
                Row(
                  children: [
                    const Icon(Icons.star_outlined, size: 15, color: Colors.grey),
                    const SizedBox(height: 5),
                    Text('Calificación: ${movie.voteAverage.toString()}', style: textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
        ], //Children[]
      ),
    );
  }
}

class _Overview extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}