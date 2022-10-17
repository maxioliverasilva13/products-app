

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudDinaryServices {
   Future<String?> uploadImage( File picture) async {
       final url = Uri.parse('https://api.cloudinary.com/v1_1/dkjujr3gj/image/upload?upload_preset=uyu8zugv');

    final imageUploadRequest = http.MultipartRequest('POST', url );

    final file = await http.MultipartFile.fromPath('file', picture.path );

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if ( resp.statusCode != 200 && resp.statusCode != 201 ) {
      print('algo salio mal');
      print( resp.body );
      return null;
    }
    final decodedData = json.decode( resp.body );
    return decodedData['secure_url'];
   }
}