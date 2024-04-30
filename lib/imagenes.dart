import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as pt;
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import './types/Photo.dart';


//este programa se ejecuta en la terminal con este comando: dart .\lib\imagenes.dart

void main() async
{
  var url = Uri.https('jsonplaceholder.typicode.com','/photos');

  try
  {
    var jsonPhoto = await http.get(url);

    if(jsonPhoto.statusCode == 200)
    {
      final photos = photoFromJson(jsonPhoto.body);
      print("lista de imagenes");
      print("===================================");
      for(var photo in photos)
      {
        print("id: ${photo.id}");
        print("album: ${photo.albumId}");
        print("titulo: ${photo.title}");
        print("url: ${photo.url}");
        print('=========================');
      }


      print("ingrese el id de la imagen que desea ver:");
      int photoID = int.parse(stdin.readLineSync() as String);
      var seEncontro = false;
      for(var photo in photos)
      {
        if(photo.id == photoID)
        {
          seEncontro = true;
          lectorImagenes(photo.url);
          break;
        }
      }

      if(!seEncontro)
      {
        print('se ingreso un ID invalido o no existe');
      }

    }
    else
    {
      print('no se pudieron cargar las imagenes');
    }
  }
  catch(e)
  {
    print('no se pudo cargar la url');
  }
}




void lectorImagenes(String url) async
{
  
  
  final http.Response respuesta = await http.get(Uri.parse(url));

  if (respuesta.statusCode == 200) {
   
    Uint8List bytes = respuesta.bodyBytes;
    String tempDir = Directory.systemTemp.path;

  
    String imagePath = '$tempDir\\imagen.jpg';
    File file = File(imagePath);
    await file.writeAsBytes(bytes);

    
    await Process.run('start', [imagePath]);
    
  } else {
    
    print('Error al cargar la imagen. Código de estado: ${respuesta.statusCode}');
  }
}

