import 'package:equatable/equatable.dart';

class CategoryState extends Equatable {
  final List<Map<String, String>> categories;
  final List<Map<String, String>> filteredCategories;
  final List<Map<String, dynamic>> preferredCategories;
  final String? selectedCategory;
  final bool isLoading;
  final String? errorMessage;

  const CategoryState({
    this.categories = const [],
    this.filteredCategories = const [],
    this.preferredCategories = const [],
    this.selectedCategory,
    this.isLoading = false,
    this.errorMessage,
  });

  CategoryState copyWith({
    List<Map<String, String>>? categories,
    List<Map<String, String>>? filteredCategories,
    List<Map<String, dynamic>>? preferredCategories,
    String? selectedCategory,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      preferredCategories: preferredCategories ?? this.preferredCategories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        categories,
        filteredCategories,
        preferredCategories,
        selectedCategory,
        isLoading,
        errorMessage,
      ];
}
