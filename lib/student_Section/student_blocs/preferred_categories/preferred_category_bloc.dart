import 'package:anjalim/student_Section/services/profile_update_searvices/preferred_Categories_repository.dart';
import 'package:anjalim/student_Section/student_blocs/preferred_categories/preferred_category_event.dart';
import 'package:anjalim/student_Section/student_blocs/preferred_categories/preferred_category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository) : super(const CategoryState()) {
    on<LoadCategories>(_onLoadCategories);
    on<SearchCategories>(_onSearchCategories);
    on<SelectCategory>(_onSelectCategory);
    on<SaveCategory>(_onSaveCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final categories = await repository.fetchPreferredCategories();
      final preferredCategories = await repository.fetchSelectedCategories();
      emit(state.copyWith(
        categories: categories,
        filteredCategories: categories,
        preferredCategories: preferredCategories,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void _onSearchCategories(
      SearchCategories event, Emitter<CategoryState> emit) {
    final query = event.query.toLowerCase();
    final filtered = state.categories
        .where((category) => category['label']!.toLowerCase().contains(query))
        .toList();
    emit(state.copyWith(filteredCategories: filtered));
  }

  void _onSelectCategory(SelectCategory event, Emitter<CategoryState> emit) {
    emit(state.copyWith(
        selectedCategory: event.categoryValue, errorMessage: null));
  }

  Future<void> _onSaveCategory(
      SaveCategory event, Emitter<CategoryState> emit) async {
    if (state.selectedCategory == null) {
      emit(state.copyWith(errorMessage: "Please select a category"));
      return;
    }
    try {
      await repository.submitSelectedCategory(state.selectedCategory!);
      final preferredCategories = await repository.fetchSelectedCategories();
      emit(state.copyWith(preferredCategories: preferredCategories));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteCategory(
      DeleteCategoryEvent event, Emitter<CategoryState> emit) async {
    try {
      await repository.deleteCategory(event.preferenceId);
      final preferredCategories = await repository.fetchSelectedCategories();
      emit(state.copyWith(
          preferredCategories: preferredCategories, selectedCategory: null));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
