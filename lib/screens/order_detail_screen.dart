import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_icons/material_community_icons.dart';
import 'package:fluttercommerce/logic/my_product/bloc/my_product_bloc.dart';
import 'package:fluttercommerce/logic/order_create/bloc/order_create_bloc.dart';
import 'package:fluttercommerce/logic/patch_order/bloc/patch_order_bloc.dart';
import 'package:fluttercommerce/logic/profile/bloc/profile_bloc.dart';
import 'package:fluttercommerce/models/product.dart';
import 'package:fluttercommerce/screens/home.dart';
import 'package:fluttercommerce/screens/my_voilet_screen.dart';
import 'package:fluttercommerce/screens/shoppingcart.dart';
import 'package:fluttercommerce/utils/colors.dart';
import 'package:fluttercommerce/utils/navigator.dart';
import 'package:fluttercommerce/widgets/dotted_slider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class OrderDetailScreen extends StatefulWidget {
  final String otherProductId;
  final Product ownPerduct;
  final int orderId;
  final int approvalFrom;
  const OrderDetailScreen({
    Key key,
    @required this.otherProductId,
    @required this.ownPerduct,
    this.orderId,
    this.approvalFrom,
  }) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  _setBlocEvent(String userId) {
    BlocProvider.of<ProfileBloc>(context)
        .add(UpdateProfile(token: 'token', userId: userId));
  }

  int priceDifference;
  String userId = '1';

  @override
  void initState() {
    BlocProvider.of<MyProductBloc>(context)
        .add(UpdateMyProduct(token: 'token'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // BlocProvider.of<ProductBloc>(context).add(UpdateProduct(token: 'token'));
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppbar(),
        body: BlocListener<PatchOrderBloc, PatchOrderState>(
          listener: (context, state) {
            if (state is PatchOrderFaluire) {
              final snackBar = SnackBar(content: Text(state.error));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (state is PatchOrderLodaded) {
              final snackBar = SnackBar(content: Text(state.message));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Nav.route(context, Home());
            }
          },
          child: BlocListener<OrderCreateBloc, OrderCreateState>(
            listener: (context, state) {
              if (state is OrderCreateFaluire) {
                _alert(context);
              } else if (state is OrderCreateLodaded) {
                final snackBar =
                    SnackBar(content: Text('Order Approve sucessfuly!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Nav.route(context, Home());
              }
            },
            child: BlocBuilder<PatchOrderBloc, PatchOrderState>(
              builder: (context, state) {
                if (state is PatchOrderLoading) {
                  return Center(
                      child:
                          CircularProgressIndicator(color: Colors.redAccent));
                }
                return BlocBuilder<OrderCreateBloc, OrderCreateState>(
                  builder: (context, state) {
                    if (state is OrderCreateLoading) {
                      return Center(
                          child: CircularProgressIndicator(
                              color: Colors.redAccent));
                    }
                    return BlocBuilder<MyProductBloc, MyProductState>(
                      builder: (context, state) {
                        if (state is MyProductLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                                color: Colors.redAccent),
                          );
                        }
                        if (state is MyProductLodaded) {
                          userId = state.userId;

                          print('$userId---------userid');
                          var otherProduct;
                          try {
                            otherProduct = state.products.firstWhere(
                                (product) =>
                                    product.id.toString() ==
                                    widget.otherProductId);
                          } on Exception catch (e) {
                            BlocProvider.of<MyProductBloc>(context)
                                .add(UpdateMyProduct(token: 'token'));
                          }

                          try {
                            _setBlocEvent(otherProduct.owner.toString());
                          } catch (e) {}

                          // var ownProduct = state.products
                          //     .where((product) =>
                          //         product.id.toString() == widget.ownPerductId)
                          //     .toList();
                          try {
                            priceDifference = (otherProduct.estPrice -
                                widget.ownPerduct.estPrice);
                          } catch (e) {}

                          return SingleChildScrollView(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              BlocBuilder<ProfileBloc, ProfileState>(
                                builder: (context, state) {
                                  if (state is ProfileLodaded) {
                                    return _buildProduct(
                                        otherProduct, state.profile.slug);
                                  }
                                  return _buildProduct(otherProduct, '');
                                },
                              ),
                              SizedBox(height: 24),
                              Divider(
                                height: 2,
                                color: Colors.black,
                              ),
                              SizedBox(height: 24),
                              _buildProduct(widget.ownPerduct, 'Me'),
                              // Spacer(),
                              _buildBottomNavigation(),
                            ],
                          ));
                        }
                        return Container();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
        // body: _buildProduct(widget.otherProduct),
      ),
    );
  }

  Widget _buildProduct(Product product, String userName) {
    return Container(
      // height: MediaQuery.of(context).size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(product.image),
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 8),
          _buildInfo(context, product.name,
              product.estPrice.toString()), //Product Info
          // _buildExtra(context),

          _buildDescription(context, product.description),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            //! show user profice data
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLodaded) {
                  return Row(
                    children: [
                      Container(
                        child: CircleAvatar(
                          backgroundImage: state.profile.image != null
                              ? NetworkImage(
                                  state.profile.image,
                                )
                              : AssetImage('assets/profile.jpeg'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        userName ?? "Farhan Khan",
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
          ),
          SizedBox(height: 7),
        ],
      ),
    );
  }

  _buildDescription(BuildContext context, String description) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 3.8,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Description",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black45,
                fontSize: 18,
              ),
            ),
            Text(description ?? ''),
          ],
        ),
      ),
    );
  }

  dottedSlider() {
    return DottedSlider(
      maxHeight: 200,
      children: <Widget>[
        _productSlideImage('assets/phone1.png'),
        _productSlideImage("assets/phone2.png"),
        _productSlideImage("assets/phone1.png"),
        _productSlideImage("assets/phone1.png"),
      ],
    );
  }

  _productSlideImage(String imageUrl) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image:
            DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.contain),
      ),
    );
  }

  _buildInfo(context, String productName, String price) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Product",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
                Text(productName ?? ""),
              ],
            ),
            SizedBox(height: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Price",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
                Text(price ?? ""),
              ],
            ),
            SizedBox(height: 9),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Address",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black45,
                    fontSize: 18,
                  ),
                ),
                // SizedBox(
                //   width: 7,
                // ),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLodaded) {
                      print(state.profile.address1);
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

  _buildBottomNavigation() {
    print('$userId------------user id ------------------');
    return Container(
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
                //   "\PKR $priceDifference",
                //   style: TextStyle(
                //     color: Colors.black54,
                //     fontSize: 18,
                //   ),
                // ),
                SizedBox(
                  width: 6,
                ),
                // BlocBuilder<ProductBloc, ProductState>(
                //   builder: (context, state) {
                //     if (state is ProductLodaded) {
                //       return Text(
                //         'RS: ${widget.product.estPrice.toString()}',
                //         style: TextStyle(
                //             color: Colors.red,
                //             fontSize: 20,
                //             fontWeight: FontWeight.w700),
                //       );
                //     }
                //     return Text('');
                //   },
                // )
              ],
            ),
            SizedBox(
              width: 6,
            ),
            widget.orderId == null
                ? _orderButton()
                : widget.approvalFrom.toString() == userId
                    ? _orderButton()
                    : Container(),
          ],
        ),
      ),
    );
  }

  RaisedButton _orderButton() {
    return RaisedButton(
      onPressed: () {
        if (widget.orderId == null) {
          BlocProvider.of<OrderCreateBloc>(context)
              .add(CreateOrderButtonPressed(
            token: 'token',
            status: 'pending',
            extraPayment: priceDifference ?? 100,
            parcelFromBuyer: null,
            parcelFromSeller: null,
            product1: int.parse(widget.ownPerduct.id.toString()),
            product2: int.parse(widget.otherProductId),
          ));
        } else {
          BlocProvider.of<PatchOrderBloc>(context).add(PatchOrderButtonPressed(
              orderId: widget.orderId,
              status: 'accepted',
              product1: int.parse(widget.ownPerduct.id.toString()),
              product2: int.parse(
                widget.otherProductId,
              )));
          Nav.route(context, Home());
        }
      },
      textColor: Colors.white,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.9,
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
              widget.orderId == null ? 'Create Oreder' : "Approve",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppbar() {
    return AppBar(
      title: Text(
        "Order",
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      leading: IconButton(
        icon: Icon(Ionicons.getIconData("ios-arrow-back"), color: Colors.black),
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
            // child: IconButton(
            //   onPressed: () {},
            //   // icon: Icon(
            //   //   MaterialCommunityIcons.getIconData("heart-outline"),
            //   //   color: Colors.black,
            //   // ),
            // ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(right: 24.0),
        //   child: SizedBox(
        //     height: 18.0,
        //     width: 18.0,
        //     child: IconButton(
        //       icon: Icon(
        //         MaterialCommunityIcons.getIconData("cart-outline"),
        //       ),
        //       color: Colors.black,
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           PageTransition(
        //             type: PageTransitionType.fade,
        //             child: ProductListScreen(),
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // ),
      ],
      backgroundColor: Colors.white,
    );
  }

  _alert(BuildContext context) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.shrink,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: TextStyle(
        color: Colors.red,
      ),
    );
    Alert(
      context: context,
      style: alertStyle,
      type: AlertType.success,
      title: "Add Amount",
      desc: "You don not have enough money for this transaction",
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "GO Wallet",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Nav.route(context, MyWalletScreen()),
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }
}
