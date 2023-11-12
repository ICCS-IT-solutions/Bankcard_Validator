// ignore_for_file: file_names, non_constant_identifier_names
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../Bloc/BankCardBloc.dart";
import "../Bloc/UserBloc.dart";
import "package:main/Models/BankCardDataModel.dart";
import "package:main/Models/CountryDataModel.dart";

import "../Bloc/CountryBloc.dart";
import "../Models/UserDataModel.dart";
import "BankCardScreen.dart";
import "ConfigScreen.dart";
import "CountryScreen.dart";

class MainScreen extends StatefulWidget
{
  final UserDataModel? currentUser;
  const MainScreen({this.currentUser, super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> 
{
  //Handlers
  void HandleLogoff()
  {
    BlocProvider.of<UserBloc>(context).add(LogoffUser());
  }
  //Widget builders and the screen widget:
  Widget BuildCountryList(BuildContext context, CountryBloc countryBloc)
  {
    countryBloc.add(GetCountriesData(const []));
    return BlocBuilder<CountryBloc,CountryState>(
    bloc: countryBloc,
    builder: (context, state)
      {
        if(state.isLoading)
        {
          return const Center(child: CircularProgressIndicator());
        }
        else if(state.errorMessage.isNotEmpty) 
        {
          return Center(child: Text(state.errorMessage));
        }
        else
        {
          return Column(children: state.countries.map((country) 
          {
            return BuildCountryListTile(country);
          }).toList());
        }
      }
    );
  }

  Widget BuildBankCardList(BuildContext context, BankCardBloc bankCardBloc)
  {
    bankCardBloc.add(GetBankCardsData(const []));
    return BlocBuilder<BankCardBloc,BankCardState>(
      bloc: bankCardBloc,
      builder: (context, state) 
      {
        if(state.isLoading)
        {
          return const Center(child: CircularProgressIndicator());
        }
        else if(state.errorMessage.isNotEmpty)
        {
          return Center(child: Text(state.errorMessage));
        }
        else
        {
          return Column(children: state.bankCards.map((bankCard)
          {
            return BuildBankCardListTile(bankCard);
          }).toList());
        }
      },
    );
  }

  Widget BuildCountryListTile(CountryDataModel country) 
  {
    return SizedBox(
      height: 120,
      width:  MediaQuery.of(context).size.width > 500 
        ? ((MediaQuery.of(context).size.width - 20)/2)
        : MediaQuery.of(context).size.width - 20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      tileColor: Theme.of(context).colorScheme.secondary,
          title: Text(country.CountryName),
          subtitle: Column(
            children: [
              Row(
                children: [
                  Text("Country code: ${country.CountryCode}"),
              ]),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Banned: "), Text(country.IsBanned == 1 ? "Yes" : "No")
                ]
              ),
              const SizedBox(height: 10),
              Row(
                children:[
                  Text("Reason for ban: ${country.BanReason}")
              ])
            ],
          )
        ),
      ),
    );
  }

  Widget BuildBankCardListTile(BankCardDataModel bankCard)
  {
    return SizedBox(
      height: 180,
      width:  MediaQuery.of(context).size.width > 500 
        ? ((MediaQuery.of(context).size.width - 20)/2)
        : MediaQuery.of(context).size.width - 20,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        tileColor: Theme.of(context).colorScheme.secondary,
          title: Text("Card number: ${bankCard.CardNumber}"),
          subtitle: Column(
            children: [
              Row(children: [
                Text("Cardholder name: ${bankCard.CardHolderName}"),
              ]),
              const SizedBox(height: 10),
              Row(
                children: [
                const Text("Card type: "), Text(MapCardTypeToString(bankCard.CardType!)), 
                ]
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Country code: "), Text(bankCard.CountryOfOrigin),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                 const Text("Valid until: "), Text(bankCard.ExpirationDate),
                ]
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("From a banned country: "), Text( bankCard.IsFromBannedCountry == 1 ? "Yes" : "No"),
                ]
              )
            ],
          )
        ),
      ),
    );
  }

  Widget LandscapeView(BuildContext context, BankCardBloc bankCardBloc, CountryBloc countryBloc)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main"),
        actions: [
          TextButton.icon(style: ButtonStyle (foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary)), onPressed: (){
            setState(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CountryScreen()
                )
              );
            });
          }, icon: const Icon(Icons.check_box_outlined), label: const Text("Register country")),
          TextButton.icon(style: ButtonStyle (foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary)),onPressed: (){
            setState(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BankCardScreen()
                )
              );
            });            
          }, icon: const Icon(Icons.add_box_outlined), label: const Text("Register bank card")),
          TextButton.icon(style: ButtonStyle (foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary)),onPressed: (){
            setState(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ConfigScreen()
                )
              );
            });
          }, icon: const Icon(Icons.settings_applications_outlined), label: const Text("Config")),
          TextButton.icon(style: ButtonStyle (foregroundColor: MaterialStateProperty.all(Theme.of(context).colorScheme.onPrimary)),onPressed: HandleLogoff, icon: const Icon(Icons.logout_outlined), label: const Text("Log off")),
        ]
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    const Text("Registered cards: "),
                    BuildBankCardList(context, bankCardBloc),
                  ]
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    const Text("Registered countries: "),
                    BuildCountryList(context, countryBloc),
                  ]
                )
              ]
            )
          ]
        ),
      )
    );
  }

  Widget PortraitView(BuildContext context,  BankCardBloc bankCardBloc, CountryBloc countryBloc)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main"),
        actions: [
          IconButton(color: Theme.of(context).colorScheme.onPrimary, onPressed: (){
            setState(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CountryScreen()
                )
              );
            });
          }, icon: const Icon(Icons.check_box_outlined)),
          IconButton(color: Theme.of(context).colorScheme.onPrimary, onPressed: (){
            setState(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BankCardScreen()
                )
              );
            });
          }, icon: const Icon(Icons.add_box_outlined)),
          IconButton(color: Theme.of(context).colorScheme.onPrimary, onPressed: (){
            setState(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ConfigScreen()
                )
              );
            });            
          }, icon: const Icon(Icons.settings_applications_outlined)),
          IconButton(color: Theme.of(context).colorScheme.onPrimary, onPressed: HandleLogoff, icon: const Icon(Icons.logout_outlined)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Registered cards: "),
            Row(
              children: [
                BuildBankCardList(context,bankCardBloc),
              ]
            ),
            const SizedBox(height: 20),
            const Text("Registered countries: "),
            Row(
              children: [
                BuildCountryList(context, countryBloc),
              ]
            ),
          ],
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context)
  {
    if (MediaQuery.of(context).size.width > 500)
    {
      return LandscapeView(context, BlocProvider.of<BankCardBloc>(context), BlocProvider.of<CountryBloc>(context));
    }
    else
    {
      return PortraitView(context, BlocProvider.of<BankCardBloc>(context), BlocProvider.of<CountryBloc>(context));
    }
  }
}