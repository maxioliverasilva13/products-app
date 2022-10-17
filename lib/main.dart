import 'package:flutter/material.dart';
import 'package:productos_app/providers/comments_provider.dart';
import 'package:productos_app/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';

 
void main() => runApp(AppState());

class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ( _ ) => AuthService() ),
        ChangeNotifierProvider(create: ( _ ) => ProductsService() ),
        ChangeNotifierProvider(create: ( _ ) => PersonInfoServices() ),
      ],
      child: MyApp(),
    );
  }
}



 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: 'login',
      routes: {
        
        'checking': ( _ ) => CheckAuthScreen(),

        'home'    : ( _ ) => HomeScreen(),
        'product' : ( _ ) => ProductScreen(),
        'profile' : ( _ ) => ProfileScreen(),

        'login'   : ( _ ) => LoginScreen(),
        'register': ( _ ) => RegisterScreen(),
      },
      scaffoldMessengerKey: NotificationsService.messengerKey,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0
        )
      ),
    );
  }
}