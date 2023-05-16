import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class CastingCards extends StatelessWidget {
   
  final int movieId;
  
  const CastingCards({
    Key? key,
    required this.movieId,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {    

    final moviesProvider = Provider.of<MoviesProvider>(context);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieId),

      builder: (context, AsyncSnapshot<List<Cast>> snapshot) {

        if (!snapshot.hasData) {
          return Container(
            constraints: const BoxConstraints(maxWidth: 150),
            height: 180,
            child: const CupertinoActivityIndicator(),
          );
        }
        
        final List<Cast> cast = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 180,
          //color: Colors.red,
          
          child: ListView.builder(
            itemCount: cast.length,
            scrollDirection: Axis.horizontal,

            itemBuilder: (BuildContext context, int i) {
              return _CastCard(actor: cast[i]);
            },
          ),
        );
      },
    );
  }
}

class _CastCard extends StatelessWidget {

  final Cast actor;

  const _CastCard({super.key, required this.actor});  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10), //Dividir cada Listview builder.
      width: 110,
      height: 100,
      //color: Colors.green,

      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),

            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(actor.fullProfilePath),
              height: 140,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(height: 5),

          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            
          )
        ], //children[]
      ),
    );
  }
}