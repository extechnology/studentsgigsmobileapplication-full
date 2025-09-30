import 'package:anjalim/student_Section/custom_widgets/dateformating.dart';
import 'package:anjalim/student_Section/custom_widgets/jobcard.dart';
import 'package:anjalim/student_Section/services/singlesearch.dart';
import 'package:anjalim/student_Section/student_blocs/search/search_bloc.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen2 extends StatefulWidget {
  const SearchScreen2({super.key});

  @override
  State<SearchScreen2> createState() => _SearchScreen2State();
}

class _SearchScreen2State extends State<SearchScreen2>
    with TickerProviderStateMixin {
  late TextEditingController location = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final ScrollController _scrollController = ScrollController();

  String? selectedSalaryType;
  String? selectedLocation;
  String? selectJobTitle;
  bool isFilterExpanded = true;

  @override
  void initState() {
    super.initState();
    // Initialize the TextEditingController properly
    location = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _setupScrollListener();

    // Initialize BLoC
    // context.read<SearchBloc>().add(FetchJobTitlesEvent());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['selectJobTitle'] != null) {
        setState(() {
          selectJobTitle = args['selectJobTitle'];
        });
        // Perform search immediately with the passed job title
        context.read<SearchBloc>().add(SearchJobsEvent(
              selectJobTitle: args['selectJobTitle'],
              selectedLocation: null,
              selectedSalaryType: null,
              resetPagination: true,
            ));
      }
      _animationController.forward();
    });
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<SearchBloc>().add(FetchMoreJobsEvent());
      }
    });
  }

  void _performSearch({bool resetPagination = true}) {
    if (selectJobTitle == null || selectJobTitle!.isEmpty) {
      _showErrorSnackBar('Please select a job title first');
      return;
    }

    context.read<SearchBloc>().add(SearchJobsEvent(
          selectJobTitle: selectJobTitle,
          selectedLocation: selectedLocation,
          selectedSalaryType: selectedSalaryType,
          resetPagination: resetPagination,
        ));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      selectJobTitle = null;
      selectedLocation = null;
      selectedSalaryType = null;
      location.clear();
    });
    context.read<SearchBloc>().add(ClearFiltersEvent());
  }

  void _toggleSaveJob(Map<String, dynamic> job) {
    context.read<SearchBloc>().add(ToggleSaveJobEvent(job));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    location.dispose();
    super.dispose();
  }

  Widget _buildFilterSection(SearchState state) {
    final isJobTitlesLoading = state is JobTitlesLoading;
    List<String> jobTitles = [];
    if (state is JobTitlesLoaded) {
      jobTitles = state.jobTitles;
    } else if (state is SearchSuccessWithJobTitles) {
      jobTitles = state.jobTitles;
    } else if (state is SearchSuccess) {
      jobTitles = []; // Fallback
    }

    final isLoading = state is SearchLoading;
    final salaryTypes = [
      'Hourly',
      "All-Day Gigs",
      'Weekend Gigs',
      "Vacation Gigs",
      'Project-based'
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xffFFFFFF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Filter Header
          InkWell(
            onTap: () {
              setState(() {
                isFilterExpanded = !isFilterExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF004673),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Search Filters",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        if (_getActiveFiltersCount() > 0)
                          Text(
                            "${_getActiveFiltersCount()} filter${_getActiveFiltersCount() > 1 ? 's' : ''} active",
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: Color(0xFF004673),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_getActiveFiltersCount() > 0)
                    TextButton(
                      onPressed: _clearAllFilters,
                      child: Text(
                        "Clear All",
                        style: TextStyle(
                          color: Colors.red.shade600,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  Icon(
                    isFilterExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF004673),
                  ),
                ],
              ),
            ),
          ),

          // Filter Content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isFilterExpanded ? null : 0,
            child: isFilterExpanded
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Job Title Dropdown
                        _buildDropdownField(
                          label: "Job Title",
                          icon: Icons.work_outline,
                          child: DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: _getSearchInputDecoration(
                                    "Search job titles..."),
                              ),
                              menuProps: MenuProps(
                                borderRadius: BorderRadius.circular(12),
                                elevation: 8,
                              ),
                              loadingBuilder: (context, searchEntry) =>
                                  const Center(
                                child: SizedBox(
                                  height: 100,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF004673),
                                  ),
                                ),
                              ),
                              emptyBuilder: (context, searchEntry) => SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text(
                                    isJobTitlesLoading
                                        ? "Loading job titles..."
                                        : "No job titles found",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            items: (filter, infiniteScrollProps) async {
                              if (isJobTitlesLoading || jobTitles.isEmpty) {
                                return <String>[];
                              }

                              // If there's a filter, apply it
                              if (filter != null && filter.isNotEmpty) {
                                return jobTitles
                                    .where((title) => title
                                        .toLowerCase()
                                        .contains(filter.toLowerCase()))
                                    .toList();
                              }

                              return jobTitles;
                            },
                            selectedItem: selectJobTitle,
                            onChanged: (String? val) async {
                              setState(() {
                                selectJobTitle = val;
                              });

                              if (val != null && val.isNotEmpty) {
                                await Future.delayed(
                                    const Duration(milliseconds: 100));
                                _performSearch(resetPagination: true);
                              }
                            },
                            decoratorProps: DropDownDecoratorProps(
                              decoration: _getInputDecoration(
                                isJobTitlesLoading
                                    ? "Loading job titles..."
                                    : "Select job title",
                                Icons.work_outline,
                              ),
                            ),
                            enabled: !isJobTitlesLoading,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Location Field
                        _buildDropdownField(
                          label: "Location",
                          icon: Icons.location_on_outlined,
                          child: Autocomplete<String>(
                            optionsBuilder: (textEditingValue) async {
                              if (textEditingValue.text.length > 2) {
                                try {
                                  return await SearchService()
                                      .fetchCity(textEditingValue.text);
                                } catch (e) {
                                  return [];
                                }
                              }
                              return [];
                            },
                            onSelected: (selected) {
                              setState(() {
                                selectedLocation = selected;
                                location.text = selected;
                              });
                              if (selectJobTitle != null &&
                                  selectJobTitle!.isNotEmpty) {
                                _performSearch(resetPagination: true);
                              }
                            },
                            fieldViewBuilder: (context, textEditingController,
                                focusNode, onFieldSubmitted) {
                              // Don't reassign the controller, use the existing one
                              // Copy the text from the autocomplete controller to our controller
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (textEditingController.text !=
                                    location.text) {
                                  location.text = textEditingController.text;
                                }
                              });

                              return TextField(
                                controller: location, // Use our own controller
                                focusNode: focusNode,
                                onChanged: (value) {
                                  // Keep the autocomplete controller in sync
                                  textEditingController.text = value;
                                },
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                ),
                                decoration: _getInputDecoration(
                                  "Enter preferred work location",
                                  Icons.location_on_outlined,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Salary Type Dropdown
                        _buildDropdownField(
                          label: "Job Type",
                          icon: Icons.payments_outlined,
                          child: DropdownSearch<String>(
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                decoration: _getSearchInputDecoration(
                                    "Search job types..."),
                              ),
                              menuProps: MenuProps(
                                borderRadius: BorderRadius.circular(12),
                                elevation: 8,
                              ),
                            ),
                            items: (filter, loadProps) async {
                              if (filter != null && filter.isNotEmpty) {
                                return salaryTypes
                                    .where((type) => type
                                        .toLowerCase()
                                        .contains(filter.toLowerCase()))
                                    .toList();
                              }
                              return salaryTypes;
                            },
                            selectedItem: selectedSalaryType,
                            onChanged: (value) {
                              setState(() => selectedSalaryType = value);
                              if (selectJobTitle != null &&
                                  selectJobTitle!.isNotEmpty) {
                                _performSearch(resetPagination: true);
                              }
                            },
                            decoratorProps: DropDownDecoratorProps(
                              decoration: _getInputDecoration(
                                "Select job type",
                                Icons.payments_outlined,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Search Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: (selectJobTitle != null &&
                                    selectJobTitle!.isNotEmpty)
                                ? () => _performSearch(resetPagination: true)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF004673),
                              disabledBackgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Search Jobs",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF004673)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _getInputDecoration(String hintText, IconData icon) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: Colors.grey.shade500,
        fontFamily: "Poppins",
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: const Color(0xFF004673), size: 20),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF004673), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  InputDecoration _getSearchInputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.grey.shade500, fontFamily: "Poppins"),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  int _getActiveFiltersCount() {
    int count = 0;
    if (selectJobTitle != null && selectJobTitle!.isNotEmpty) count++;
    if (selectedLocation != null && selectedLocation!.isNotEmpty) count++;
    if (selectedSalaryType != null) count++;
    return count;
  }

  Widget _buildLoadingState() {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF004673)),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              "Searching for perfect jobs...",
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 48,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No jobs found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                fontFamily: "Poppins",
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search filters\nor explore different job titles',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
                fontFamily: "Poppins",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsSection(SearchSuccess state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results Header
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF004673).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: Color(0xFF004673),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${state.searchResults.length} jobs found',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                        fontFamily: "Poppins",
                      ),
                    ),
                    if (state.selectJobTitle != null)
                      Text(
                        'for "${state.selectJobTitle}"',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontFamily: "Poppins",
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Jobs List
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.searchResults.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == state.searchResults.length) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF004673)),
                  ),
                ),
              );
            }

            final job = state.searchResults[index];
            final company = job['company'] as Map<String, dynamic>?;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "GigsDetailScreen",
                    arguments: {"jobData": job},
                  );
                },
                child: JobCard(
                  id: job['id'].toString(),
                  jobType: job['job_type'] ?? 'Unknown',
                  position: job['job_title'] ?? 'No Title',
                  timeAgo: formatPostedDate(job['posted_date']),
                  salary: job['pay_structure'] ?? 'Not specified',
                  salaryType: job['salary_type'] ?? '',
                  applied: job['applied'] ?? false,
                  logo: company?['logo'] ?? '',
                  company: company?['company_name'] ?? 'Unknown Company',
                  location: job['job_location'] ?? 'Remote',
                  employerId: company?['id']?.toString() ?? '',
                  saved: job['saved_job'] ?? false,
                  isLoading: false,
                  onSave: () => _toggleSaveJob(job),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F2ED),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header (keep as is)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xffF9F2ED),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      onPressed: () => Navigator.pop(context),
                      color: const Color(0xFF004673),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Find Your Perfect Job",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: BlocConsumer<SearchBloc, SearchState>(
                  listener: (context, state) {
                    if (state is SearchError) {
                      _showErrorSnackBar(state.message);
                    }
                  },
                  builder: (context, state) {
                    // Check if we have results
                    final hasResults = state is SearchSuccess &&
                        state.searchResults.isNotEmpty;
                    final isEmpty = state is SearchSuccess &&
                        state.searchResults.isEmpty &&
                        selectJobTitle != null &&
                        selectJobTitle!.isNotEmpty;
                    final isInitialLoading = state is SearchLoading;

                    return SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Filter Section
                          _buildFilterSection(state),

                          // Results Section - FIXED
                          if (isInitialLoading && !hasResults)
                            _buildLoadingState()
                          else if (isEmpty)
                            _buildEmptyState()
                          else if (hasResults)
                            _buildResultsSection(state as SearchSuccess),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
