  import 'package:bloc/bloc.dart';
  import 'package:meta/meta.dart';
  import 'package:http/http.dart' as http;

  import '../../../../datapage/datapage.dart';
import '../model/model.dart';

  part 'homepagedetail_state.dart';

  class HomepagedetailCubit extends Cubit<HomepagedetailState> {
    HomepagedetailCubit() : super(HomepagedetailInitial());

    final String baseurl = ApiConstantsemployer.baseUrl;
    final headers =  ApiConstantsemployer.headers;
    Future<void> fetchEmployeeDetail({required int id}) async {
      emit(HomepagedetailLoding());


      try {
        final token = await ApiConstantsemployer.getTokenOnly(); // ✅ get actual token
        // final tokens = await ApiConstants.getTokenOnly2(); // ✅ get actual token

        final response = await http.get(
          Uri.parse('https://server.studentsgigs.com/api/employer/employee-data/?id=$id'),
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          print(response.statusCode);
          print("bed");
          final data = empleedetailpageFromJson(response.body);
          print("bed ${data.jobTitle}");

          emit(HomepagedetailLoaded(data));
        } else {
          print("its err");

          emit(Homepagedetailerror('Failed: ${response.statusCode}'));
        }
      } catch (e) {
        print("hey its error $e");

        emit(Homepagedetailerror(e.toString()));
      }
    }

  }
