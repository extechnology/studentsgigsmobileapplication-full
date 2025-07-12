import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/seach_bloc.dart';
import 'bloc/seach_event.dart';
import 'bloc/seach_state.dart';

class SearchBlocUI extends StatelessWidget {
  const SearchBlocUI({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.045;
    double iconSize = screenWidth * 0.06;

    return BlocProvider(
  create: (context) => SearchBloc(),
  child: Scaffold(
      appBar: AppBar(
        title: const Text("Job title, keywords or company"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.keyboard_arrow_left, size: iconSize, color: Colors.grey),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            Icon(Icons.search, size: iconSize, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                initialValue: state.searchText,
                                onChanged: (value) {
                                  context.read<SearchBloc>().add(SearchTextChanged(value));
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                style: TextStyle(fontSize: fontSize),
                              ),
                            ),
                            if (state.searchText.isNotEmpty)
                              IconButton(
                                icon: Icon(Icons.close, size: iconSize, color: Colors.grey),
                                onPressed: () {
                                  context.read<SearchBloc>().add(ClearSearch());
                                },
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                return Text("Current Search Text: ${state.searchText}");
              },
            ),
          ],
        ),
      ),
    ),
);
  }
}
