// ignore_for_file: file_names, non_constant_identifier_names

part of 'BankCardBloc.dart';

@immutable
class BankCardState
{
  final List<BankCardDataModel> bankCards;
  final bool isLoading;
  final String errorMessage;

  const BankCardState({required this.bankCards, required this.isLoading, required this.errorMessage});

  factory BankCardState.initial()
  {
    return const BankCardState(
      bankCards: [],
      isLoading: false,
      errorMessage: ""
    );
  }

  factory BankCardState.loading()
  {
    return const BankCardState(
      bankCards: [],
      isLoading: true,
      errorMessage: ""
    );
  }

  factory BankCardState.success(List<BankCardDataModel> bankCards)
  {
    return BankCardState(
      bankCards: bankCards,
      isLoading: false,
      errorMessage: ""
    );
  }

  factory BankCardState.error(String errorMessage)
  {
    return BankCardState(
      bankCards: const [],
      isLoading: false,
      errorMessage: errorMessage
    );
  }
}
