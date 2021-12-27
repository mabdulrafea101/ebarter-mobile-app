part of 'patch_order_bloc.dart';

abstract class PatchOrderState extends Equatable {
  const PatchOrderState();

  @override
  List<Object> get props => [];
}

class PatchOrderInitial extends PatchOrderState {}

class PatchOrderLodaded extends PatchOrderState {
  final String message;

  PatchOrderLodaded({@required this.message});
}

class PatchOrderLoading extends PatchOrderState {}

class PatchOrderFaluire extends PatchOrderState {
  final String error;

  PatchOrderFaluire({@required this.error});
}
