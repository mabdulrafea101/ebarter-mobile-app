import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommerce/logic/authentication/bloc/authentication_bloc.dart';
import 'package:fluttercommerce/logic/category_bloc/bloc/category_bloc.dart';
import 'package:fluttercommerce/logic/login/bloc/login_bloc.dart';
import 'package:fluttercommerce/logic/login/upload_parcel/bloc/upload_parcel_bloc.dart';
import 'package:fluttercommerce/logic/my_product/bloc/my_product_bloc.dart';
import 'package:fluttercommerce/logic/order_create/bloc/order_create_bloc.dart';
import 'package:fluttercommerce/logic/order_list/bloc/order_list_bloc.dart';
import 'package:fluttercommerce/logic/patch_order/bloc/patch_order_bloc.dart';
import 'package:fluttercommerce/logic/product/bloc/product_bloc.dart';
import 'package:fluttercommerce/logic/profile/bloc/profile_bloc.dart';
import 'package:fluttercommerce/logic/upload_product/bloc/upload_product_bloc.dart';
import 'package:fluttercommerce/logic/upload_profile/bloc/upload_profile_bloc.dart';
import 'package:fluttercommerce/resources/repositories/authentication_repository.dart';
import 'package:fluttercommerce/resources/repositories/parcel_repository.dart';
import 'package:fluttercommerce/resources/repositories/product_repository.dart';
import 'package:fluttercommerce/resources/repositories/profile_repository.dart';
import 'package:fluttercommerce/resources/repositories/signup_repository.dart';
import 'package:fluttercommerce/screens/home.dart';
import 'package:fluttercommerce/screens/product.dart';

import 'logic/home/bloc/home_bloc.dart';
import 'logic/signup/bloc/signup_bloc.dart';
import 'screens/login.dart';

void main() {
  final AuthenticationRepository _authenticationRepository =
      AuthenticationRepository();
  final ProductRepository _productRepository = ProductRepository();
  final ProfileRepository _profileRepository = ProfileRepository();
  final SignupRepository _signupRepository = SignupRepository();
  final ParcelRepository _parcelRepository = ParcelRepository();

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (context) =>
          AuthenticationBloc(loginRepository: _authenticationRepository),
    ),
    BlocProvider(
      create: (context) => LoginBloc(
        loginRepository: _authenticationRepository,
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
      ),
    ),
    BlocProvider(
      create: (context) => ProductBloc(repository: _productRepository),
    ),
    BlocProvider(
      create: (context) => HomeBloc(repository: _productRepository),
    ),
    BlocProvider(
      create: (context) => ProfileBloc(repository: _profileRepository),
    ),
    BlocProvider(
      create: (context) => UploadProductBloc(),
    ),
    BlocProvider(
      create: (context) => SignupBloc(repository: _signupRepository),
    ),
    BlocProvider(
      create: (context) => UploadParcelBloc(repository: _parcelRepository),
    ),
    BlocProvider(
      create: (context) => OrderCreateBloc(),
    ),
    BlocProvider(
      create: (context) => OrderListBloc(),
    ),
    BlocProvider(
      create: (context) => PatchOrderBloc(),
    ),
    BlocProvider(
      create: (context) => UploadProfileBloc(),
    ),
    BlocProvider(
      create: (context) => MyProductBloc(),
    ),
    BlocProvider(
      create: (context) => CategoryBloc(),
    ),
  ], child: EcommerceApp()));
}

class EcommerceApp extends StatefulWidget {
  @override
  State<EcommerceApp> createState() => _EcommerceAppState();
}

class _EcommerceAppState extends State<EcommerceApp> {
  @override
  void initState() {
    BlocProvider.of<AuthenticationBloc>(context).add(AppStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        dividerColor: Color(0xFFECEDF1),
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        primaryColor: Color(0xFFF93963),
        accentColor: Colors.cyan[600],
        fontFamily: 'Montserrat',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          subtitle1: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          subtitle2: TextStyle(fontSize: 16),
          bodyText1: TextStyle(fontSize: 14.0, fontFamily: 'Montserrat'),
          headline2: TextStyle(
              fontSize: 14.0, fontFamily: 'Montserrat1', color: Colors.white),
          headline3: TextStyle(
              fontSize: 14.0, fontFamily: 'Montserrat', color: Colors.black54),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'E-Bartering UI Kit',
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return Home();
          }
          return LoginScreen();
        },
      ),
      routes: {
        '/product': (context) => ProductPage(),
      },
    );
  }
}

class TabLayoutDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      color: Colors.yellow,
      home: DefaultTabController(
        length: 4,
        child: new Scaffold(
          body: TabBarView(
            children: [
              new Container(
                color: Colors.yellow,
              ),
              new Container(
                color: Colors.orange,
              ),
              new Container(
                color: Colors.lightGreen,
              ),
              new Container(
                color: Colors.red,
              ),
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.home),
              ),
              Tab(
                icon: new Icon(Icons.rss_feed),
              ),
              Tab(
                icon: new Icon(Icons.perm_identity),
              ),
              Tab(
                icon: new Icon(Icons.settings),
              )
            ],
            labelColor: Colors.yellow,
            unselectedLabelColor: Colors.blue,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.red,
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
