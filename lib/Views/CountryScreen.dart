// ignore_for_file: file_names, non_constant_identifier_names
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../Models/UserDataModel.dart";
import "../Models/CountryDataModel.dart";
import "../Bloc/CountryBloc.dart";

class CountryScreen extends StatefulWidget
{
  final UserDataModel? currentUser;
  const CountryScreen({required this.currentUser, super.key});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> 
{
  final _formKey=GlobalKey<FormState>();
  TextEditingController CountryNameController = TextEditingController();
  TextEditingController CountryCodeController = TextEditingController();
  TextEditingController BanReasonController = TextEditingController();
  UserDataModel? currentUser;
  void HandleReset()
  {
    CountryNameController.clear();
    CountryCodeController.clear();
    BanReasonController.clear();
  }
  HandleSubmit()
  {
    if(_formKey.currentState!.validate())
    {
      CountryDataModel newCountry = CountryDataModel(
        CountryCode: CountryCodeController.text,
        CountryName: CountryNameController.text,
        IsBanned: 0,
        BanReason: BanReasonController.text
      );
      BlocProvider.of<CountryBloc>(context).add(RegisterNewCountry(newCountry));
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

  Widget CountryRegistrationForm(BuildContext context, CountryBloc countryBloc)
  {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: CountryNameController,
              decoration: const InputDecoration(
                label:Text("Country name")
              ),
              validator: (value) => (value == null || value.isEmpty) ? "Please enter a country name" : null,            
            ),
            TextFormField(
              controller: CountryCodeController,
              decoration: const InputDecoration(
                label:Text("Country code")
              ),
              validator: (value) => (value == null || value.isEmpty) ? "Please enter a country code" : null,            
            ),
            TextFormField(
              controller: BanReasonController,
              decoration: const InputDecoration(
                label:Text("Ban reason")
              ),
              validator: (value) => (value == null || value.isEmpty) ? "Please enter a ban reason" : null,            
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
          ]
        )
      )
    );
  }

  Widget LandscapeView(BuildContext context, CountryBloc countryBloc)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register new country"),
      ),
      body: CountryRegistrationForm(context, countryBloc),
    );
  }

  Widget PortraitView(BuildContext context, CountryBloc countryBloc)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register new country"),
      ),
      body: CountryRegistrationForm(context, countryBloc),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    BlocProvider.of<CountryBloc>(context).add(GetCountriesData(const []));
    {
      if (MediaQuery.of(context).size.width > 500)
      {
        return LandscapeView(context, BlocProvider.of<CountryBloc>(context));
      }
      else
      {
        return PortraitView(context, BlocProvider.of<CountryBloc>(context));
      }
    }
  }
}