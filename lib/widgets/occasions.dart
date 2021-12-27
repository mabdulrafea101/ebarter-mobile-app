import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttercommerce/constant/constants.dart';
import 'package:fluttercommerce/logic/product/bloc/product_bloc.dart';
import 'package:fluttercommerce/utils/navigator.dart';
import 'package:fluttercommerce/widgets/star_rating.dart';
import 'package:fluttercommerce/screens/product.dart';

import '../models/product.dart';

class Occasions extends StatefulWidget {
  final String userId;

  Occasions({@required this.userId});
  @override
  _OccasionsState createState() => _OccasionsState();
}

class _OccasionsState extends State<Occasions> {
  @override
  void initState() {
    super.initState();
    setProductBlocEvent();
  }

  setProductBlocEvent() {
    BlocProvider.of<ProductBloc>(context).add(UpdateProduct(token: 'token'));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return CircularProgressIndicator(color: Colors.redAccent);
        } else if (state is ProductLodaded) {
          return InkWell(
            onTap: () {
              Nav.route(
                  context,
                  ProductPage(
                    product: state.products[0],
                    userId: widget.userId,
                  ));
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 220,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Mobile Special Offer",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w600),
                              textAlign: TextAlign.start,
                            ),
                            Icon(
                              SimpleLineIcons.getIconData("screen-smartphone"),
                              color: Colors.black54,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Divider(
                            color: Colors.black12,
                            height: 1,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.black12)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset('assets/iphone_x.png',
                                    height: 120,
                                    width:
                                        MediaQuery.of(context).size.width / 3),
                              ),
                            ),
                            SizedBox(
                              width: 24,
                            ),
                            Container(
                              height: 142,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1, color: Colors.black12)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "06 : 43 : 32",
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Text(
                                        "Iphone Xs Max",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "PKR 130000",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 6,
                                        ),
                                        // Text(
                                        //   '#6.789',
                                        //   style: TextStyle(
                                        //       color: Colors.grey,
                                        //       fontSize: 12,
                                        //       decoration:
                                        //           TextDecoration.lineThrough),
                                        // )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: StarRating(rating: 4, size: 10),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 4.0),
                                    //   child: Text("Free Cargo"),
                                    // ),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 4.0),
                                    //   // child: Text(
                                    //   //   "Last 11 Item",
                                    //   //   style: TextStyle(
                                    //   //       color:
                                    //   //           Theme.of(context).primaryColor),
                                    //   // ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
