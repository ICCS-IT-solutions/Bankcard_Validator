// ignore_for_file: file_names, non_constant_identifier_names

import "package:flutter/material.dart";
import "../Bloc/UserBloc.dart";
import "../Models/UserDataModel.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../Models/UserRightsHandler.dart";

class LoginScreen extends StatefulWidget
{
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
{
  TextEditingController loginUserNameController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();
  Role? selectedRole;
  final _formKey=GlobalKey<FormState>();
  
  //Registration of new users
  Widget BuildRegistrationUI(Key formKey)
  {
    final List<DropdownMenuItem<Role>> roleItems = Role.values.map((role)
    {
      return DropdownMenuItem<Role>(
        value: role,
        child: Text(role.toString().split(".").last));
      }).toList();
    return Form(
          key: formKey,
          child: Column(
            children: [
            TextFormField(
              controller: userNameController,
              decoration: const InputDecoration(
                label:Text("User name")
                ),
                validator: (value) => (value == null || value.isEmpty) ? "Please enter a user name" : null,
              ),
            TextFormField(
              controller: emailAddressController,
              decoration: const InputDecoration(
                label:Text("Email address")
                ),
                validator: (value) 
                {
                  if(value == null || value.isEmpty)
                  {
                    return "Please enter an email address";
                  }
                  if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value))
                  {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
              ),
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                label:Text("Password")
                ),
                obscureText: true,
                validator: (value) => (value != retypePasswordController.text) ? "Passwords do not match" : null,
              ),
            TextFormField(
              controller: retypePasswordController,
              decoration: const InputDecoration(
                label:Text("Retype Password")
                  ),
                obscureText: true,
                validator: (value) => (value != passwordController.text) ? "Passwords do not match" : null,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const Text("Role:"),
              const SizedBox(width: 10,),
              DropdownButton(
                value: selectedRole,
                items: roleItems,
                onChanged: (Role? role) 
                {
                  setState(() {
                     selectedRole = role;
                  });
                },
              )
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: HandleSubmit,
                  child: const Text("Submit")
                ),
                const SizedBox(width: 10,),
                ElevatedButton(
                  onPressed: HandleReset,
                  child: const Text("Reset")
                )
              ]
            )
          ]
        ),
      );
  }

  //Login 
  Widget BuildLoginUI(Key formKey)
  {
    return Form(
      key: formKey,
      //If unbounded width or height, leave it. Do not assert, ever!
      //These UI bugs are easier to fix if they can be seen.
          child: Column(
            children: [
            TextFormField(
              controller: loginUserNameController,
              decoration: const InputDecoration(
                label:Text("User name")
                ),
                validator: (value) => (value == null || value.isEmpty) ? "Please enter a user name" : null,
              ),
            TextFormField(
              controller: loginPasswordController,
              decoration: const InputDecoration(
                label:Text("Password")
                ),
                obscureText: true,
                validator: (value) => (value == null || value.isEmpty) ? "Please enter a password" : null,
              ),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: HandleSubmit,
                    child: const Text("Log in")
                  ),
                  const SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: HandleReset,
                    child: const Text("Reset")
                  )
                ]
              )
            ]
          ),
        );
  }

  bool IsExistingUser = true;

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: IsExistingUser 
        ? const Text("Login")
        : const Text("Register"),
        actions: [
            TextButton.icon(onPressed: (){
              setState(() {
                IsExistingUser = !IsExistingUser;
              });
            }, 
            icon: !IsExistingUser? const Icon(Icons.person_add_alt_1_outlined) : const Icon(Icons.login_outlined),
            label: Row(
              children: [
                Text(!IsExistingUser ? "New user" : "Existing user"),
              ]
            ))
          ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: IsExistingUser ? BuildLoginUI(_formKey) : BuildRegistrationUI(_formKey),
        ),
      )
    );
  }

  void HandleSubmit() 
  {
    //Validate the form
    bool? isValid = _formKey.currentState?.validate();
    if(isValid! == true) 
    {
      //At this point, we need to use the UserBloc to register the user to the users table in the database.
      if(IsExistingUser)
      {
        //The login user method is responsible for logging the user in.
        Login(loginUserNameController.text, loginPasswordController.text);
      }
      else
      {
        final user = UserDataModel(
          UserName: userNameController.text,
          EmailAddress: emailAddressController.text,
          Password: passwordController.text,
          UserRole: selectedRole!,
          UserRights: UserRightsHandler.GetUserRights(selectedRole!)
        );
        //Execute the registration using the bloc:
        BlocProvider.of<UserBloc>(context).add(RegisterNewUser(user));
      }
    }
    else
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Validation failed."),
        )
      );
    }
  }
  void HandleReset() 
  {
    //Clear al the text editing controllers:
    userNameController.clear();
    emailAddressController.clear();
    passwordController.clear();
    retypePasswordController.clear();
    loginUserNameController.clear();
    loginPasswordController.clear();
    //Reset the form state:
    _formKey.currentState?.reset();
  }
  void Login(String? userName, String? password) async
  {
    BlocProvider.of<UserBloc>(context).add(LoginUser(userName!, password!));
    await Future.delayed(const Duration(seconds: 3));
    if(mounted)
    {
      if(BlocProvider.of<UserBloc>(context).state.isAuthenticated)
      {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login successful."),
          )
        );
      }
      else
      {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Login failed."),
          )
        );
      }
      //At this point our credentials have now been authenticated if the state returns successful.
    }
  }
}