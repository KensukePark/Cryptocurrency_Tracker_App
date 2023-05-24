import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network.dart';
import '../screens/price_screen.dart';


class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  late List<String> key_temp = [];
  late List<String> value_temp = [];
  @override
  void initState() {
    super.initState();
    getprice();
  }

  void getprice() async {
    Network network = Network('https://api.coingecko.com/api/v3/coins/markets?vs_currency=krw&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h');
    var Data = await network.getData();
    final prefs = await SharedPreferences.getInstance();
    //prefs.clear(); //초기화시 사용
    key_temp = prefs.getKeys().toList();
    key_temp.sort();
    if (key_temp.length > 0) {
      for (int i = 0; i < key_temp.length; i++) {
        value_temp.add(prefs.getStringList(key_temp[i])![0]);
        value_temp.add(prefs.getStringList(key_temp[i])![1]);
      }
    }
    print(Data);
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return PriceScreen(parseData: Data, keyData: key_temp, valueData: value_temp);
    }));
  } // ...getprice()

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff322f38),
      body: Center(
        child: SpinKitRing(
          color: Colors.white,
          duration: const Duration(milliseconds:2000),
        )
      )
    );
  }
}