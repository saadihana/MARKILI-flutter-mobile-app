import 'package:equatable/equatable.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategorySelected extends CategoryState {
  final Map<String, dynamic> selectedCategory;

  const CategorySelected(this.selectedCategory);

  @override
  List<Object> get props => [selectedCategory];
}
