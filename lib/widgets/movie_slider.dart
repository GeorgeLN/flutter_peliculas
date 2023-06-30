import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';

class MovieSlider extends StatefulWidget {

  final List<Movie> movies;
  final String? title;
  final Function onNextPage;

  const MovieSlider({
    Key? key,
    this.title,
    required this.movies,
    required this.onNextPage,
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500) {
        //TODO: Llamar el provider.
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; //CONTEXT corresponde a todo el arbol de widgets.

    return Container(
      width: size.height * 0.5,
      height: 260,
      //color: Colors.red,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          if (widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(widget.title!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),

          const SizedBox(height: 5),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal, //Siempre es vertical por defecto.
              itemCount: widget.movies.length,
              
              itemBuilder: (BuildContext context, int i) {
                return _MoviePoster(movie: widget.movies[i], heroId: '${ widget.title }-$i -${ widget.movies[i].id }');
              },
            ),
          ),
        ], //Children[]
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget { //Private

  final Movie movie;
  final String heroId;

  const _MoviePoster({
    super.key,
    required this.movie,
    required this.heroId,
  });

  @override
  Widget build(BuildContext context) {

    //final size = MediaQuery.of(context).size; //CONTEXT corresponde a todo el arbol de widgets.
    movie.heroId = heroId;

    return Container(
      width: 130,
      height: 190,
      //color: Colors.green,
      margin: const EdgeInsets.symmetric(horizontal: 10),

      child: Column(
        children: [
          GestureDetector(
            onTap:() => Navigator.pushNamed(context, 'details', arguments: movie),

            child: Hero(
              tag: movie.heroId!,

              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(movie.fullPosterImg),
                  width: 130,
                  height: 190,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 5),

          Text(
            movie.title,
            maxLines: 2, //Determina la cantidad de renglones para distribuir el texto.
            overflow: TextOverflow.ellipsis, //Indica con 3 puntos (...), que hay más texto cuando éste sobrepasa el tamaño del FadeImage.
            textAlign: TextAlign.center, //Permite centrar el texto.
          ),
        ], //Children[]
      ),
    );
  }
}