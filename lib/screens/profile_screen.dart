import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommerce/logic/profile/bloc/profile_bloc.dart';
import 'package:fluttercommerce/logic/upload_profile/bloc/upload_profile_bloc.dart';
import 'package:fluttercommerce/models/profile.dart';
import 'package:fluttercommerce/utils/shared_preferences_handler.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController _slugController = TextEditingController();
  TextEditingController _firstAddressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _secondAddressController = TextEditingController();
  // TextEditingController _addressController = TextEditingController();
  // TextEditingController _addressController = TextEditingController();

  XFile _image;
  String _userId;

  _setBlocEvent() async {
    _userId = await SharedPreferencesHandler.getToken();
    BlocProvider.of<ProfileBloc>(context)
        .add(UpdateProfile(token: 'token', userId: _userId));
  }

  @override
  void initState() {
    _setBlocEvent();
    super.initState();
  }

  _setControllerText(Profile profile) {
    _slugController.text = profile.slug;
    _firstAddressController.text = profile.address1;
    _phoneController.text = profile.phone;
    _secondAddressController.text = profile.address2;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadProfileBloc, UploadProfileState>(
      listener: (context, state) {
        if (state is UploadProfileLodaded) {
          final snackBar = SnackBar(content: Text(state.message));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          BlocProvider.of<ProfileBloc>(context)
              .add(UpdateProfile(token: 'token', userId: _userId));
        } else if (state is UploadProfileFaluire) {
          final snackBar = SnackBar(content: Text(state.error));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profile'),
            backgroundColor: Colors.white,
          ),
          body: BlocBuilder<UploadProfileBloc, UploadProfileState>(
            builder: (context, state) {
              if (state is UploadProfileLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.redAccent,
                  ),
                );
              }
              return BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ProfileFaluire) {
                    return Text(state.error);
                  } else if (state is ProfileLodaded) {
                    _setControllerText(state.profile);
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            _buildProfileImg(state.profile.image),
                            SizedBox(height: 12),
                            _buildForm(state.profile),
                            SizedBox(height: 12),
                            _buildSaveButton(),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  _buildProfileImg(String imageUrl) {
    return InkWell(
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: _image == null
                ? imageUrl == null
                    ? AssetImage('assets/profile.jpeg')
                    : NetworkImage(imageUrl)
                : FileImage(File(_image.path)),
          ),
        ),
      ),
      onTap: _getImage,
    );
  }

  _buildForm(Profile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTextFieldTitle('User Name'),
        SizedBox(height: 4),
        _buildTextFormField(
          // hint: profile.slug ?? 'Enter your name',
          controller: _slugController,
        ),
        SizedBox(height: 12),
        _buildTextFieldTitle('Address'),
        SizedBox(height: 4),
        _buildTextFormField(
          // hint: profile.address1 ?? 'Enter your Address',
          controller: _firstAddressController,
        ),
        // SizedBox(height: 12),
        // _buildTextFieldTitle('Permanent Address'),
        // SizedBox(height: 4),
        // _buildTextFormField(
        //   // hint: profile.address2 ?? 'Enter your Permenent Address',
        //   controller: _secondAddressController,
        // ),
        SizedBox(height: 12),
        _buildTextFieldTitle('Phone Number'),
        SizedBox(height: 4),
        _buildTextFormField(
          // hint: profile.phone ?? 'Enter your Phone Number',
          controller: _phoneController,
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildTextFieldTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 12),
    );
  }

  Widget _buildSaveButton() {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.redAccent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'SAVE',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      onTap: _sendData,
    );
  }

  _sendData() {
    BlocProvider.of<UploadProfileBloc>(context).add(UploadProfileButtonPressed(
      slug: _slugController.text,
      address: _firstAddressController.text,
      phone: _phoneController.text,
      userId: _userId,
    ));
  }

  _getImage() async {
    final ImagePicker _picker = ImagePicker();
    _image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Widget _buildTextFormField({
    String hint,
    TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      // style: TextStyleUtile.normulTextStyle(
      //     fontSize: 14, color: kDarkLightTextColor),
      // onChanged: isIdField ? _checkIdIsExist : null,
      decoration: InputDecoration(
        fillColor: Colors.white,
        contentPadding: EdgeInsets.only(left: 20, top: 15),
        hintText: hint,
        labelText: hint,
        // suffixIcon: IconButton(
        //   icon: Icon(
        //     Icons.clear,
        //     size: 16,
        //   ),
        //   onPressed: () => _titleController.clear(),
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
