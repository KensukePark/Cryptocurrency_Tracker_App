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
    _timer = Timer.periodic(Duration(seconds: 600), (timer) {
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
    for (int i = 0; i<100; i++) {
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
                  //alignment: Alignment.center,
                    child: SingleChildScrollView(
                      child: Stack(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(10),
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
                                                    'Symbol            ',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 15.0,
                                                        color: Colors.grey
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
                                                        color: Colors.grey
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Price/24h',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 15.0,
                                                        color: Colors.grey
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
                                          ListView.separated(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: coin_name.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Image.network('${coin_img_url[index]}', width: 24, height: 24),
                                                        SizedBox(
                                                          width: 65,
                                                          child: Text('${coin_name[index]}', style: GoogleFonts.lato(
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
                                                      child: Text('${coin_cap[index]}',
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
                                                            coin_price[index],
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Colors.white),
                                                          ),
                                                          Text(
                                                            coin_percent[index],
                                                            style: GoogleFonts.lato(
                                                                fontSize: 12.0,
                                                                fontWeight: FontWeight.bold,
                                                                color: Color(coin_sign[index])),
                                                          ),
                                                        ],
                                                      ),

                                                    ),

                                                  ],
                                                ),
                                              );
                                            }, separatorBuilder: (BuildContext context, int index) =>
                                              SizedBox(height: 10.0,),
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
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          child:
                            Column(
                              children: [
                                SizedBox(
                                  height: 1.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        width: 150,
                                        child: Text('Total Portfolio Value',
                                          style: GoogleFonts.lato(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey
                                          ),)
                                    ),
                                    SizedBox(
                                        width: 80,
                                        child: Text('Profit & Loss',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey
                                          ),)
                                    ),
                                    SizedBox(
                                        width: 80,
                                        child: Text('Rate of return',
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.lato(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey
                                          ),)
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                        width: 150,
                                        child: Text('0 ₩',
                                          style: GoogleFonts.lato(
                                              fontSize: 28.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),)
                                    ),
                                    SizedBox(
                                        width: 80,
                                        child: Text('0 ₩',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),)
                                    ),
                                    SizedBox(
                                        width: 80,
                                        child: Text('0%',
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.lato(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),)
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Symbol',
                                          style: GoogleFonts.lato(
                                              fontSize: 15.0,
                                              color: Colors.grey
                                          ),
                                        ),

                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Holdings',
                                          style: GoogleFonts.lato(
                                              fontSize: 15.0,
                                              color: Colors.grey
                                          ),
                                        ),

                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Price/24h',
                                          style: GoogleFonts.lato(
                                              fontSize: 15.0,
                                              color: Colors.grey
                                          ),
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 25.0,
                                  thickness: 1.0,
                                  color: Colors.white30,
                                ),
                                /*
                                SizedBox(
                                  width : 200,
                                  child: ListView.builder(
                                    itemCount: 3,
                                    itemBuilder: (BuildContext cntext, int index) {
                                      return ListTile(
                                        title : Text('Entry ${coin_name[index]}', ),
                                      );
                                    }
                                  )
                                ),

                                 */
                                ListView.separated(
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.all(8),
                                    itemCount: 3,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        height: 50,
                                        child: Center(child: Text(
                                            'Entry ${coin_name[index]}')),
                                      );
                                    }, separatorBuilder: (BuildContext context, int index) =>
                                    SizedBox(height: 15.0,),
                                ),

                              ],
                            )
                        ),

                      ],
                    ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}