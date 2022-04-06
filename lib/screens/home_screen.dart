import 'package:flutter/material.dart';
import 'package:peliculas_app/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Peliculas en cine"),
          elevation: 15,
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.search_outlined))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: const [
              //TODO: CardSwiper

              //Tarjetas principales
              CardSwiper(),
              //Listado horizaontal de peliculas
              MovieSlider(),
              MovieSlider(),
              MovieSlider(),
              MovieSlider(),
            ],
          ),
        ));
  }
}
