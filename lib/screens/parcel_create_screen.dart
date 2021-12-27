import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/ionicons.dart';
import 'package:flutter_icons/material_community_icons.dart';
import 'package:fluttercommerce/logic/login/upload_parcel/bloc/upload_parcel_bloc.dart';
import 'package:fluttercommerce/screens/home.dart';
import 'package:fluttercommerce/utils/navigator.dart';
import 'package:fluttercommerce/widgets/submitbutton.dart';

class ParcelCreateScreen extends StatefulWidget {
  final String otherProductId;
  final String ownProductId;
  const ParcelCreateScreen(
      {Key key, @required this.otherProductId, @required this.ownProductId})
      : super(key: key);

  @override
  ParcelCreateScreenState createState() => ParcelCreateScreenState();
}

class ParcelCreateScreenState extends State<ParcelCreateScreen> {
  final TextEditingController _trakingNumberController =
      TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _shippingCostController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadParcelBloc, UploadParcelState>(
      listener: (context, state) {
        if (state is UploadParcelLodaded) {
          final snackBar =
              SnackBar(content: Text('You successfully place order'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Nav.route(context, Home());
        }
      },
      child: SafeArea(
          child: Scaffold(
              appBar: _buildAppbar(),
              body: BlocBuilder<UploadParcelBloc, UploadParcelState>(
                builder: (context, state) {
                  if (state is UploadParcelLoading) {
                    return Center(
                        child:
                            CircularProgressIndicator(color: Colors.redAccent));
                  }
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 48),
                        _buildTextFormField(
                            controller: _trakingNumberController,
                            hint: 'Enter Tracking Number:'),
                        SizedBox(height: 32),
                        _buildTextFormField(
                            controller: _weightController,
                            hint: 'Enter Weight in mass:'),
                        SizedBox(height: 32),
                        _buildTextFormField(
                            controller: _shippingCostController,
                            hint: 'Enter Shipping Cost:'),
                        SizedBox(height: 32),
                        _buldSaveButton(),
                      ],
                    ),
                  );
                },
              ))),
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
        contentPadding: EdgeInsets.only(left: 20, top: 15),
        hintText: hint,
        labelText: hint,
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear,
            size: 16,
          ),
          onPressed: () => controller.clear(),
        ),
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

  Widget _buildAppbar() {
    return AppBar(
      title: Text(
        "Parcel Detail",
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

  Widget _buldSaveButton() {
    return SubmitButton(
      title: "Save",
      act: () {
        BlocProvider.of<UploadParcelBloc>(context)
            .add(ParcelUploadButtonPressed(
                token: 'token',
                trackingNumber: int.parse(_trakingNumberController.text),
                massWeight: _weightController.text,
                shippingCost: int.parse(_shippingCostController.text),
                ownProduct: int.parse(widget.ownProductId),
                otherProduct: int.parse(
                  widget.otherProductId,
                )));
      },
    );
  }
}
