import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttercommerce/logic/upload_product/bloc/upload_product_bloc.dart';
import 'package:fluttercommerce/screens/home.dart';
import 'package:fluttercommerce/utils/navigator.dart';
import 'package:fluttercommerce/utils/shared_preferences_handler.dart';

class AddCommentScreen extends StatefulWidget {
  final int productId;
  AddCommentScreen({Key key, @required this.productId}) : super(key: key);

  @override
  State<AddCommentScreen> createState() => _AddCommentScreenState();
}

class _AddCommentScreenState extends State<AddCommentScreen> {
  final TextEditingController _commentController = TextEditingController();
  int _rating;
  String _userId;

  @override
  void initState() {
    _getUserId();
    super.initState();
  }

  _getUserId() async {
    _userId = await SharedPreferencesHandler.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("", style: TextStyle(color: Colors.grey[600])),
      ),
      body: BlocListener<UploadProductBloc, UploadProductState>(
        listener: (context, state) {
          if (state is UploadProductFaluire) {
            final snackBar = SnackBar(content: Text(state.error));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is UploadProductLodaded) {
            final snackBar = SnackBar(content: Text(state.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Nav.route(context, Home());
          }
        },
        child: _buildBody(),
      ),
    );
  }

  _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enter your reviews',
              style: Theme.of(context).textTheme.headline6),
          SizedBox(height: 12),
          _buildTextFormField(
            hint: '',
            maxLines: 8,
            controller: _commentController,
          ),
          SizedBox(height: 12),
          _buildStars(),
          SizedBox(height: 32),
          MaterialButton(
            color: Colors.redAccent,
            onPressed: () {
              BlocProvider.of<UploadProductBloc>(context)
                  .add(ProductUpladButtonPressed(
                token: widget.productId.toString(),
                name: null,
                slug: null,
                estPrice: null,
                approvedBy: null,
                isSoled: null,
                owner: null,
                category: null,
                isApproved: null,
                productImage: null,
                description: null,
                ratings: _rating,
                reviewComment: _commentController.text,
                reviewByUser: int.parse(_userId),
              ));
            },
            child: BlocBuilder<UploadProductBloc, UploadProductState>(
              builder: (context, state) {
                if (state is UploadProductLoading) {
                  return Center(
                      child:
                          CircularProgressIndicator(color: Colors.redAccent));
                }
                return Text(
                  'SEND',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _buildStars() {
    return Center(
      child: RatingBar.builder(
        initialRating: 3,
        minRating: 1,
        direction: Axis.horizontal,
        allowHalfRating: true,
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
        itemBuilder: (context, _) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        onRatingUpdate: (rating) {
          _rating = rating.toInt();
          print(rating);
        },
      ),
    );
  }

  Widget _buildTextFormField({
    String hint,
    TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      // style: TextStyleUtile.normulTextStyle(
      //     fontSize: 14, color: kDarkLightTextColor),
      // onChanged: isIdField ? _checkIdIsExist : null,
      decoration: InputDecoration(
        fillColor: Colors.white,
        contentPadding: EdgeInsets.only(left: 20, top: 0),
        hintText: hint,
        labelText: hint,
        // suffixIcon: IconButton(
        //   icon: Icon(
        //     Icons.clear,
        //     size: 16,
        //   ),
        //   onPressed: () => controller.clear(),
        // ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(maxLines == 1 ? 50 : 18),
          borderSide: BorderSide(color: Theme.of(context).accentColor),
        ),
      ),
      validator: (value) {
        return value == null ? 'Please fill the field' : null;
      },
    );
  }
}
