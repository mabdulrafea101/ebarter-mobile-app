import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommerce/logic/category_bloc/bloc/category_bloc.dart';
import 'package:fluttercommerce/logic/upload_product/bloc/upload_product_bloc.dart';
import 'package:fluttercommerce/models/catogary.dart';
import 'package:fluttercommerce/utils/colors.dart';
import 'package:fluttercommerce/utils/get_current_location.dart';
import 'package:fluttercommerce/utils/shared_preferences_handler.dart';
import 'package:fluttercommerce/utils/styles.dart';
import 'package:fluttercommerce/widgets/add_sucessfully.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController _titleController;
  TextEditingController _priceController;
  TextEditingController _addressController;
  TextEditingController _descriptionController;
  GlobalKey _formKey = GlobalKey();
  // bool isSaveButtonPressed = false;
  XFile _image;
  String _selectedCategory;
  List<Category> _categories;

  Future getFile() async {
    final ImagePicker _picker = ImagePicker();
    _image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  setCategoryBlocEvent() {
    BlocProvider.of<CategoryBloc>(context).add(UpdateCategory());
  }

  @override
  void initState() {
    _titleController = TextEditingController();
    _priceController = TextEditingController();
    _addressController = TextEditingController();
    _descriptionController = TextEditingController();
    BlocProvider.of<UploadProductBloc>(context).add(ResetUploadProduct());
    setCategoryBlocEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'ADD PRODUCTS',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<UploadProductBloc, UploadProductState>(
        builder: (context, state) {
          if (state is UploadProductLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          } else if (state is UploadProductFaluire) {
            return Center(
              child: Text(
                state.error,
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
            );
          } else if (state is UploadProductLodaded) {
            return AddSucessfully();
          }
          return _buildMainBody();
        },
      ),
    );
  }

  Widget _buildMainBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SizedBox(
          height: 800,
          child: Column(
            children: [
              _buildForm(),
              SizedBox(height: 7),
              Text(
                'Enter Complete detail of your project like (condition of product and spacifictaions of product).',
                style: CustomTextStyles.textSubHeaderStyle(),
              ),
              SizedBox(height: 24),
              _buildRowOfButtons(),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: _buildSaveButton(),
              ),
              SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return InkWell(
      onTap: () async {
        Position currentLocation = await CurrentLocation.getCurrentLocation();
        final logitude = currentLocation.longitude;
        final latitude = currentLocation.latitude;
        Category category;
        if (_categories != null && _categories.length > 0) {
          category = _categories
              .firstWhere((category) => category.name == _selectedCategory);
        }
        final userId = await SharedPreferencesHandler.getToken();
        BlocProvider.of<UploadProductBloc>(context)
            .add(ProductUpladButtonPressed(
          token: 'token',
          name: _titleController.text,
          slug: _titleController.text,
          estPrice: int.parse(_priceController.text),
          approvedBy: null,
          isSoled: false,
          owner: userId,
          category: category != null ? category.id.toString() : '1',
          isApproved: false,
          ratings: null,
          reviewComment: null,
          reviewByUser: null,
          productImage: _image,
          description: _descriptionController.text,
          longitude: logitude.toString(),
          latitude: latitude.toString(),
        ));
      },
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            'SAVE',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String title, Function onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 50,
        width: 120,
        color: Colors.redAccent,
        child: Center(
          child: Text(title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
    );
  }

  Widget _buildRowOfButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildButton('Select Photos', () {
                getFile();
              }),
              Text(
                _image == null
                    ? 'Select Product photos that you want against this product'
                    : _image.path,
                maxLines: 2,
                style: TextStyle(
                  color: CustomColors.TextSubHeaderGrey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoaded) {
                    _categories = state.categories;
                    List<String> categoryNameList = [];
                    for (var category in state.categories) {
                      categoryNameList.add(category.name);
                    }
                    return DropdownButton<String>(
                      hint: Text('Categories'),
                      items: categoryNameList.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        _selectedCategory = value;
                      },
                    );
                  }
                  return DropdownButton<String>(
                    hint: Text('Categories'),
                    items: <String>[].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      value = value;
                    },
                  );
                },
              ),
              Text(
                'Select Product Categories that you want against this product',
                maxLines: 2,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: CustomColors.TextSubHeaderGrey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 12),
          _buildTextFormField(
              hint: 'Enter Product name', controller: _titleController),
          SizedBox(height: 18),
          _buildTextFormField(
            hint: 'Enter Product Price',
            controller: _priceController,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 18),
          _buildTextFormField(
              hint: 'Enter your PhoneNumber', controller: _addressController),
          SizedBox(height: 18),
          _buildTextFormField(
              hint: 'Enter Description',
              controller: _descriptionController,
              maxLines: 5),
        ],
      ),
    );
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
        suffixIcon: IconButton(
          icon: Icon(
            Icons.clear,
            size: 16,
          ),
          onPressed: () => _titleController.clear(),
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
}
