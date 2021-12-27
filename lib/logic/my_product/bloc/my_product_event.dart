part of 'my_product_bloc.dart';

abstract class MyProductEvent extends Equatable {
  const MyProductEvent();

  @override
  List<Object> get props => [];
}

class UpdateMyProduct extends MyProductEvent {
  final String token;

  UpdateMyProduct({@required this.token});

  @override
  List<Object> get props => [token];
}
