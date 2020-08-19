
import 'package:app_flutter_formsvalidation/src/models/product_model.dart';
import 'package:app_flutter_formsvalidation/src/providers/products_provider.dart';
import 'package:app_flutter_formsvalidation/src/utils/utils.dart' as utils;
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  //const ProductPage({Key key}) : super(key: key);
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productsProvider = new ProductsProvider();

  ProductModel product = new ProductModel();  
  bool _save = false;

  @override
  Widget build(BuildContext context) {

    final ProductModel prodData = ModalRoute.of(context).settings.arguments;        

    if(prodData!=null){
      product = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: (){},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: (){},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _createName(),
                _createPrice(),
                _createAvailable(),
                _createButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _createName(){
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Product'
      ),
      onSaved: (value)=>product.title=value,
      validator: (value){
        if(value.length<3){
          return 'Enter name of product';
        }
        else{
          return null;
        }
      },
    );  
  }

  Widget _createPrice(){
    return TextFormField(
      //textCapitalization: TextCapitalization.sentences,
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Price'
      ),
      onSaved: (value)=>product.value = double.parse(value),
      validator: (value){
        if(utils.isNumeric(value)){
          return null;
        }
        else{
          return 'Only numbers';
        }
      },
    );
  }

  Widget _createButton(){
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),        
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      icon: Icon(Icons.save),
      label: Text('Save'),
      onPressed: (_save)?null: _submit,
    );
  }

  Widget _createAvailable(){
    return SwitchListTile(
      value: product.available,
      title: Text('Available'),
      activeColor: Colors.deepPurple,
      onChanged: (value)=>setState((){
        product.available = value;
      }),
    );
  }

  void _submit(){
    
    if(!formKey.currentState.validate())return;

    formKey.currentState.save();

    print('Ok!!');
    print(product.title);
    print(product.value);
    print(product.available);
    
    setState(() {
      _save = true;  
    });

    if(product.id==null){
      productsProvider.createProduct(product);
    }else{
      productsProvider.updateProduct(product);
    }    

    /*setState(() {
      _save = false;  
    });*/

    showSnackbar('Register save');
    Navigator.pop(context);
  }

  void showSnackbar(String message){
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }
}