import 'package:bitcoin_ticker/data/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  final CoinData coinData = CoinData();
  String selectedCurrency = 'USD';
  String bitcoinValueInBTC = '?';
  String bitcoinValueInETH = '?';
  String bitcoinValueInLTC = '?';

  @override
  void initState() {
    super.initState();
    getData();
  }

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(value: currency, child: Text(currency));
      dropdownItems.add(newItem);
    }

    return DropdownButton(
        value: selectedCurrency,
        items: dropdownItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value!;
            getData();
          });
        });
  }

  CupertinoPicker iosPicker() {
    List<Text> textItems = [];

    for (String items in currenciesList) {
      var newItem = Text(items);
      textItems.add(newItem);
    }

    return CupertinoPicker(
      itemExtent: 32,
      children: textItems,
      onSelectedItemChanged: (index) {
        selectedCurrency = currenciesList[index];
        getData();
      },
    );
  }

  void getData() async {
    try {
      double dataBTC = await coinData.getCoinData('BTC');
      double dataETH = await coinData.getCoinData('ETH');
      double dataLTC = await coinData.getCoinData('LTC');
      setState(() {
        bitcoinValueInBTC = dataBTC.toStringAsFixed(0);
        bitcoinValueInETH = dataETH.toStringAsFixed(0);
        bitcoinValueInLTC = dataLTC.toStringAsFixed(0);
      });
    } catch (e) {
      print(e);
    }
  }



  Widget cardItem(String coin, String coinName){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding:const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $coin = $coinName $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                cardItem('BTC', bitcoinValueInBTC),
                cardItem('ETH', bitcoinValueInETH),
                cardItem('LTC', bitcoinValueInLTC),
              ],
            )
          ),
          Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: Platform.isIOS ? iosPicker() : androidDropDown()),
        ],
      ),
    );
  }
}
