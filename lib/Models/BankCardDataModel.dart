// ignore_for_file: non_constant_identifier_names, file_names, constant_identifier_names

enum BankCardType {Visa, Mastercard, AmericanExpress, unknown}

class BankCardDataModel
{
  final String CardNumber; //Bank card number
  final String CardHolderName; //Full name or initial and surname, as it appears on the card.
  BankCardType? CardType; //Visa, Amex, Mastercard
  final String ExpirationDate; //Valid until mm/yy
  final String CountryOfOrigin; //ISO 3166-1, Country of origin of this bank card.
  final String Cvv; //CVV or CVC number - used as a security measure
  int IsFromBannedCountry;

  //Constructor for this class
  BankCardDataModel({
    required this.CardNumber, 
    required this.CardHolderName, 
    this.CardType, 
    required this.ExpirationDate, 
    required this.CountryOfOrigin, 
    required this.Cvv, 
    required this.IsFromBannedCountry});
  //The card type must be inferred from the number
  factory BankCardDataModel.fromDictionary(Map<String,dynamic> dictionary)
  {
    return BankCardDataModel(
      CardNumber : dictionary["cardNumber"],
      CardHolderName : dictionary["cardHolderName"],
      CardType : MapCardType(dictionary["cardType"]),
      ExpirationDate : dictionary["expirationDate"],
      CountryOfOrigin : dictionary["countryOfOrigin"],
      Cvv:dictionary["cvv"],
      IsFromBannedCountry : dictionary["isFromBannedCountry"]
    );
  }
  Map<String,dynamic> toDictionary()
  {
    return
    {
      'cardNumber': CardNumber, 
      'cardHolderName': CardHolderName, 
      'cardType': MapCardTypeToString(GetCardType(CardNumber)), 
      'expirationDate': ExpirationDate, 
      'countryOfOrigin': CountryOfOrigin, 
      'cvv': Cvv, 
      'isFromBannedCountry': IsFromBannedCountry
    };
  }
}

  BankCardType GetCardType(String cardNum)
  {
  //At this stage we don't know what type the card is, so set it to unknown for now.
  BankCardType cardType = BankCardType.unknown;
    //If the bank card number starts with a 4, it is a Visa card.
    if(cardNum.startsWith("4"))
    {
      cardType = BankCardType.Visa;
    }
    //Mastercard numbers:
    if(cardNum.startsWith( "51") || cardNum.startsWith("52") || cardNum.startsWith("53") || cardNum.startsWith( "54") || cardNum.startsWith("55"))
    {
      cardType = BankCardType.Mastercard;
    }
    //American express numbers:
    if(cardNum.startsWith("34") || cardNum.startsWith("37"))
    {
      cardType = BankCardType.AmericanExpress;
    }
    return cardType;
  }

  BankCardType? MapCardType(String cardTypeEnumString)
  {
    switch(cardTypeEnumString)
    {
      case "Visa":
        return BankCardType.Visa;
      case "Mastercard":
        return BankCardType.Mastercard;
      case "AmericanExpress":
        return BankCardType.AmericanExpress;
      default:
        return null;
    }
  }
  String MapCardTypeToString(BankCardType cardType)
  {
    switch(cardType)
    {
      case BankCardType.Visa:
        return "Visa";
      case BankCardType.Mastercard:
        return "Mastercard";
      case BankCardType.AmericanExpress:
        return "AmericanExpress";
      default:
        return "";
    }
  }

//Not yet in use.
String MapCountryCodeToCountryName(String CountryCode)
{
  switch(CountryCode)
  {


    default:
      return "";
  }
}

//Not yet in use.
String MapCountryNameToCountryCode(String CountryName)
{
  switch(CountryName)
  {
    case "Afghanistan":
      return "AF";
    case "Aland Islands":
      return "AX";
    case "Albania":
      return "AL";
    case "Algeria":
      return "DZ";
    case "American Samoa":
      return "AS";
    case "Andorra":
      return "AD";
    case "Angola":
      return "AO";
    case "Anguilla":
      return "AI";
    case "Antarctica":
      return "AQ";
    case "Antigua and Barbuda":
      return "AG";
    case "Argentina":
      return "AR";
    case "Armenia":
      return "AM";
    case "Aruba":
      return "AW";
    case "Australia":
      return "AU";
    case "Austria":
      return "AT";
    case "Azerbaijan":
      return "AZ";
    case "Bahamas":
      return "BS";
    case "Bahrain":
      return "BH";
    case "Bangladesh":
      return "BD";
    case "Barbados":
      return "BB";
    case "Belarus":
      return "BY";
    case "Belgium":
      return "BE";
    case "Belize":
      return "BZ";
    case "Benin":
      return "BJ";
    case "Bermuda":
      return "BM";
    case "Bhutan":
      return "BT";
    case "Bolivia":
      return "BO";
    case "Bosnia and Herzegovina":
      return "BA";
    case "Botswana":
      return "BW";
    case "Bouvet Island":
      return "BV";
    case "Brazil":
      return "BR";
    case "British Indian Ocean Territory":
      return "IO";
    case "Brunei Darussalam":
      return "BN";
    case "Bulgaria":
      return "BG";

    //If not found, return null
    default:
      return "";
  }
}