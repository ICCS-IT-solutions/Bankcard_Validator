// ignore_for_file: file_names, non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../Helpers/BaseDbHelper.dart';
import '../Models/BankCardDataModel.dart';

part 'BankCardEvent.dart';
part 'BankCardState.dart';

class BankCardBloc extends Bloc<BankCardEvent, BankCardState> 
{
  final String tableName;
  final String dbName;
  final BaseDbHelper _dbHelper;
  //Use this function to execute an update after each operation:
  Future<BankCardState> _ExecutePostOpUpdate() async
  {
    final updatedBankCardData = await _dbHelper.ReadEntries(dbName, tableName, null, null);
    final updatedBankCards =  updatedBankCardData?.map((item) => BankCardDataModel.fromDictionary(item)).toList() ?? [];
    //Emit a new state with the updated data
    return BankCardState(bankCards: updatedBankCards, isLoading: false, errorMessage: "");
  }

  BankCardBloc({required this.dbName, required this.tableName, required bool useMySql}) : _dbHelper = CreateDbHelper(useMySql),  super(BankCardState.initial()) 
  {
    on<RegisterNewBankCard>((event, emit) async
    { 
      await _dbHelper.CreateEntry(dbName,tableName,event.bankCard.toDictionary());
      final updatedState = await _ExecutePostOpUpdate();
      emit (updatedState);
    });

    on<DeleteBankCard>((event, emit) async
    {
      await _dbHelper.DeleteEntry(dbName,tableName,"cardNumber = ?",[event.bankCard.CardNumber]);
      final updatedState = await _ExecutePostOpUpdate();
      emit (updatedState);
    });

    on<UpdateExistingBankCard>((event, emit) async
    {
      await _dbHelper.UpdateEntry(dbName,tableName,event.bankCard.toDictionary(),"cardNumber = ?",[event.bankCard.CardNumber]);
      final updatedState = await _ExecutePostOpUpdate();
      emit (updatedState);
    });

    on<GetBankCardsData>((event, emit) async
    {
      final currentBankCardData = await _dbHelper.ReadEntries(dbName, tableName, null, null);
      //Emit a new state with the current data
      emit(BankCardState(bankCards: currentBankCardData?.map((item) => BankCardDataModel.fromDictionary(item)).toList() ?? [], isLoading: false, errorMessage: ""));
    });
  }
  Stream<BankCardState> mapEventToState(BankCardEvent event) async*
  {
    try
    {
      yield BankCardState.initial();
      if(event is GetBankCardsData)
      {
        await _ExecutePostOpUpdate();
        final updatedState = await _dbHelper.ReadEntries(dbName, tableName,null, null);
        final bankCards = updatedState?.map((item) => BankCardDataModel.fromDictionary(item)).toList() ?? [];
        yield BankCardState.success(bankCards);
      }
    }
    catch(ex)
    {
      yield BankCardState.error("Something went wrong while retrieving bank card data. Please try again later.");
    }
  }
}
