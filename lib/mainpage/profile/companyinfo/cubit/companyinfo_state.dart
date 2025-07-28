part of 'companyinfo_cubit.dart';

@immutable
sealed class CompanyinfoState {}

final class CompanyinfoInitial extends CompanyinfoState {}
final class CompanyinfoIoaded extends CompanyinfoState {
  final String countryCode;
  CompanyinfoIoaded(this.countryCode);
}
