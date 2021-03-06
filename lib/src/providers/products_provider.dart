
import 'dart:convert';
import 'dart:io';

import 'package:app_flutter_formsvalidation/src/models/product_model.dart';
import 'package:app_flutter_formsvalidation/src/providers/navigation_provider.dart';
import 'package:app_flutter_formsvalidation/src/providers/service_locator.dart';
import 'package:app_flutter_formsvalidation/src/shared_prefs/preferences_user.dart';
import 'package:http/http.dart' as http;
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class ProductsProvider{
  final String _url = 'https://app-flutter-4a58f.firebaseio.com';
  final _prefs = new PreferencesUser();
  final NavigationProvider _navigationProvider = locator<NavigationProvider>();

  Future<bool> createProduct(ProductModel model) async{
    final url='$_url/products.json?auth=${_prefs.token}';

    final resp = await http.post(url, body: productModelToJson(model));

    final decodedDate = json.decode(resp.body);

    print(decodedDate);

    return true;
  }  

  Future<bool> updateProduct(ProductModel model) async{
    final url='$_url/products/${model.id}.json?auth=${_prefs.token}';

    final resp = await http.put(url, body: productModelToJson(model));

    final decodedDate = json.decode(resp.body);

    print(decodedDate);

    return true;
  }   

  Future<List<ProductModel>> loadProducts() async{
    final url = '$_url/products.json?auth=${_prefs.token}';
    
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductModel> products = new List();
    //print(decodedData);

    if(decodedData==null) return [];

    //Implementation Token Expire
    if(decodedData['error']!=null){
      _navigationProvider.navigateTo('login');
    }
    else{
      decodedData.forEach((key, value) {
        //print(value);
        final prodTemp = ProductModel.fromJson(value);
        prodTemp.id = key;

        products.add(prodTemp);
      });
    }

    //print(products[0].id);

    return products;
  }

  Future<int> deleteProduct(String id) async{
    final url = '$_url/products/$id.json?auth=${_prefs.token}';

    final resp = await http.delete(url);

    print(resp.body);

    return 1;
  }

  Future<String> uploadImage(File file) async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dtefjkfn7/image/upload?upload_preset=rn9rtbll');
    final mimeType = mime(file.path).split('/');

    final imageUploadedRequest = http.MultipartRequest(
      'POST',
      url
    );

    final image = await http.MultipartFile.fromPath(
      'file', 
      file.path, 
      contentType: MediaType(mimeType[0], mimeType[1])
    );

    imageUploadedRequest.files.add(image);
    final streamResponse = await imageUploadedRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode!=200 && resp.statusCode!=201){
      print('Error');
      print(resp.body);
      return null;
    }

    final respData = json.decode(resp.body);
    print(respData);
    return respData['secure_url'];
  }

}