import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommerce/logic/order_list/bloc/order_list_bloc.dart';
import 'package:fluttercommerce/models/order.dart';
import 'package:fluttercommerce/models/product.dart';
import 'package:fluttercommerce/screens/add_comment_screen.dart';
import 'package:fluttercommerce/screens/order_detail_screen.dart';
import 'package:fluttercommerce/screens/order_tracking_screen.dart';
import 'package:fluttercommerce/screens/product.dart';
import 'package:fluttercommerce/utils/navigator.dart';

class MyOrderScreen extends StatefulWidget {
  final List<Product> products;
  const MyOrderScreen({Key key, @required this.products}) : super(key: key);

  @override
  _MyOrderScreenState createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  Product ownProduct;
  Product otherProduct;

  _setProducts(int ownProductId, int otherProductId) {
    ownProduct =
        widget.products.firstWhere((product) => product.id == ownProductId);
    otherProduct =
        widget.products.firstWhere((product) => product.id == otherProductId);
  }

  _setBlocEvent() async {
    BlocProvider.of<OrderListBloc>(context)
        .add(UpdateOrderList(token: 'token'));
  }

  @override
  Widget build(BuildContext context) {
    _setBlocEvent();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("", style: TextStyle(color: Colors.grey[600])),
      ),
      body: BlocBuilder<OrderListBloc, OrderListState>(
        builder: (context, state) {
          if (state is OrderListLoading) {
            return Center(
                child: CircularProgressIndicator(color: Colors.redAccent));
          } else if (state is OrderListFaluire) {
            return Center(child: Text(state.error));
          } else if (state is OrderListLodaded) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Orders',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  SizedBox(height: 32),
                  _buildOrderList(state.orders),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  _buildOrderList(List<Order> orders) {
    return ListView.builder(
        itemCount: orders.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _buildOrder(orders[index]);
        });
  }

  _buildOrder(Order order) {
    print('${order.product1}====');
    ownProduct =
        widget.products.firstWhere((product) => product.id == order.product1);
    otherProduct =
        widget.products.firstWhere((product) => product.id == order.product2);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.status),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Expanded(
                    //   flex: 1,
                    _buildProduct(ownProduct.image, ownProduct.name,
                        ownProduct.estPrice.toString(), true),
                    // ),
                    Spacer(),
                    // Expanded(
                    //   flex: 1,
                    _buildProduct(otherProduct.image, otherProduct.name,
                        otherProduct.estPrice.toString(), false),
                    // ),
                  ],
                ),
                Row(
                  children: [
                    Text('Your Product',
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 12)),
                    Spacer(),
                    Text('Exchange with',
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          if (order.status == 'completed') {
            Nav.route(context, AddCommentScreen(productId: order.product2));
          } else if (order.status == 'accepted') {
            Nav.route(
                context,
                OrderTrackingScreen(
                    originLatitude: double.parse(ownProduct.latitude),
                    originLongitude: double.parse(ownProduct.longitude),
                    destLatitude: double.parse(otherProduct.latitude),
                    destLongitude: double.parse(otherProduct.longitude)));
          } else {
            Nav.route(
              context,
              OrderDetailScreen(
                orderId: order.id,
                otherProductId: otherProduct.id.toString(),
                ownPerduct: ownProduct,
                approvalFrom: order.approvalFrom,
              ),
            );
          }
        },
      ),
    );
  }

  _buildProduct(
      String imagePath, String productName, String productPrice, bool isLeft) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isLeft
            ? _buildImageView(imagePath)
            : _buildProductDetailColumn(productName, productPrice),
        isLeft
            ? _buildProductDetailColumn(productName, productPrice)
            : _buildImageView(imagePath),
      ],
    );
  }

  Column _buildProductDetailColumn(String productName, String productPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productName,
          style: TextStyle(color: Colors.grey[600]),
        ),
        SizedBox(height: 8),
        Text(
          'RS $productPrice',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }

  _buildImageView(String imgPath) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 40,
        height: 60,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(imgPath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
