import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import '../network.dart';
import '../screens/price_screen.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    getprice();
  }

  void getprice() async {
    Network network = Network('https://api.coingecko.com/api/v3/coins/markets?vs_currency=krw&order=market_cap_desc&per_page=100&page=1&sparkline=false&price_change_percentage=24h');
    var Data = await network.getData();

    print(Data);
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return PriceScreen(parseData: Data);
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