// ignore_for_file: non_constant_identifier_names, file_names

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../Bloc/BankCardBloc.dart";
import "../Models/BankCardDataModel.dart";
import "../Models/UserDataModel.dart";
class BankCardScreen extends StatefulWidget
{
  final UserDataModel? currentUser;
  const BankCardScreen({required this.currentUser, super.key});

  @override
  State<BankCardScreen> createState() => _BankCardScreenState();
}

class _BankCardScreenState extends State<BankCardScreen> 
{
  TextEditingController CardNumberController = TextEditingController();
  TextEditingController CardHolderNameController = TextEditingController();
  TextEditingController CountryOfOriginController = TextEditingController();
  TextEditingController ExpirationDateController = TextEditingController();
  TextEditingController CvvController = TextEditingController();

  final _formKey=GlobalKey<FormState>();
  Widget BankCardRegistrationForm(BuildContext context, BankCardBloc bankCardBloc)
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: CardNumberController,
              decoration: const InputDecoration(
                label:Text("Card number")
              ),
              validator: (value) => (value == null || value.isEmpty) ? "Please enter a card number" : null,
            ),
            TextFormField(
              controller: CardHolderNameController,
              decoration: const InputDecoration(
                label:Text("Card holder name")
              ),
              validator: (value) => (value == null || value.isEmpty) ? "Please enter a card holder name" : null,
            ),
            TextFormField(
              controller: CountryOfOriginController,
              decoration: const InputDecoration(
                label:Text("Country of origin")
              ),
              validator: (value) => (value == null || value.isEmpty) ? "Please enter a country of origin" : null,
            ),
            TextFormField(
              controller: ExpirationDateController,
              decoration: const InputDecoration(
                label:Text("Expiration date")
              ),
              validator: (value) => (value == null || value.isEmpty) ? "Please enter an expiration date" : null,
            ),
            TextFormField(
              controller: CvvController,
              decoration: const InputDecoration(
                label:Text("CVV")
              ),
              validator: (value) => (value == null || value.isEmpty) ? "Please enter the CVV" : null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: HandleSubmit,
                  child: const Text("Submit"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: HandleReset,
                  child: const Text("Cancel"),
                ),
              ]
            )
          ],
        ),
      ),
    );
  }
 
  Widget LandscapeView(BuildContext context, BankCardBloc bankCardBloc)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register new bank card"),
      ),
      body: Center(child: 
      SingleChildScrollView(
        child: Column(
          children: [
            BankCardRegistrationForm(context, bankCardBloc),
          ],
        ),
      )),
    );
  }
  Widget PortraitView(BuildContext context, BankCardBloc bankCardBloc)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register new bank card"),
      ),
      body: Center(child: 
      SingleChildScrollView(
        child: Column(
          children: [
            BankCardRegistrationForm(context, bankCardBloc),
          ],
        ),
      )),
    );
  }
  @override
  Widget build(BuildContext context) 
  {
    {
      if (MediaQuery.of(context).size.width > 500)
      {
        return LandscapeView(context, BlocProvider.of<BankCardBloc>(context));
      }
      else
      {
        return PortraitView(context, BlocProvider.of<BankCardBloc>(context));
      }
    }
  }
  //Handlers
  void HandleReset()
  {
    CardNumberController.clear();
    CardHolderNameController.clear();
    CountryOfOriginController.clear();
    ExpirationDateController.clear();
    CvvController.clear();
  }
  void HandleSubmit()
  {
    bool IsValid = _formKey.currentState!.validate();
    if(IsValid)
    {
      //Build a new bank card data model that can be stored in the database.
      BankCardDataModel newBankCard = BankCardDataModel(
        CardNumber: CardNumberController.text,
        CardType:GetCardType(CardNumberController.text),
        CardHolderName: CardHolderNameController.text,
        CountryOfOrigin: CountryOfOriginController.text,
        ExpirationDate: ExpirationDateController.text,
        Cvv: CvvController.text,
        IsFromBannedCountry: 0,
      );
      BlocProvider.of<BankCardBloc>(context).add(RegisterNewBankCard(newBankCard));
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all the fields"),
        )
      );
    }
  }
}