part of 'wallet_bloc.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLodaded extends WalletState {
  final Wallet wallet;
  final List<Transection> transactions;

  WalletLodaded({@required this.wallet, @required this.transactions});
}

class WalletLoading extends WalletState {}

class WalletFaluire extends WalletState {
  final String error;

  WalletFaluire({@required this.error});
}

class WalletAmountAddSucessful extends WalletState {
  final String message;

  WalletAmountAddSucessful({@required this.message});
}
