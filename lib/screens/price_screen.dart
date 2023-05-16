import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../screens/loading.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:async';

class PriceScreen extends StatefulWidget {
  PriceScreen({this.parseData});
  final parseData;
  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> with TickerProviderStateMixin{
  late TabController _tabController;
  late List<String> coin_name = [];
  late List<String> coin_sym = [];
  late List<String> coin_price = [];
  late List<String> coin_cap = [];
  late List<String> coin_percent = [];
  late List<int> coin_sign = [];
  late List<String> coin_img_url = [];
  late Timer _timer;
  int len = 3;

  @override
  void initState() {
    super.initState();
    updateData(widget.parseData);
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => Loading(),
        )
      );
      //Navigator.push(context, MaterialPageRoute(builder: (_) => Loading()));
    });
    _tabController = TabController(
      length: 2,
      vsync: this,  //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
  }

  void updateData(dynamic Data){
    NumberFormat format = NumberFormat('#,###');
    NumberFormat format2 = NumberFormat('#,###.##');
    for (int i = 0; i<15; i++) {
      //coin_name.add(' ' + Data[i]['id']);
      coin_name.add(' '+Data[i]['symbol'].toUpperCase());
      coin_sym.add(Data[i]['symbol']);
      coin_img_url.add(Data[i]['image']);
      coin_price.add(format2.format(double.parse(Data[i]['current_price'].toString())) + ' ₩');
      coin_cap.add(format.format(int.parse(Data[i]['market_cap'].toString())) + ' ₩');
      coin_percent.add(Data[i]['price_change_percentage_24h'].toStringAsFixed(2) + ' %');
      if (Data[i]['price_change_percentage_24h'] >= 0 ) {
        coin_sign.add(4278231040); //양전인 경우
      }
      else {
        coin_sign.add(4294901760); //음전인 경우
      }
    }
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff322f38),
      //extendBodyBehindAppBar: true,

      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            child: TabBar(
              tabs: [
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: Text(
                        'Market',
                  ),
                ),
                Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: Text(
                    'Wallet',
                  ),
                ),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              controller: _tabController,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Container(
                  color: Color(0xff322f38),
                  alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Stack(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(20),
                                  child:
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 1.0,
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Currency',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 15.0,
                                                        color: Colors.white
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '    Market Cap',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 15.0,
                                                        color: Colors.white
                                                    ),
                                                  ),

                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Price',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 15.0,
                                                        color: Colors.white
                                                    ),
                                                  ),

                                                ],
                                              ),

                                            ],
                                          ),
                                          Divider(
                                            height: 25.0,
                                            thickness: 2.0,
                                            color: Colors.white30,
                                          ),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.network('${coin_img_url[0]}', width: 24, height: 24),
                                                      SizedBox(
                                                        width: 65,
                                                        child: Text('${coin_name[0]}', style: GoogleFonts.lato(
                                                          fontSize: 12.0,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text('${coin_cap[0]}',
                                                      textAlign: TextAlign.end,
                                                      style: GoogleFonts.lato(
                                                        fontSize: 12.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          coin_price[0],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          coin_percent[0],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(coin_sign[0])),
                                                        ),
                                                      ],
                                                    ),

                                                  ),

                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              //-------------------------------------------------
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.network('${coin_img_url[1]}', width: 24, height: 24),
                                                      SizedBox(
                                                        width: 65,
                                                        child: Text('${coin_name[1]}',
                                                        style: GoogleFonts.lato(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white
                                                        ),)
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text('${coin_cap[1]}',
                                                      textAlign: TextAlign.end,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 12.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white),
                                                    )
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          coin_price[1],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          coin_percent[1],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(coin_sign[1])),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              //-------------------------------------------------
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.network('${coin_img_url[2]}', width: 24, height: 24),
                                                      SizedBox(
                                                          width: 65,
                                                          child: Text('${coin_name[2]}',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white
                                                            ),)
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 150,
                                                      child: Text('${coin_cap[2]}',
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      )
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          coin_price[2],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          coin_percent[2],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(coin_sign[2])),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.network('${coin_img_url[3]}', width: 24, height: 24),
                                                      SizedBox(
                                                          width: 65,
                                                          child: Text('${coin_name[3]}',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white
                                                            ),)
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 150,
                                                      child: Text('${coin_cap[3]}',
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      )
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          coin_price[3],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          coin_percent[3],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(coin_sign[3])),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.network('${coin_img_url[4]}', width: 24, height: 24),
                                                      SizedBox(
                                                          width: 65,
                                                          child: Text('${coin_name[4]}',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white
                                                            ),)
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 150,
                                                      child: Text('${coin_cap[4]}',
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      )
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          coin_price[4],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          coin_percent[4],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(coin_sign[4])),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      //Image.network('${coin_img_url[5]}', width: 24, height: 24),
                                                      Image.asset('image/${coin_sym[5]}.png', width: 24, height: 24),
                                                      SizedBox(
                                                          width: 65,
                                                          child: Text('${coin_name[5]}',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white
                                                            ),)
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 150,
                                                      child: Text('${coin_cap[5]}',
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      )
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          coin_price[5],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          coin_percent[5],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(coin_sign[5])),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.network('${coin_img_url[6]}', width: 24, height: 24),
                                                      SizedBox(
                                                          width: 65,
                                                          child: Text('${coin_name[6]}',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white
                                                            ),)
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 150,
                                                      child: Text('${coin_cap[6]}',
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      )
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          coin_price[6],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          coin_percent[6],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(coin_sign[6])),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.network('${coin_img_url[7]}', width: 24, height: 24),
                                                      SizedBox(
                                                          width: 65,
                                                          child: Text('${coin_name[7]}',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white
                                                            ),)
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 150,
                                                      child: Text('${coin_cap[7]}',
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      )
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          coin_price[7],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          coin_percent[7],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(coin_sign[7])),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.network('${coin_img_url[8]}', width: 24, height: 24),
                                                      SizedBox(
                                                          width: 65,
                                                          child: Text('${coin_name[8]}',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white
                                                            ),)
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 150,
                                                      child: Text('${coin_cap[8]}',
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      )
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          coin_price[8],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          coin_percent[8],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(coin_sign[8])),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.network('${coin_img_url[9]}', width: 24, height: 24),
                                                      SizedBox(
                                                          width: 65,
                                                          child: Text('${coin_name[9]}',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white
                                                            ),)
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 150,
                                                      child: Text('${coin_cap[9]}',
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      )
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          coin_price[9],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          coin_percent[9],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(coin_sign[9])),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.network('${coin_img_url[10]}', width: 24, height: 24),
                                                      SizedBox(
                                                          width: 65,
                                                          child: Text('${coin_name[10]}',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white
                                                            ),)
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 150,
                                                      child: Text('${coin_cap[10]}',
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      )
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          coin_price[10],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          coin_percent[10],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(coin_sign[10])),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.network('${coin_img_url[11]}', width: 24, height: 24),
                                                      SizedBox(
                                                          width: 65,
                                                          child: Text('${coin_name[11]}',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white
                                                            ),)
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 150,
                                                      child: Text('${coin_cap[11]}',
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      )
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          coin_price[11],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          coin_percent[11],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(coin_sign[11])),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.network('${coin_img_url[12]}', width: 24, height: 24),
                                                      SizedBox(
                                                          width: 65,
                                                          child: Text('${coin_name[12]}',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white
                                                            ),)
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 150,
                                                      child: Text('${coin_cap[12]}',
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      )
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          coin_price[12],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          coin_percent[12],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(coin_sign[12])),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.network('${coin_img_url[13]}', width: 24, height: 24),
                                                      SizedBox(
                                                          width: 65,
                                                          child: Text('${coin_name[13]}',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white
                                                            ),)
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 150,
                                                      child: Text('${coin_cap[13]}',
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      )
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          coin_price[13],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          coin_percent[13],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(coin_sign[13])),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.network('${coin_img_url[14]}', width: 24, height: 24),
                                                      SizedBox(
                                                          width: 65,
                                                          child: Text('${coin_name[14]}',
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white
                                                            ),)
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      width: 150,
                                                      child: Text('${coin_cap[14]}',
                                                        textAlign: TextAlign.end,
                                                        style: GoogleFonts.lato(
                                                            fontSize: 12.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white),
                                                      )
                                                  ),
                                                  SizedBox(
                                                    width: 120,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          coin_price[14],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.white),
                                                        ),
                                                        Text(
                                                          coin_percent[14],
                                                          style: GoogleFonts.lato(
                                                              fontSize: 12.0,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color(coin_sign[14])),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 15.0,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                              )
                            ]
                        ),
                    )
                ),
                Container(
                  color: Color(0xff322f38),
                  alignment: Alignment.bottomCenter,
                  child: ListView.builder(
                    itemCount: len,
                    itemBuilder: (BuildContext cntext,int index) {
                      return Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget> [
                            Text('Entry ${coin_name[index]}',
                              style: GoogleFonts.lato(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                )
                            )
                          ]
                        ),
                      );
                    }
                  )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

