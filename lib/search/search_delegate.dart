import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';


class MovieSearchDelegate extends SearchDelegate{

  @override
  // TODO: implement searchFieldLabel
  String? get searchFieldLabel => 'Buscar pelicula';


  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(onPressed: ()=>
        query = ''
        , icon: Icon(Icons.clear))
    ];
  }

  //pantalla anterior
  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
 return IconButton(onPressed: (){

   close(context, null);
 }, 
 icon: Icon(Icons.arrow_back));
   }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
     return Text('buildResults');

  }
  Widget _emptyContainer(){
    return Container(
      child: Center(
        child: Icon(Icons.movie_creation_outlined, color: Colors.black38,size: 130,),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions

    if(query.isEmpty){
      return _emptyContainer();
    }
    print('http request');

    final moviesProvider = Provider.of<MoviesProvider>(context,listen:false);
    moviesProvider.getSuggestionByQuery(query);

    return  StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: (_, AsyncSnapshot<List<Movie>> snapshot){
        if(!snapshot.hasData){
         return _emptyContainer();
        }
        final movies = snapshot.data!;
        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (_, int index)=> _Movieitem(movie:movies[index])
          );
        
      });
  }

}

class _Movieitem extends StatelessWidget {
  final Movie movie;
  const _Movieitem({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${ movie.id}';
    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: AssetImage('assets/no-image.jpg'),
          image: NetworkImage(movie.fullPosterImg),
            width: 50,
            fit: BoxFit.contain
          ),
      ),
        title: Text(movie.title),
        subtitle: Text(movie.originalTitle),
        onTap: (){
          Navigator.pushNamed(context,'details', arguments: movie);
        },
    );
  }
}