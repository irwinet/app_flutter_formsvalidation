import 'package:app_flutter_formsvalidation/src/bloc/provider.dart';
import 'package:app_flutter_formsvalidation/src/models/product_model.dart';
import 'package:app_flutter_formsvalidation/src/providers/products_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  //const HomePage({Key key}) : super(key: key);
  final productsProvider = new ProductsProvider();

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);    

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      /*body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Email: ${bloc.email}'),
          Divider(),
          Text('Password: ${bloc.password}'),
        ],
      ),*/
      body: _createList(),
      floatingActionButton: _createButton(context),
    );
  }

  Widget _createList(){
    return FutureBuilder(
      future: productsProvider.loadProducts(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
        if(snapshot.hasData){
          final products = snapshot.data;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index)=>_createItem(context,products[index]),
          );
        }else{
          return Center(child: CircularProgressIndicator(),);
        }               
      },
    );
  }

  Widget _createItem(BuildContext context, ProductModel model){
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction){
        //Deleted Product
        productsProvider.deleteProduct(model.id);
      },
      child: ListTile(
        title: Text('${model.title} - ${model.value}'),
        subtitle: Text(model.id),
        onTap: ()=>Navigator.pushNamed(context, 'product', arguments: model),
      ),
    );
  }

  Widget _createButton(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: ()=>Navigator.pushNamed(context, 'product'),
    );
  }
}