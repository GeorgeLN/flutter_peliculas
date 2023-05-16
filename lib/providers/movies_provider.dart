import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:peliculas/models/models.dart';

class MoviesProvider extends ChangeNotifier {

  final String _apiKey    = '8d8e5b449e4f028e3ad877262b8d31dd';
  final String _baseUrl   = 'api.themoviedb.org'; //No colocar el "Https"
  final String _language  = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies   = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  MoviesProvider() {
    print('MoviesProvider inicializado');

    this.getOnDisplayMovies();
    this.getPopularMovies();
  }

  Future<String> _getJsonData(String endPoint, [int page = 1]) async { //[int page = 1] permite que siempre tenga el valor de 1 de manera predeterminada.
    final url = Uri.https(_baseUrl, endPoint, {
      'api_key'   : _apiKey,
      'language'  : _language,
      'page'      : '$page'
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    //3/movie/now_playing
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    //print(nowPlayingResponse.results[0].title);
    onDisplayMovies = nowPlayingResponse.results; //Llena el arreglo con la lista de resultados

    notifyListeners(); //Le dice a todos los Widgets que se re-dibujen... No todos, los que tengan que ver.
  }

  getPopularMovies() async {
    
    _popularPage ++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);

    //print(nowPlayingResponse.results[0].title);
    //popularMovies = popularResponse.results; //Llena el arreglo con la lista de resultados.
    popularMovies = [...popularMovies, ...popularResponse.results]; //Manera re-estructurada.
    //print(popularMovies[0]);
    notifyListeners(); //Le dice a todos los Widgets que se re-dibujen... No todos, los que tengan que ver.
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    //TODO: Revisar el mapa.
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    print(jsonData);
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future <List<Movie>> searchMovies (String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key'  : _apiKey,
      'language' : _language,
      'query'    : query,
    });

    final response = await http.get(url);
    final searchResponse = SearchMovieResponse.fromJson(response.body);

    return searchResponse.results;
  }
}