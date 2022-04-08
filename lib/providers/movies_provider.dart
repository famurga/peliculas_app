import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/helpers/debouncer.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/models/search_response.dart';

class MoviesProvider extends ChangeNotifier {
  String _apiKey = "c762338a7468f67a45c79ac628acab49";
  String _baseUrl = "api.themoviedb.org";
  String _language = "es-ES";

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};
  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 500),
    
    );

  final StreamController<List<Movie>> _suggestionStreamController =  StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionStreamController.stream;

  MoviesProvider() {
    print('Movies provider inicializado');

    this.getOnDisplayMovies();
    this.getPopulaMovies();
  }

  Future<String> _getJsonData(String endPoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endPoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await this._getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    onDisplayMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  getPopulaMovies() async {
    _popularPage++;
    final jsonData =
        await this._getJsonData('3/movie/popular', _popularPage);
    final popularResponse = PopularResponse.fromJson(jsonData);
/*     if(response.statusCode != 200)
 */

    popularMovies = [...popularMovies, ...popularResponse.results];
    print('La pagina es: $_popularPage');

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if(moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final jsonData = await this._getJsonData('3/movie/$movieId/credits');
    //AQUI SE MUERE
    final creditsResponse = CreditsResponse.fromJson(jsonData);
  
    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }
  Future<List<Movie>>searchMovies(String query) async{
      final  url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'query': query,
    });

    // Await the http get response, then decode the json-formatted response.
    final response = await http.get(url);
    final searchResponse =SearchResponse.fromJson(response.body);
    return searchResponse.results;
  }

  void getSuggestionByQuery ( String searchTerm){
    debouncer.value = '';
    debouncer.onValue = (value) async{
      final results = await this.searchMovies(value);
      this._suggestionStreamController.add(results);

    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) { 

      debouncer.value = searchTerm;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
