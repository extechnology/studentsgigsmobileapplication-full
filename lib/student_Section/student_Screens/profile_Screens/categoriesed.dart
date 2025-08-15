import 'package:anjalim/student_Section/custom_widgets/buildtext.dart';
import 'package:anjalim/student_Section/services/profile_update_searvices/preferred_Categories_repository.dart';
import 'package:anjalim/student_Section/student_blocs/preferred_categories/preferred_category_bloc.dart';
import 'package:anjalim/student_Section/student_blocs/preferred_categories/preferred_category_event.dart';
import 'package:anjalim/student_Section/student_blocs/preferred_categories/preferred_category_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryDropdownFormField extends StatelessWidget {
  final TextEditingController searchController = TextEditingController();

  CategoryDropdownFormField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryBloc(CategoryRepository())..add(LoadCategories()),
      child: Scaffold(
        backgroundColor: Color(0xffF9F2ED),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: Color(0xffF9F2ED),
          title: Text(
            "Preferred Categories",
            style: TextStyle(
              fontFamily: "Poppins",
              color: Color(0xff3F414E),
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        body: BlocConsumer<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            if (state.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: state.selectedCategory,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    hint: Text('Select a category'),
                    items: state.filteredCategories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category['value'],
                        child: Text(category['label']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      context.read<CategoryBloc>().add(SelectCategory(value!));
                    },
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: Color(0xffFF9500),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () {
                          searchController.clear();
                        },
                        child: Text('Cancel',
                            style: TextStyle(
                                fontFamily: "Poppins", color: Colors.white)),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: Color(0xff004673),
                          padding: EdgeInsets.symmetric(horizontal: 20),
                        ),
                        onPressed: () {
                          context.read<CategoryBloc>().add(SaveCategory());
                        },
                        child: Text('Save',
                            style: TextStyle(
                                color: Colors.white, fontFamily: "Poppins")),
                      ),
                    ],
                  ),
                  Divider(color: Colors.black12),
                  buildSectionLabel("Preferred Categories", 18),
                  Expanded(
                    child: state.preferredCategories.isEmpty
                        ? Center(
                            child: Text("No preferred categories added yet"))
                        : ListView.builder(
                            itemCount: state.preferredCategories.length,
                            itemBuilder: (context, index) {
                              final category = state.preferredCategories[index];
                              return Card(
                                color: Colors.white,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  dense: true,
                                  title: Text(
                                    category['preferred_job_category'],
                                    style: TextStyle(fontFamily: "Poppins"),
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.cancel, color: Colors.red),
                                    onPressed: () {
                                      context.read<CategoryBloc>().add(
                                          DeleteCategoryEvent(category['id']));
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
