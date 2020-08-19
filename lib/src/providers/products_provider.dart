
import 'dart:convert';

import 'package:app_flutter_formsvalidation/src/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductsProvider{
  final String _url = 'https://app-flutter-4a58f.firebaseio.com';

  Future<bool> createProduct(ProductModel model) async{
    final url='$_url/products.json';

    final resp = await http.post(url, body: productModelToJson(model));

    final decodedDate = json.decode(resp.body);

    print(decodedDate);

    return true;
  }  

  Future<bool> updateProduct(ProductModel model) async{
    final url='$_url/products/${model.id}.json';

    final resp = await http.put(url, body: productModelToJson(model));

    final decodedDate = json.decode(resp.body);

    print(decodedDate);

    return true;
  }   

  Future<List<ProductModel>> loadProducts() async{
    final url = '$_url/products.json';
    
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductModel> products = new List();
    //print(decodedData);

    if(decodedData==null) return [];

    decodedData.forEach((key, value) {
      //print(value);
      final prodTemp = ProductModel.fromJson(value);
      prodTemp.id = key;

      products.add(prodTemp);
    });

    //print(products[0].id);

    return products;
  }

  Future<int> deleteProduct(String id) async{
    final url = '$_url/products/$id.json';

    final resp = await http.delete(url);

    print(resp.body);

    return 1;
  }

}