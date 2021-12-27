import 'package:fluttercommerce/models/transection.dart';
import 'package:fluttercommerce/models/wallet.dart';
import 'package:fluttercommerce/resources/providers/transection_provider.dart';
import 'package:fluttercommerce/resources/providers/wallet_provider.dart';

class TransectionRepository {
  final WalletProvider _walletProvider = WalletProvider();

  final TransectionProvider _transectionProvider = TransectionProvider();

  Future<Wallet> fetchWallet(String id) => _walletProvider.getData(id);

  Future<String> setAmount(String id, String currentAmount, String title) =>
      _walletProvider.setData(id, currentAmount, title);

  Future<TransectionList> fetchTransections() =>
      _transectionProvider.getData('token');
}
