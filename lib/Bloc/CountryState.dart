// ignore_for_file: file_names, non_constant_identifier_names

part of 'CountryBloc.dart';

@immutable
class CountryState 
{
  final List<CountryDataModel> countries;
  final bool isLoading;
  final String errorMessage;

  const CountryState({required this.countries, required this.isLoading, required this.errorMessage});

  //Initial state:
  factory CountryState.initial()
  {
    return const CountryState(
      countries: [],
      isLoading: false,
      errorMessage: ""
    );
  }

  //Loading state:
  factory CountryState.loading()
  {
    return const CountryState(
      countries: [],
      isLoading: true,
      errorMessage: ""
    );
  }

  //Success state:
  factory CountryState.success(List<CountryDataModel> countries)
  {
    return CountryState(
      countries: countries,
      isLoading: false,
      errorMessage: ""
    );
  }

  //Error state:
  factory CountryState.error(String errorMessage)
  {
    return CountryState(
      countries: const [],
      isLoading: false,
      errorMessage: errorMessage
    );
  }
}
