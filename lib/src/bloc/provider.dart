import 'package:app_flutter_formsvalidation/src/bloc/login_bloc.dart';
import 'package:app_flutter_formsvalidation/src/bloc/products_bloc.dart';
export 'package:app_flutter_formsvalidation/src/bloc/products_bloc.dart';
import 'package:flutter/foundation.dart';
export 'package:app_flutter_formsvalidation/src/bloc/login_bloc.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget{
  
  final loginBloc = new LoginBloc();
  final _productsBloc = new ProductsBloc();

  static Provider _instancia;

  factory Provider({Key key, Widget child}){
    if(_instancia==null){
      _instancia=new Provider._internal(key:key, child:child);
    }

    return _instancia;
  }
  
  Provider._internal({Key key, Widget child})
    : super(key: key, child: child);  

  /*Provider({Key key, Widget child})
    : super(key: key, child: child);*/

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of (BuildContext context) {
    //return (context.inheritFromWidgetOfExactType(Provider) as Provider).loginBloc;
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  static ProductsBloc productsBloc (BuildContext context) {
    //return (context.inheritFromWidgetOfExactType(Provider) as Provider)._productsBloc;
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productsBloc;
  }
}