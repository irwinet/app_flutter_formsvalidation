import 'package:app_flutter_formsvalidation/src/bloc/provider.dart';
import 'package:app_flutter_formsvalidation/src/models/product_model.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final productsProvider = new ProductsProvider();

  @override
  Widget build(BuildContext context) {

    //final bloc = Provider.of(context);    
    final productsBloc = Provider.productsBloc(context);
    productsBloc.loadProducts();

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
      body: _createList(productsBloc),
      floatingActionButton: _createButton(context),
    );
  }

  Widget _createList(ProductsBloc productsBloc){

    return StreamBuilder(
      stream: productsBloc.productsStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){
        if(snapshot.hasData){
          final products = snapshot.data;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index)=>_createItem(context, productsBloc,products[index]),
          );
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
    /*
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
    */
  }

  Widget _createItem(BuildContext context, ProductsBloc productsBloc, ProductModel model){
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction){
        //Deleted Product
        //productsProvider.deleteProduct(model.id);
        productsBloc.deleteProduct(model.id);
      },
      child: Card(
        child: Column(
          children: <Widget>[
            (model.photoUrl==null)
            ? Image(image: AssetImage('assets/no-image.png'),)
            : FadeInImage(
              image: NetworkImage(model.photoUrl),
              placeholder: AssetImage('assets/jar-loading.gif'),
              height: 300.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            ListTile(
              title: Text('${model.title} - ${model.value}'),
              subtitle: Text(model.id),
              onTap: ()=>Navigator.pushNamed(context, 'product', arguments: model).then((value) => setState((){})),
            )
          ],
        ),
      ),
    );

    /*
    ListTile(
      title: Text('${model.title} - ${model.value}'),
      subtitle: Text(model.id),
      onTap: ()=>Navigator.pushNamed(context, 'product', arguments: model).then((value) => setState((){})),
    )
    */
  }

  Widget _createButton(BuildContext context){
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.deepPurple,
      onPressed: ()=>Navigator.pushNamed(context, 'product').then((value) => setState((){})),
    );
  }
}