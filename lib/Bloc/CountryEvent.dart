// ignore_for_file: file_names, non_constant_identifier_names

part of 'CountryBloc.dart';

@immutable
/// The `sealed class CountryEvent {}` is defining a sealed class named `CountryEvent`. A sealed class
/// is a class that restricts its subclasses to be defined within the same file. This means that any
/// subclasses of `CountryEvent` must be defined within the same Dart file where `CountryEvent` is
/// defined. This helps in organizing and encapsulating related classes together.
sealed class CountryEvent {}

/// The RegisterNewCountry class is an event that represents the registration of a new country with its
/// corresponding data model.
class RegisterNewCountry extends CountryEvent
{
  final CountryDataModel country;
  RegisterNewCountry(this.country);
}

/// The GetCountriesData class is an event that contains a list of CountryDataModel objects.
class GetCountriesData extends CountryEvent
{
  final List<CountryDataModel> countries;
  GetCountriesData(this.countries);
}

/// The class UpdateExistingCountry is an event that represents updating an existing country with new
/// data.
class UpdateExistingCountry extends CountryEvent
{
  final CountryDataModel country;
  UpdateExistingCountry(this.country);
}

/// The DeleteCountry class represents an event to delete a country from a data model.
class DeleteCountry extends CountryEvent
{
  final CountryDataModel country;
  DeleteCountry(this.country);
}

