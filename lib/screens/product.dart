import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttercommerce/logic/product/bloc/product_bloc.dart';
import 'package:fluttercommerce/logic/profile/bloc/profile_bloc.dart';
import 'package:fluttercommerce/models/product.dart';
import 'package:fluttercommerce/screens/products_list.dart';
import 'package:fluttercommerce/screens/search.dart';
import 'package:fluttercommerce/screens/shoppingcart.dart';
import 'package:fluttercommerce/screens/usersettings.dart';
import 'package:fluttercommerce/utils/colors.dart';
import 'package:fluttercommerce/utils/shared_preferences_handler.dart';
import 'package:fluttercommerce/widgets/dotted_slider.dart';
import 'package:fluttercommerce/widgets/item_product.dart';
import 'package:fluttercommerce/widgets/star_rating.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProductPage extends StatefulWidget {
  final Product product;
  final String userId;

  ProductPage({this.product, @required this.userId});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool isClicked = false;
  String _userId;
  var _profileBloc;

  @override
  void initState() {
    _setProductBlocEvent(widget.product.owner.toString());
    super.initState();
  }

  _setProductBlocEvent(String userId) async {
    _userId = await SharedPreferencesHandler.getToken();
    BlocProvider.of<ProductBloc>(context).add(UpdateProduct(token: 'token'));
    BlocProvider.of<ProfileBloc>(context)
        .add(UpdateProfile(token: 'token', userId: userId));
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Theme.of(context).backgroundColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 11,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(width: 0.5, color: Colors.black12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    child: Divider(
                      color: Colors.black26,
                      height: 4,
                    ),
                    height: 24,
                  ),
                  // Text(
                  //   "\PKR 5.674",
                  //   style: TextStyle(
                  //       color: Colors.black54,
                  //       fontSize: 18,
                  //       decoration: TextDecoration.lineThrough),
                  // ),
                  SizedBox(
                    width: 6,
                  ),
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLodaded) {
                        return Text(
                          'RS: ${widget.product.estPrice.toString()}',
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.w700),
                        );
                      }
                      return Text('');
                    },
                  )
                ],
              ),
              SizedBox(
                width: 6,
              ),
              RaisedButton(
                onPressed: () {
                  // setState(() {
                  //   isClicked = !isClicked;
                  // });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductListScreen(
                              otherProduct: widget.product.id.toString(),
                              userId: widget.userId.toString(),
                              title: 'My Product',
                              isOrderCreation: true,
                            )),
                  );
                },
                textColor: Colors.white,
                padding: const EdgeInsets.all(0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width / 2.7,
                  height: 60,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        CustomColors.GreenLight,
                        CustomColors.GreenDark,
                      ],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: CustomColors.GreenShadow,
                        blurRadius: 15.0,
                        spreadRadius: 7.0,
                        offset: Offset(0.0, 0.0),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Icon(
                        MaterialCommunityIcons.getIconData(
                          "cart-outline",
                        ),
                        color: Colors.white,
                      ),
                      new Text(
                        "Exchange With",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
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
            return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    actions: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.fade,
                              child: Search(),
                            ),
                          );
                        },
                        child: Icon(
                          MaterialCommunityIcons.getIconData("magnify"),
                          color: Colors.black,
                        ),
                      ),
                      Stack(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              MaterialCommunityIcons.getIconData(
                                  "cart-outline"),
                            ),
                            color: Colors.black,
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  child: UserSettings(),
                                ),
                              );
                            },
                          ),
                          isClicked
                              ? Positioned(
                                  left: 9,
                                  bottom: 13,
                                  child: Icon(
                                    Icons.looks_one,
                                    size: 14,
                                    color: Colors.red,
                                  ),
                                )
                              : Text(""),
                        ],
                      ),
                    ],
                    iconTheme: IconThemeData(
                      color: Colors.black, //change your color here
                    ),
                    backgroundColor: Colors.white,
                    expandedHeight: MediaQuery.of(context).size.height / 2.4,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(
                        this.widget.product.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      background: Padding(
                        padding: EdgeInsets.only(top: 48.0),
                        child: dottedSlider(),
                      ),
                    ),
                  ),
                ];
              },
              body: Container(
                height: MediaQuery.of(context).size.height,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _buildInfo(context), //Product Info
                      // _buildExtra(context),

                      _buildDescription(context, widget.product.description),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        //! show user profice data
                        child: BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            if (state is ProfileLodaded) {
                              return Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    child: CircleAvatar(
                                      backgroundImage: state.profile.image ==
                                              null
                                          ? AssetImage('assets/profile.jpeg')
                                          : NetworkImage(
                                              state.profile.image ??
                                                  "https://miro.medium.com/fit/c/256/256/1*mZ3xXbns5BiBFxrdEwloKg.jpeg",
                                            ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    state.profile.slug ?? "Farhan Khan",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Spacer(),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                      SizedBox(height: 7),
                      _buildComments(context, this.widget.product),
                      // _buildProducts(context, state.products),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Shopping Cart"),
      content: Text("Your product has been added to cart."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // _alert(BuildContext context) {
  //   var alertStyle = AlertStyle(
  //     animationType: AnimationType.shrink,
  //     isCloseButton: false,
  //     isOverlayTapDismiss: false,
  //     descStyle: TextStyle(fontWeight: FontWeight.bold),
  //     animationDuration: Duration(milliseconds: 400),
  //     alertBorder: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(8.0),
  //       side: BorderSide(
  //         color: Colors.grey,
  //       ),
  //     ),
  //     titleStyle: TextStyle(
  //       color: Color.fromRGBO(0, 179, 134, 1.0),
  //     ),
  //   );
  //   Alert(
  //     context: context,
  //     style: alertStyle,
  //     type: AlertType.success,
  //     title: "Shopping Cart",
  //     desc: "Your product has been added to cart.",
  //     buttons: [
  //       DialogButton(
  //         child: Text(
  //           "BACK",
  //           style: TextStyle(color: Colors.white, fontSize: 20),
  //         ),
  //         onPressed: () => Navigator.pop(context),
  //         color: Color.fromRGBO(0, 179, 134, 1.0),
  //       ),
  //       DialogButton(
  //         child: Text(
  //           "GO CART",
  //           style: TextStyle(color: Colors.white, fontSize: 20),
  //         ),
  //         onPressed: () => Navigator.push(
  //           context,
  //           PageTransition(
  //             type: PageTransitionType.fade,
  //             child: ShoppingCart(true),
  //           ),
  //         ),
  //         gradient: LinearGradient(colors: [
  //           Color.fromRGBO(116, 116, 191, 1.0),
  //           Color.fromRGBO(52, 138, 199, 1.0)
  //         ]),
  //       )
  //     ],
  //   ).show();
  // }

  _productSlideImage(String imageUrl) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image:
            DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.contain),
      ),
    );
  }

  dottedSlider() {
    return DottedSlider(
      maxHeight: 200,
      children: <Widget>[
        _productSlideImage(widget.product.image),
        // _productSlideImage("assets/phone1.png"),
        // _productSlideImage("assets/phone1.png"),
        // _productSlideImage("assets/phone1.png"),
      ],
    );
  }

  _buildInfo(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Address",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  width: 7,
                ),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLodaded) {
                      return Text(state.profile.address1 ??
                          "27/386 Rang Pura Lahore Punjab,");
                    }
                    return Container();
                  },
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: <Widget>[
            //     Container(width: 130, child: Text("Internal Storage")),
            //     SizedBox(
            //       width: 48,
            //     ),
            //     Text("128 GB"),
            //   ],
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 12.0),
            //   child: Text(
            //     "Tüm Özellikler >",
            //     style: TextStyle(color: Colors.black45),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  _buildExtra(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(width: 1.0, color: Colors.black12),
        bottom: BorderSide(width: 1.0, color: Colors.black12),
      )),
      padding: EdgeInsets.all(4.0),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Capacity"),
            Row(
              children: <Widget>[
                OutlineButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0)),
                  child: Text('64 GB'),
                  onPressed: () {}, //callback when button is clicked
                  borderSide: BorderSide(
                    color: Colors.grey, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 0.8, //width of the border
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                OutlineButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0)),
                  child: Text('128 GB'),
                  onPressed: () {}, //callback when button is clicked
                  borderSide: BorderSide(
                    color: Colors.red, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 1, //width of the border
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text("Color"),
            Row(
              children: <Widget>[
                OutlineButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0)),
                  child: Text('GOLD'),
                  onPressed: () {}, //callback when button is clicked
                  borderSide: BorderSide(
                    color: Colors.orangeAccent, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 1.5, //width of the border
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                OutlineButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0)),
                  child: Text('SILVER'),
                  onPressed: () {}, //callback when button is clicked
                  borderSide: BorderSide(
                    color: Colors.grey, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 0.8, //width of the border
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                OutlineButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(8.0)),
                  child: Text('PINK'),
                  onPressed: () {}, //callback when button is clicked
                  borderSide: BorderSide(
                    color: Colors.grey, //Color of the border
                    style: BorderStyle.solid, //Style of the border
                    width: 0.8, //width of the border
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildDescription(BuildContext context, String description) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3.8,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black45,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(description ?? 'no discription'),
            SizedBox(
              height: 8,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  _settingModalBottomSheet(context);
                },
                child: Text(
                  "View More",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                      fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildComments(BuildContext context, Product product) {
    if (product.ratings == null) {
      return Center(
          child:
              Text('No Comments', style: TextStyle(color: Colors.grey[400])));
    }
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.black12),
          bottom: BorderSide(width: 1.0, color: Colors.black12),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Comments",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54),
                ),
                // Text(
                //   "View All",
                //   style: TextStyle(fontSize: 18.0, color: Colors.blue),
                //   textAlign: TextAlign.end,
                // ),
              ],
            ),
            SizedBox(height: 12),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: <Widget>[
            //     SizedBox(
            //       width: 8,
            //     ),
            //     // Text(
            //     //   "1250 Comments",
            //     //   style: TextStyle(color: Colors.black54),
            //     // ),
            //   ],
            // ),
            SizedBox(
              child: Divider(
                color: Colors.black26,
                height: 4,
              ),
              height: 24,
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/profile.jpeg'),
              ),
              subtitle: Text(product.reviewComment ?? ''),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  StarRating(rating: product.ratings.toDouble(), size: 15),
                  SizedBox(
                    width: 8,
                  ),
                  // Text(
                  //   "12 Sep 2019",
                  //   style: TextStyle(fontSize: 12, color: Colors.black54),
                  // ),
                ],
              ),
            ),
            SizedBox(
              child: Divider(
                color: Colors.black26,
                height: 4,
              ),
              height: 24,
            ),
            // ListTile(
            //   leading: CircleAvatar(
            //     backgroundImage: NetworkImage(
            //         "https://i.picsum.photos/id/857/200/300.jpg?hmac=kFf6koUaHH4bIVWuoXIIsmZJQM_9Ew5l4AOeLL2UoG8"),
            //   ),
            //   subtitle: Text(
            //       "There was no ice cream in the freezer, nor did they have money to go to the store."),
            //   title: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: <Widget>[
            //       StarRating(rating: 4, size: 15),
            //       SizedBox(
            //         width: 8,
            //       ),
            //       Text(
            //         "15 Sep 2019",
            //         style: TextStyle(fontSize: 12, color: Colors.black54),
            //       ),
            //     ],
            //   ),
            // ),
            // SizedBox(
            //   child: Divider(
            //     color: Colors.black26,
            //     height: 4,
            //   ),
            //   height: 24,
            // ),
            // ListTile(
            //   leading: CircleAvatar(
            //     backgroundImage: NetworkImage(
            //         "https://pbs.twimg.com/profile_images/1020903668240052225/_6uVaH4c.jpg"),
            //   ),
            //   subtitle: Text(
            //       "I think I will buy the red car, or I will lease the blue one."),
            //   title: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: <Widget>[
            //       StarRating(rating: 4, size: 15),
            //       SizedBox(
            //         width: 8,
            //       ),
            //       Text(
            //         "25 Sep 2019",
            //         style: TextStyle(fontSize: 12, color: Colors.black54),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  _buildProducts(BuildContext context, List<Product> product) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  "Similar Items",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    print("Clicked");
                  },
                  child: Text(
                    "View All",
                    style: TextStyle(fontSize: 18.0, color: Colors.blue),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
        ),
        buildTrending(product)
      ],
    );
  }

  Column buildTrending(List<Product> products) {
    return Column(
      children: <Widget>[
        Container(
          height: 180,
          child: ListView.builder(
            itemCount: products.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return TrendingItem(
                product: products[index],
                gradientColors: [Color(0XFFa466ec), Colors.purple[400]],
                userId: widget.userId,
              );
            },
          ),
        )
      ],
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    "Description",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s."),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    _profileBloc.add(UpdateProfile(token: 'token', userId: _userId));
    print('dispose ((((((((((((((((())))))))))))))))))))');
    super.dispose();
  }
}
