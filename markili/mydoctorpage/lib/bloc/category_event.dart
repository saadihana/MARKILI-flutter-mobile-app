import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class SelectCategory extends CategoryEvent {
  final Map<String, dynamic> categoryData;

  const SelectCategory(this.categoryData);

  @override
  List<Object> get props => [categoryData];
}
