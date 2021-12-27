part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLodaded extends HomeState {
  final List<Product> products;
  final List<Category> categories;

  HomeLodaded({@required this.products, @required this.categories});
}

class HomeLoading extends HomeState {}

class HomeFaluire extends HomeState {
  final String error;

  HomeFaluire({@required this.error});
}
