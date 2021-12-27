import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommerce/logic/wallet/bloc/wallet_bloc.dart';
import 'package:fluttercommerce/models/transection.dart';
import 'package:fluttercommerce/models/wallet.dart';
import 'package:fluttercommerce/resources/repositories/transection_repository.dart';
import 'package:fluttercommerce/screens/withdray_wallet_screen.dart';
import 'package:fluttercommerce/utils/navigator.dart';
import 'package:fluttercommerce/utils/shared_preferences_handler.dart';

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({Key key}) : super(key: key);

  @override
  _MyWalletScreenState createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  @override
  Widget build(BuildContext context) {
    final TransectionRepository _transectionRepository =
        TransectionRepository();
    return BlocProvider(
      create: (context) => WalletBloc(repository: _transectionRepository),
      child: MyVoiletView(),
    );
  }
}

class MyVoiletView extends StatefulWidget {
  const MyVoiletView({Key key}) : super(key: key);

  @override
  _MyVoiletViewState createState() => _MyVoiletViewState();
}

class _MyVoiletViewState extends State<MyVoiletView> {
  _setBlocEvent() async {
    final userId = await SharedPreferencesHandler.getToken();
    BlocProvider.of<WalletBloc>(context).add(UpdateWallet(userId: userId));
  }

  @override
  void initState() {
    _setBlocEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                'My Wallet',
                style: TextStyle(color: Colors.black54),
              ),
            ),
            body: BlocBuilder<WalletBloc, WalletState>(
              builder: (context, state) {
                if (state is WalletLoading) {
                  return Center(
                      child:
                          CircularProgressIndicator(color: Colors.redAccent));
                } else if (state is WalletFaluire) {
                  return Text(state.error);
                }
                if (state is WalletLodaded) {
                  return _buildBlocResponse(state.wallet, state.transactions);
                }
                return Container();
              },
            )));
  }

  _buildBlocResponse(Wallet wallet, List<Transection> transections) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 8),
            _buildButtons(wallet.currentAmount),
            SizedBox(height: 8),
            _buildVoilet(wallet.currentAmount.toString()),
            SizedBox(height: 24),
            Text(
              'Transaction History',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.black54),
            ),
            SizedBox(height: 24),
            _buildTransactionsList(transections)
          ],
        ),
      ),
    );
  }

  _buildButtons(int currentAmount) {
    return Row(children: [
      MaterialButton(
        onPressed: () {
          Nav.route(
              context,
              WithdrayWolletScreen(
                  isWithdray: false, currentAmmount: currentAmount));
        },
        child: Text(
          'Deposit',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.redAccent,
      ),
      SizedBox(width: 12),
      MaterialButton(
        onPressed: () {
          Nav.route(
              context,
              WithdrayWolletScreen(
                  isWithdray: true, currentAmmount: currentAmount));
        },
        child: Text(
          'Withdray',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.redAccent,
      ),
    ]);
  }

  _buildVoilet(String currentAmount) {
    return Container(
      width: double.infinity,
      height: 200,
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                height: 82,
                width: 82,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/wallet.png'),
                  ),
                ),
              ),
            ),
            Spacer(),
            Expanded(
              child: Text(
                'RS: $currentAmount',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.black87),
              ),
            ),
          ],
        ),
      )),
    );
  }

  _buildTransactionsList(List<Transection> transactions) {
    return ListView.builder(
        itemCount: transactions.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Card(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transection # ${transactions[index].transectionNumber}',
                  maxLines: 1,
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: 6),
                Text(
                  'Amount: ${transactions[index].transferedAmount}',
                  style: TextStyle(color: Colors.black87),
                ),
                SizedBox(height: 6),
                Text(
                  'created at: ${transactions[index].createdAt}',
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 6),
              ],
            ),
          ));
        });
  }
}
