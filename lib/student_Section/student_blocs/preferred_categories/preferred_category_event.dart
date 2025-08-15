import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {}

class SearchCategories extends CategoryEvent {
  final String query;
  SearchCategories(this.query);
  @override
  List<Object?> get props => [query];
}

class SelectCategory extends CategoryEvent {
  final String categoryValue;
  SelectCategory(this.categoryValue);
  @override
  List<Object?> get props => [categoryValue];
}

class SaveCategory extends CategoryEvent {}

class DeleteCategoryEvent extends CategoryEvent {
  final int preferenceId;
  DeleteCategoryEvent(this.preferenceId);
  @override
  List<Object?> get props => [preferenceId];
}
