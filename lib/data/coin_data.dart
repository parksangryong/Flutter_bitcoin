import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
var apiKey = dotenv.env['APP_KEY'];

class CoinData {
  Future getCoinData(String coin) async {
    String url = '$coinAPIURL/$coin/USD?apikey=$apiKey';
    final response = await http.get(Uri.parse(url));
    print(response.body);
    if(response.statusCode == 200){
      var decodeData = jsonDecode(response.body);
      var lastPrice = decodeData['rate'];
      return lastPrice;
    }else{
      print(response.statusCode);
      throw 'Problem with the get request.';
    }
  }
}
