import 'package:anjalim/student_Section/custom_widgets/dateformating.dart';
import 'package:anjalim/student_Section/custom_widgets/jobcard.dart';
import 'package:anjalim/student_Section/student_blocs/search/search_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen1 extends StatefulWidget {
  const SearchScreen1({super.key});

  @override
  State<SearchScreen1> createState() => _SearchScreen1State();
}

class _SearchScreen1State extends State<SearchScreen1> {
  String? selectJobTitle;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    context.read<SearchBloc>().add(FetchJobTitlesEvent());
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<SearchBloc>().add(FetchMoreJobsEvent());
    }
  }

  void _onJobTitleSelected(String? value) {
    if (value != null && value != "Loading fields...") {
      setState(() => selectJobTitle = value);
      Navigator.pushNamed(
        context,
        "SearchScreen2",
        arguments: {
          'selectJobTitle': selectJobTitle, // Make sure this is not null
        },
      );
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // void _showSuccessSnackBar(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Row(
  //         children: [
  //           const Icon(Icons.check_circle_outline,
  //               color: Colors.white, size: 20),
  //           const SizedBox(width: 8),
  //           Text(message),
  //         ],
  //       ),
  //       backgroundColor: Colors.green.shade600,
  //       duration: const Duration(seconds: 2),
  //       behavior: SnackBarBehavior.floating,
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //     ),
  //   );
  // }

  Future<void> _onRefresh() async {
    context.read<SearchBloc>().add(FetchJobTitlesEvent());
  }

  void _toggleSaveJob(Map<String, dynamic> job) {
    context.read<SearchBloc>().add(ToggleSaveJobEvent(job));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No jobs found',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff004673),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xffEB8125),
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Loading jobs...',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff666666),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final horizontalPadding = isTablet ? 24.0 : 16.0;

    return Scaffold(
      backgroundColor: const Color(0xffF9F2ED),
      body: SafeArea(
        child: BlocConsumer<SearchBloc, SearchState>(
          listener: (context, state) {
            if (state is SearchError) {
              _showErrorSnackBar(state.message);
            }
          },
          builder: (context, state) {
            // Get job titles from state
            List<String> jobTitles = [];
            bool isJobTitlesLoading = false;

            if (state is JobTitlesLoaded) {
              jobTitles = state.jobTitles;
            } else if (state is SearchSuccessWithJobTitles) {
              jobTitles = state.jobTitles;
            } else if (state is JobTitlesLoading) {
              isJobTitlesLoading = true;
            } else if (state is SearchLoadingWithJobTitles) {
              jobTitles = state.jobTitles;
              isJobTitlesLoading = false; // We have titles, just loading jobs
            }

            // Get search results
            List<dynamic> searchResults = [];
            bool hasMore = false;
            bool isLoadingJobs = false;

            if (state is SearchSuccessWithJobTitles) {
              searchResults = state.searchResults;
              hasMore = state.hasMore;
              isLoadingJobs = state.isLoadingMore;
            } else if (state is SearchLoadingWithJobTitles) {
              isLoadingJobs = true;
              searchResults = [];
            } else if (state is JobTitlesLoading) {
              isLoadingJobs = true;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(
                      horizontalPadding, 16, horizontalPadding, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Find Your Gigs',
                            style: TextStyle(
                              fontSize: isTablet ? 28 : 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Discover opportunities that match your skills',
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          color: const Color(0xff666666),
                        ),
                      ),
                    ],
                  ),
                ),

                // Search Section
                Container(
                  padding: EdgeInsets.fromLTRB(
                      horizontalPadding, 20, horizontalPadding, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DropdownSearch<String>(
                      items: (filter, loadProps) async {
                        if (isJobTitlesLoading || jobTitles.isEmpty) {
                          return ["Loading fields..."];
                        }

                        // Apply filter if provided
                        if (filter.isNotEmpty) {
                          return jobTitles
                              .where((title) => title
                                  .toLowerCase()
                                  .contains(filter.toLowerCase()))
                              .toList();
                        }

                        return jobTitles;
                      },
                      selectedItem: selectJobTitle,
                      onChanged: _onJobTitleSelected,
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                          cursorColor: const Color(0xff004673),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xffFFFFFF),
                            hintText: "Search job titles...",
                            hintStyle:
                                const TextStyle(color: Color(0xffE0E0E0)),
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.black),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xffE0E0E0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  const BorderSide(color: Color(0xffE0E0E0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: Color(0xff004673), width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                          ),
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffFFFFFF).withOpacity(0.8),
                          prefixIcon: Icon(Icons.search,
                              color: const Color(0xff313131).withOpacity(0.8),
                              size: 24),
                          suffixIcon: selectJobTitle != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: Colors.red),
                                  onPressed: () =>
                                      setState(() => selectJobTitle = null),
                                )
                              : null,
                          hintText: "Search Your Gigs....",
                          hintStyle: TextStyle(
                            color: const Color(0xff313131).withOpacity(0.8),
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: Color(0xff004673), width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 18),
                        ),
                        baseStyle:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),

                // Jobs List
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: horizontalPadding - 6),
                    child: isLoadingJobs && searchResults.isEmpty
                        ? _buildLoadingState()
                        : searchResults.isEmpty
                            ? _buildEmptyState()
                            : RefreshIndicator(
                                onRefresh: _onRefresh,
                                color: const Color(0xffEB8125),
                                child: ListView.separated(
                                  controller: _scrollController,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 20),
                                  itemCount:
                                      searchResults.length + (hasMore ? 1 : 0),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    if (index >= searchResults.length) {
                                      return Container(
                                        padding: const EdgeInsets.all(24),
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Color(0xffEB8125),
                                                strokeWidth: 2,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Text(
                                              "Loading more jobs...",
                                              style: TextStyle(
                                                color: Color(0xff666666),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    final job = searchResults[index];
                                    final company =
                                        job['company'] as Map<String, dynamic>?;

                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, "GigsDetailScreen",
                                                arguments: {"jobData": job});
                                          },
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: JobCard(
                                            id: job['id'].toString(),
                                            jobType:
                                                job['job_type'] ?? 'Unknown',
                                            position:
                                                job['job_title'] ?? 'No Title',
                                            timeAgo: formatPostedDate(
                                                job['posted_date']),
                                            salary: job['pay_structure'] ??
                                                'Not specified',
                                            salaryType:
                                                job['salary_type'] ?? '',
                                            applied: job['applied'] ?? false,
                                            logo: company?['logo'] ?? '',
                                            company: company?['company_name'] ??
                                                'Unknown Company',
                                            location:
                                                job['job_location'] ?? 'Remote',
                                            employerId:
                                                company?['id']?.toString() ??
                                                    '',
                                            saved: job['saved_job'] ?? false,
                                            isLoading: false,
                                            onSave: () => _toggleSaveJob(job),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
