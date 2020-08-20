

import 'dart:io';

import 'package:app_flutter_formsvalidation/src/models/product_model.dart';
import 'package:app_flutter_formsvalidation/src/providers/products_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductsBloc{
  final _productsController = new BehaviorSubject<List<ProductModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _productsProvider = new ProductsProvider();

  Stream<List<ProductModel>> get productsStream => _productsController.stream;
  Stream<bool> get loading => _loadingController.stream;

  void loadProducts() async{
    final products = await _productsProvider.loadProducts();
    _productsController.sink.add(products);
  }

  void addProduct(ProductModel product) async{
    _loadingController.sink.add(true);
    await _productsProvider.createProduct(product);
    _loadingController.sink.add(false);
  }

  Future<String> uploadedPhoto(File photo) async{
    _loadingController.sink.add(true);
    final photoUrl = await _productsProvider.uploadImage(photo);
    _loadingController.sink.add(false);

    return photoUrl;
  }

  void updateProduct(ProductModel product) async{
    _loadingController.sink.add(true);
    await _productsProvider.updateProduct(product);
    _loadingController.sink.add(false);
  }

  void deleteProduct(String id) async{
    //_loadingController.sink.add(true);
    await _productsProvider.deleteProduct(id);
    //_loadingController.sink.add(false);
  }

  dispose(){
    _productsController?.close();
    _loadingController?.close();
  }

}