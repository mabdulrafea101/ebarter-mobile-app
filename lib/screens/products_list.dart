import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/ionicons.dart';
import 'package:flutter_icons/material_community_icons.dart';
import 'package:fluttercommerce/logic/product/bloc/product_bloc.dart';
import 'package:fluttercommerce/logic/profile/bloc/profile_bloc.dart';
import 'package:fluttercommerce/models/product.dart';
import 'package:fluttercommerce/screens/product.dart';
import 'package:fluttercommerce/utils/navigator.dart';
import 'package:fluttercommerce/utils/shared_preferences_handler.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'order_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  final String otherProduct;
  final String userId;
  final String title;
  final int categoryId;
  final bool isAllProduct;
  final bool isOrderCreation;

  ProductListScreen({
    this.otherProduct,
    @required this.userId,
    @required this.title,
    this.categoryId = 0,
    this.isAllProduct = false,
    this.isOrderCreation = false,
  });

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductListScreen> {
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(24.0),
    topRight: Radius.circular(24.0),
  );

  PanelController slidingUpController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> widgetList = [
    'A',
    'B',
    'C',
    'A',
    'B',
    'C',
    'A',
    'B',
    'C',
    'A',
    'B',
    'C',
    'A',
    'B',
    'C'
  ];
  String userId;

  _setBlocEvents() async {
    userId = await SharedPreferencesHandler.getToken();
    BlocProvider.of<ProfileBloc>(context)
        .add(UpdateProfile(token: 'token', userId: userId));
    // if (widget.isCategory != null || widget.isCategory == false) {

    // }
    if (widget.isAllProduct) {
      BlocProvider.of<ProductBloc>(context).add(UpdateProduct(token: userId));
    } else if (widget.categoryId != 0) {
      BlocProvider.of<ProductBloc>(context)
          .add(UpdateCategoryProduct(categoryId: widget.categoryId.toString()));
    } else {
      BlocProvider.of<ProductBloc>(context).add(UpdateMyProduct(token: userId));
    }
  }

  @override
  void initState() {
    _setBlocEvents();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 3;
    final double itemWidth = size.width / 2;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        leading: IconButton(
          icon:
              Icon(Ionicons.getIconData("ios-arrow-back"), color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SizedBox(
              height: 18.0,
              width: 18.0,
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  MaterialCommunityIcons.getIconData("magnify"),
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: SizedBox(
              height: 18.0,
              width: 18.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: SizedBox(
              height: 18.0,
              width: 18.0,
              child: IconButton(
                icon: Icon(
                  MaterialCommunityIcons.getIconData("cart-outline"),
                ),
                color: Colors.black,
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.fade,
                      child: ProductListScreen(
                        userId: userId,
                        title: 'Categories',
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Container(
          padding: EdgeInsets.only(top: 18),
          child: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return Center(
                    child: CircularProgressIndicator(color: Colors.redAccent));
              } else if (state is ProductFaluire) {
                return Center(
                  child: Text(
                    state.error,
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                );
              } else if (state is ProductLodaded) {
                List<Product> products;
                if (widget.isOrderCreation) {
                  products = state.products
                      .where((product) => product.isApproved == true)
                      .toList();
                } else {
                  products = state.products;
                }

                if (products.length < 1) {
                  return Center(
                      child: Text(widget.isOrderCreation
                          ? 'You don not have approved product'
                          : widget.categoryId == 0
                              ? 'Please Add your Product First'
                              : 'No ${widget.title} available right now Please come leater!'));
                }
                return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Container(
                          height: 150,
                          child: Card(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          NetworkImage(products[index].image),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 11),
                                      Text(products[index].name),
                                      Text('RS:   ${products[index].estPrice}'),
                                      SizedBox(height: 7),
                                      BlocBuilder<ProfileBloc, ProfileState>(
                                        builder: (context, state) {
                                          if (state is ProfileLodaded) {
                                            return Row(
                                              children: [
                                                Container(
                                                  width: 24,
                                                  height: 24,
                                                  child: CircleAvatar(
                                                    backgroundImage: state
                                                                .profile
                                                                .image ==
                                                            null
                                                        ? AssetImage(
                                                            'assets/profile.jpeg')
                                                        : NetworkImage(
                                                            state.profile
                                                                    .image ??
                                                                "https://miro.medium.com/fit/c/256/256/1*mZ3xXbns5BiBFxrdEwloKg.jpeg",
                                                          ),
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Text(
                                                  state.profile.slug,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                          return Container();
                                        },
                                      ),
                                      Spacer(),
                                      if (products[index].isApproved)
                                        Text(
                                          'Approved',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      if (products[index].isRejected)
                                        Text(
                                          'Reject',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      if (products[index].isApproved == false)
                                        Text(
                                          'Approval Pending',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      SizedBox(height: 11),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          if (widget.otherProduct == null) {
                            Nav.route(
                                context,
                                ProductPage(
                                  userId: userId,
                                  product: products[index],
                                ));
                          } else {
                            Nav.route(
                                context,
                                OrderDetailScreen(
                                    otherProductId: widget.otherProduct,
                                    ownPerduct: products[index]));
                          }
                        },
                      );
                    });
              }

              return Container();
            },
          )
          // GridView.count(
          //   crossAxisCount: 1,
          //   childAspectRatio: (itemWidth / itemHeight) * 1.1,
          //   controller: ScrollController(keepScrollOffset: false),
          //   shrinkWrap: true,
          //   scrollDirection: Axis.vertical,
          //   children: <Widget>[
          //     Container(
          //       width: double.infinity,
          //       child: Center(
          //         child: TrendingItem(
          //           product: Product(
          //               address:
          //                   'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          //               descriptin: CustomStrings.mockProductDescription,
          //               name: 'iPhone 11 (128GB)',
          //               icon: 'assets/phone1.jpeg',
          //               price: '\$4,000'),
          //           gradientColors: [Color(0XFFa466ec), Colors.purple[400]],
          //         ),
          //       ),
          //     ),
          //     Center(
          //       child: TrendingItem(
          //         product: Product(
          //             address:
          //                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          //             descriptin: CustomStrings.mockProductDescription,
          //             name: 'iPhone 11 (64GB)',
          //             icon: 'assets/phone2.jpeg',
          //             price: '\$3,890'),
          //         gradientColors: [Color(0XFF6eed8c), Colors.green[400]],
          //       ),
          //     ),
          //     Center(
          //       child: TrendingItem(
          //         product: Product(
          //             address:
          //                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          //             descriptin: CustomStrings.mockProductDescription,
          //             name: 'Xiaomi Redmi Note8',
          //             icon: 'assets/mi1.png',
          //             price: '\$2,890'),
          //         gradientColors: [Color(0XFFf28767), Colors.orange[400]],
          //       ),
          //     ),
          //     Center(
          //       child: TrendingItem(
          //         product: Product(
          //             address:
          //                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          //             descriptin: CustomStrings.mockProductDescription,
          //             name: 'iPhone 11 (128GB)',
          //             icon: 'assets/phone1.jpeg',
          //             price: '\$4,000'),
          //         gradientColors: [Color(0XFFa466ec), Colors.purple[400]],
          //       ),
          //     ),
          //     Center(
          //       child: TrendingItem(
          //         product: Product(
          //             address:
          //                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          //             descriptin: CustomStrings.mockProductDescription,
          //             name: 'iPhone 11 (64GB)',
          //             icon: 'assets/phone2.jpeg',
          //             price: '\$3,890'),
          //         gradientColors: [Color(0XFF6eed8c), Colors.green[400]],
          //       ),
          //     ),
          //     Center(
          //       child: TrendingItem(
          //         product: Product(
          //             address:
          //                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          //             descriptin: CustomStrings.mockProductDescription,
          //             name: 'Xiaomi Redmi Note8',
          //             icon: 'assets/mi1.png',
          //             price: '\$2,890'),
          //         gradientColors: [Color(0XFFf28767), Colors.orange[400]],
          //       ),
          //     ),
          //     Center(
          //       child: TrendingItem(
          //         product: Product(
          //             address:
          //                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          //             descriptin: CustomStrings.mockProductDescription,
          //             name: 'iPhone 11 (128GB)',
          //             price: '\$4,000'),
          //         gradientColors: [Color(0XFFa466ec), Colors.purple[400]],
          //       ),
          //     ),
          //     Center(
          //       child: TrendingItem(
          //         product: Product(
          //             address:
          //                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          //             descriptin: CustomStrings.mockProductDescription,
          //             name: 'iPhone 11 (64GB)',
          //             icon: 'assets/phone2.jpeg',
          //             price: '\$3,890'),
          //         gradientColors: [Color(0XFF6eed8c), Colors.green[400]],
          //       ),
          //     ),
          //     Center(
          //       child: TrendingItem(
          //         product: Product(
          //             address:
          //                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
          //             descriptin: CustomStrings.mockProductDescription,
          //             name: 'Xiaomi Redmi Note8',
          //             icon: 'assets/mi1.png',
          //             price: '\$2,890'),
          //         gradientColors: [Color(0XFFf28767), Colors.orange[400]],
          //       ),
          //     ),
          //   ],
          // ),
          ),
      // ),
    );
  }

  // @override
  // void dispose() {
  //   BlocProvider.of<ProductBloc>(context).add(InitialProductEvent());
  //   print('dispose');
  //   super.dispose();
  // }
}
