// ignore_for_file: equal_keys_in_map

import 'package:aplicacion/models/img_gustos.dart';

class Images {
  List<ImgGustos> imgGustos = [
    ImgGustos(0, "¿Qué tipo de atmósfera literaria prefiere?", {
      "Aventura": {"assets/isto_aventura.png": false},
      "Misterio": {"assets/isto_misterio.png": false},
      "Romance": {"assets/isto_romance.png": false},
      "Suspenso": {"assets/isto_suspenso.png": false},
      "Terror": {"assets/isto_terror.png": false},
    })
  ];
}
