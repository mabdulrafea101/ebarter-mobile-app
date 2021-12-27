import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:fluttercommerce/models/transection.dart';
import 'package:fluttercommerce/models/wallet.dart';
import 'package:fluttercommerce/resources/repositories/transection_repository.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final TransectionRepository repository;
  WalletBloc({@required this.repository}) : super(WalletInitial());

  @override
  Stream<WalletState> mapEventToState(WalletEvent event) async* {
    if (event is UpdateWallet) {
      yield WalletLoading();

      try {
        final Wallet wallet = await repository.fetchWallet(event.userId);
        final TransectionList transectionList =
            await repository.fetchTransections();

        yield WalletLodaded(
            wallet: wallet, transactions: transectionList.productList);
      } on HttpException {
        yield WalletFaluire(
          error: ('No Service'),
        );
      } catch (e) {
        print(e);
        yield WalletFaluire(error: e.toString());
      }
    } else if (event is AddWalletAmount) {
      yield WalletLoading();

      try {
        final String message = await repository.setAmount(
          event.userId,
          event.currentAmount,
          event.title,
        );

        yield WalletAmountAddSucessful(message: message);
      } on HttpException {
        yield WalletFaluire(
          error: ('No Service'),
        );
      } catch (e) {
        print(e);
        yield WalletFaluire(error: e.toString());
      }
    }
  }
}
