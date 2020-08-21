import 'package:app_flutter_formsvalidation/src/bloc/provider.dart';
import 'package:app_flutter_formsvalidation/src/pages/home_page.dart';
import 'package:app_flutter_formsvalidation/src/pages/login_page.dart';
import 'package:app_flutter_formsvalidation/src/pages/product_page.dart';
import 'package:app_flutter_formsvalidation/src/pages/register_page.dart';
import 'package:app_flutter_formsvalidation/src/providers/navigation_provider.dart';
import 'package:app_flutter_formsvalidation/src/providers/service_locator.dart';
import 'package:app_flutter_formsvalidation/src/shared_prefs/preferences_user.dart';
import 'package:flutter/material.dart';

void main() async { 
  
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferencesUser();
  await prefs.initPrefs();
  
  setupLocator();
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final prefs = new PreferencesUser();    
    print(prefs.token);

    return Provider(
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: (prefs.token.toString().length==0)?'login':'home',
        //initialRoute: 'login',
        navigatorKey: locator<NavigationProvider>().navigatorKey,
        onGenerateRoute: (routeSettings){
          switch(routeSettings.name){
            case 'login':
              return MaterialPageRoute(builder: (context) => LoginPage());
            case 'home':
              return MaterialPageRoute(builder: (context) => HomePage());
            default:
              return MaterialPageRoute(builder: (context) => LoginPage());
          }
        },
        routes: {
          'login' : (BuildContext context) => LoginPage(),
          'home' : (BuildContext context) => HomePage(),
          'product' : (BuildContext context) => ProductPage(),
          'register' : (BuildContext context) => RegisterPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      ),
    );    
  }
}