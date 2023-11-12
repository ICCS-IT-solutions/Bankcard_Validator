// ignore_for_file: file_names, non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:main/Helpers/BaseDbHelper.dart';
import 'package:meta/meta.dart';

import '../Models/CountryDataModel.dart';

part 'CountryEvent.dart';
part 'CountryState.dart';

class CountryBloc extends Bloc<CountryEvent, CountryState> 
{
  //When this class is instantiated, the dbName prop will be required in order to use it, that means it can be passed from the MainAppBloc class
  final String dbName;
  final String tableName;
  final BaseDbHelper _dbHelper;
  
  Future<CountryState> _ExecutePostOpUpdate() async
  {
    final updatedCountryData = await _dbHelper.ReadEntries(dbName, tableName, null, null);
    final updatedCountries =  updatedCountryData?.map((item) => CountryDataModel.fromDictionary(item)).toList() ?? [];
    //Emit a new state with the updated data
    return CountryState(countries: updatedCountries, isLoading: false, errorMessage: "");
  }

  CountryBloc({required this.dbName, required this.tableName, required bool useMySql}) : _dbHelper = CreateDbHelper(useMySql), super(CountryState.initial()) 
  {
    on<RegisterNewCountry>((event, emit) async
    {
      //Use the CreateEntry method from the BaseDbHelper class to create a new entry in the database.
      await _dbHelper.CreateEntry(dbName,tableName,event.country.toDictionary());
      final updatedState = await _ExecutePostOpUpdate();
      emit (updatedState);
    });
    on<UpdateExistingCountry>((event, emit) async
    {
      await _dbHelper.UpdateEntry(dbName,tableName,event.country.toDictionary(),"countryName = ?",[event.country.CountryName]);
      final updatedState = await _ExecutePostOpUpdate();
      emit (updatedState);
    });
    on<DeleteCountry>((event, emit) async
    {
      await _dbHelper.DeleteEntry(dbName,tableName,"countryName = ?",[event.country.CountryName]);
      final updatedState = await _ExecutePostOpUpdate();
      emit (updatedState);
    });
    on<GetCountriesData>((event, emit) async
    {
      final currentCountryData = await _dbHelper.ReadEntries(dbName, tableName, null, null);
      //Emit a new state with the current data
      emit(CountryState(countries: currentCountryData?.map((item) => CountryDataModel.fromDictionary(item)).toList() ?? [], isLoading: false, errorMessage: ""));
    });
  }
  Stream<CountryState> mapEventToState(CountryEvent event) async*
  {
    try
    {
      yield CountryState.initial();
      if(event is GetCountriesData)
      {
        await _ExecutePostOpUpdate();
        final updatedState = await _dbHelper.ReadEntries(dbName, tableName,null, null);
        final countries = updatedState?.map((item) => CountryDataModel.fromDictionary(item)).toList() ?? [];
        yield CountryState.success(countries);
      }
    }
    catch(ex)
    {
      yield CountryState.error("Something went wrong while retrieving country data. Please try again later.");
    }
  }
}
