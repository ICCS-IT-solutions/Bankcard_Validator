// ignore_for_file: non_constant_identifier_names, file_names
class CountryDataModel
{
  final String CountryCode;
  final String CountryName;
  int IsBanned;
  final String BanReason;
  //Constructor
  CountryDataModel({required this.CountryCode, required this.CountryName, required this.IsBanned, required this.BanReason});

  factory CountryDataModel.fromDictionary(Map<String,dynamic> dictionary)
  {
    return CountryDataModel(
      CountryCode: dictionary["countryCode"],
      CountryName: dictionary["countryName"],
      IsBanned: dictionary["isBanned"],
      BanReason: dictionary["banReason"]
    );
  }

  Map<String,dynamic> toDictionary()
  {
    return
    {
      'countryCode': CountryCode,
      'countryName': CountryName,
      'isBanned': IsBanned,
      'banReason': BanReason
    };
  }
}