import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommerce/logic/wallet/bloc/wallet_bloc.dart';
import 'package:fluttercommerce/resources/repositories/transection_repository.dart';
import 'package:fluttercommerce/screens/my_voilet_screen.dart';
import 'package:fluttercommerce/utils/navigator.dart';
import 'package:fluttercommerce/utils/progressdialog.dart';
import 'package:fluttercommerce/utils/shared_preferences_handler.dart';
import 'package:fluttercommerce/widgets/submitbutton.dart';

class WithdrayWolletScreen extends StatefulWidget {
  final bool isWithdray;
  final int currentAmmount;
  const WithdrayWolletScreen({
    Key key,
    @required this.isWithdray,
    @required this.currentAmmount,
  }) : super(key: key);

  @override
  _WithdrayWolletScreenState createState() => _WithdrayWolletScreenState();
}

class _WithdrayWolletScreenState extends State<WithdrayWolletScreen> {
  @override
  Widget build(BuildContext context) {
    final TransectionRepository _transectionRepository =
        TransectionRepository();
    return BlocProvider(
      create: (context) => WalletBloc(repository: _transectionRepository),
      child: WithdrayWolletView(
          isWithdray: widget.isWithdray, currentAmmount: widget.currentAmmount),
    );
  }
}

class WithdrayWolletView extends StatefulWidget {
  final bool isWithdray;
  final int currentAmmount;
  const WithdrayWolletView({
    Key key,
    @required this.isWithdray,
    @required this.currentAmmount,
  }) : super(key: key);

  @override
  _WithdrayWolletViewState createState() => _WithdrayWolletViewState();
}

class _WithdrayWolletViewState extends State<WithdrayWolletView> {
  TextEditingController _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocListener<WalletBloc, WalletState>(
      listener: (context, state) {
        if (state is WalletFaluire) {
          final snackBar = SnackBar(
            content: Text(state.error),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else if (state is WalletAmountAddSucessful) {
          final snackBar = SnackBar(
            content: Text(state.message),
          );

          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Nav.route(context, MyWalletScreen());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          title: Text(
            widget.isWithdray ? 'Withdraw' : 'Deposit',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            if (state is WalletLoading) {
              return Center(
                  child: CircularProgressIndicator(color: Colors.redAccent));
            }
            return _buildMainCard();
          },
        ),
      ),
    );
  }

  _buildMainCard() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 400,
            child: Card(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Add ${widget.isWithdray ? 'Withdraw' : 'Deposit'} Ammount',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      _buildTextFormField(
                        hint: 'Add Amount',
                        controller: _amountController,
                      ),
                      SizedBox(height: 32),
                      Center(
                        child: SubmitButton(
                          act: widget.isWithdray ? _onWithdraw : _onDeposit,
                          title: 'ADD',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  _onWithdraw() async {
    if (widget.currentAmmount < int.parse(_amountController.text)) {
      MessageBox(context, 'Yor amount is less than ${_amountController.text}',
              'Low Balance')
          .show();
    } else {
      final userId = await SharedPreferencesHandler.getToken();
      final amount = widget.currentAmmount - int.parse(_amountController.text);
      BlocProvider.of<WalletBloc>(context).add(
        AddWalletAmount(
          userId: userId,
          currentAmount: amount.toString(),
          title: 'Withdraw',
        ),
      );
    }
  }

  _onDeposit() async {
    final userId = await SharedPreferencesHandler.getToken();
    final amount = widget.currentAmmount + int.parse(_amountController.text);
    BlocProvider.of<WalletBloc>(context).add(
      AddWalletAmount(
        userId: userId,
        currentAmount: amount.toString(),
        title: 'Deposit',
      ),
    );
  }

  Widget _buildTextFormField({
    String hint,
    TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.number,
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
          onPressed: () => _amountController.clear(),
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
