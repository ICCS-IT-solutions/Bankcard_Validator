// ignore_for_file: file_names, non_constant_identifier_names

part of 'BankCardBloc.dart';

@immutable
/// The `sealed class BankCardEvent {}` is defining a sealed class named `BankCardEvent`. A sealed class
/// is a class that restricts its subclasses to be defined within the same file. This means that all
/// subclasses of `BankCardEvent` must be defined within the same file where `BankCardEvent` is defined.
/// This helps in ensuring that all possible subclasses of `BankCardEvent` are known and handled in a
/// single location, making it easier to manage and reason about the code.
sealed class BankCardEvent {}

/// The RegisterNewBankCard class represents an event for registering a new bank card with the bank.
class RegisterNewBankCard extends BankCardEvent
{
  final BankCardDataModel bankCard;
  RegisterNewBankCard(this.bankCard);
}

/// The GetBankCardsData class is an event that contains a list of BankCardDataModel objects.
class GetBankCardsData extends BankCardEvent
{
  final List<BankCardDataModel> bankCards;
  GetBankCardsData(this.bankCards);
}

/// The class represents an event to update an existing bank card with a new bank card data model.
class UpdateExistingBankCard extends BankCardEvent
{
  final BankCardDataModel bankCard;
  UpdateExistingBankCard(this.bankCard);
}

/// The DeleteBankCard class represents an event to delete a bank card.
class DeleteBankCard extends BankCardEvent
{
  final BankCardDataModel bankCard;
  DeleteBankCard(this.bankCard);
}