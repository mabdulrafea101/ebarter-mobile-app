part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class UpdateWallet extends WalletEvent {
  final String userId;

  UpdateWallet({@required this.userId});

  @override
  List<Object> get props => [this.userId];
}

class AddWalletAmount extends WalletEvent {
  final String userId;
  final String currentAmount;
  final String title;

  AddWalletAmount(
      {@required this.userId,
      @required this.currentAmount,
      @required this.title});
}
