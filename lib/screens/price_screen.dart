import 'package:coin_wallet_demo/screens/coin_edit_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../screens/loading.dart';
import '../screens/coin_edit_page.dart';
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
  late List<String> coin_name = []; //코인 이름을 저장할 리스트
  late List<String> coin_sym = []; //코인 티커명을 저장할 리스트
  late List<String> coin_price = []; //코인 현재가를 저장할 리스트
  late List<String> coin_cap = []; //코인 시가총액을 저장할 리스트
  late List<String> coin_percent = []; //코인 등락률(24h)을 저장할 리스트
  late List<int> coin_sign = []; //코인이 양전인지 음전인지 체크용 리스트
  late List<String> coin_img_url = []; //코인 이미지 url을 저장할 리스트
  late List<double> coin_price_for_cal = []; //코인 가격 계산용 리스트
  late List<String> hold_coin_sym = ['BTC', 'ETH', 'XRP', 'DOGE']; //보유한 코인들의 티커명을 저장할 리스트
  late List<double> hold_coin_amount = [1, 6, 13500, 22500]; //보유한 코인들의 양을 저장할 리스트
  late List<int> hold_coin_price = [33500000, 2550000, 580, 93]; //보유한 코인들의 매수가를 저장할 리스트
  late List<int> hold_coin_idx = []; //보유한 코인들의 coin_sym 리스트에서의 인덱스값을 저장할 리스트
  late List<String> hold_coin_value = []; //보유한 코인들의 평가금액을 저장할 리스트
  late List<String> hold_coin_percent = []; //보유한 코인들의 수익률을 저장할 리스트
  late List<int> hold_coin_sign = []; //보유한 코인이 양전인지 음전인지 체크용 리스트
  late Timer _timer; //타이머
  late bool Refresh_timer = true; //체크용 bool
  late int total_value = 0; //총 평가금액
  late int total_price = 0; //총 매수금액
  late String total_value_print = '';
  late String profit_loss_print = '';
  late int profit_loss_sign = 0;
  late String profit_loss_per;
  void _time() {
    Timer.periodic(Duration(seconds: 30), (timer) {
      Refresh_timer = true;
    }
    );
  }
  void _Refresh() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => Loading(),
        )
    );
  }
  @override
  void initState() {
    super.initState();
    updateData(widget.parseData);
    _time(); //갱신 활성화를 위해 타이머 시작

    //자동 가격 갱신 기능 미사용
    //잦은 갱신 시 차단되어 비정상 작동
    /*
    _timer = Timer.periodic(Duration(seconds: 600), (timer) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => Loading(),
        )
      );
      //Navigator.push(context, MaterialPageRoute(builder: (_) => Loading()));
    });
    */
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
      coin_sym.add(Data[i]['symbol'].toUpperCase());
      coin_img_url.add(Data[i]['image']);
      coin_price.add(format2.format(double.parse(Data[i]['current_price'].toString())) + ' ₩');
      coin_price_for_cal.add(Data[i]['current_price'].toDouble());
      coin_cap.add(format.format(int.parse(Data[i]['market_cap'].toString())) + ' ₩');
      coin_percent.add(Data[i]['price_change_percentage_24h'].toStringAsFixed(2) + ' %');
      if (Data[i]['price_change_percentage_24h'] >= 0 ) {
        coin_sign.add(4294901760); //양전인 경우
      }
      else {
        coin_sign.add(4278212095); //음전인 경우
      }
    }
    for (int i = 0; i<hold_coin_sym.length; i++) {
      for (int j = 0; j<100; j++) {
        if (hold_coin_sym[i] == coin_sym[j]) {
          hold_coin_idx.add(j);
          break; //break로 시간 절약
        }
      }
      hold_coin_value.add(format.format(double.parse((hold_coin_amount[i] * coin_price_for_cal[hold_coin_idx[i]]).toString())));
      total_value+=(hold_coin_amount[i] * coin_price_for_cal[hold_coin_idx[i]]).toInt();
      total_price+=(hold_coin_amount[i] * hold_coin_price[i]).toInt();
      hold_coin_percent.add((((coin_price_for_cal[hold_coin_idx[i]]-hold_coin_price[i]) / hold_coin_price[i])*100).toStringAsFixed(2) + ' %');
      if (coin_price_for_cal[hold_coin_idx[i]] >= hold_coin_price[i]) {
        hold_coin_sign.add(4294901760);
      }
      else {
        hold_coin_sign.add(4278212095);
        hold_coin_percent[i] = '-' + hold_coin_percent[i];
      }
    }
    total_value_print = format.format(int.parse(total_value.toString())) + ' ₩';
    profit_loss_print = format.format(int.parse((total_value-total_price).toString())) + ' ₩';
    if (total_value-total_price >= 0) {
        profit_loss_sign = 4294901760;
    }
    else {
      profit_loss_sign = 4278212095;
    }
    profit_loss_per = (((total_value-total_price) / total_price)*100).toStringAsFixed(2);
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff322f38),
        //extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff322f38),
          title: Text('Coin Wallet Demo',),
          actions: [
            IconButton(onPressed: Refresh_timer ? () => _Refresh() : null
              , icon: Icon(Icons.refresh),),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Icon(Icons.home,),
            ),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Icon(Icons.insert_chart_outlined_outlined,),
            ),
          ],
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          controller: _tabController,
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
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
                                  padding: EdgeInsets.all(15),
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
                                              SizedBox(
                                                  width: 160,
                                                  child: Text('총평가금액',
                                                    style: GoogleFonts.lato(
                                                        fontSize: 12.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey
                                                    ),)
                                              ),
                                              SizedBox(
                                                  width: 120,
                                                  child: Text('평가손익',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 12.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.grey
                                                    ),)
                                              ),
                                              SizedBox(
                                                  width: 80,
                                                  child: Text('수익률',
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
                                                  width: 160,
                                                  child: Text(total_value_print,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 24.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.white
                                                    ),)
                                              ),
                                              SizedBox(
                                                  width: 120,
                                                  child: Text(profit_loss_print,
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(profit_loss_sign),
                                                    ),)
                                              ),
                                              SizedBox(
                                                  width: 80,
                                                  child: Text(profit_loss_per + '%',
                                                    textAlign: TextAlign.end,
                                                    style: GoogleFonts.lato(
                                                        fontSize: 18.0,
                                                        fontWeight: FontWeight.bold,
                                                        color: Color(profit_loss_sign),
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
                                                    '티커명　　　　　　',
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
                                                    '    시가총액',
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
                                                    '현재가/등락률',
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
                            padding: EdgeInsets.all(15),
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
                                        width: 160,
                                        child: Text('총평가금액',
                                          style: GoogleFonts.lato(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey
                                          ),)
                                    ),
                                    SizedBox(
                                        width: 120,
                                        child: Text('평가손익',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey
                                          ),)
                                    ),
                                    SizedBox(
                                        width: 80,
                                        child: Text('수익률',
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
                                        width: 160,
                                        child: Text(total_value_print,
                                          style: GoogleFonts.lato(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white
                                          ),)
                                    ),
                                    SizedBox(
                                        width: 120,
                                        child: Text(profit_loss_print,
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.lato(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Color(profit_loss_sign),
                                          ),)
                                    ),
                                    SizedBox(
                                        width: 80,
                                        child: Text(profit_loss_per + '%',
                                          textAlign: TextAlign.end,
                                          style: GoogleFonts.lato(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              color: Color(profit_loss_sign),
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

                                    SizedBox(
                                      width: 65,
                                      child: Text('티커명', style: GoogleFonts.lato(
                                          fontSize: 15.0,
                                          color: Colors.grey
                                      ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 65,
                                      child: Text('보유량',
                                        textAlign: TextAlign.end,
                                        style: GoogleFonts.lato(
                                          fontSize: 15.0,
                                          color: Colors.grey
                                      ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 90,
                                      child: Text('평가금/수익률',
                                        textAlign: TextAlign.end,
                                        style: GoogleFonts.lato(
                                          fontSize: 15.0,
                                          color: Colors.grey
                                      ),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 25.0,
                                  thickness: 1.0,
                                  color: Colors.white30,
                                ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: hold_coin_sym.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Image.network('${coin_img_url[hold_coin_idx[index]]}', width: 24, height: 24),
                                            SizedBox(
                                              width: 65,
                                              child: Text('${hold_coin_sym[index]}', style: GoogleFonts.lato(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: 65,
                                          child: Text('${hold_coin_amount[index]}',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.lato(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 90,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                '${hold_coin_value[index]}',
                                                style: GoogleFonts.lato(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                '${hold_coin_percent[index]}',
                                                style: GoogleFonts.lato(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(hold_coin_sign[index])),
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
                                SizedBox(height: 10.0,),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: FloatingActionButton.small(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return CoinEditPage();
                                      }));
                                    },
                                    child: Icon(Icons.add_chart_sharp),
                                    backgroundColor: Colors.white,
                                  ),
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
      ),
    );
  }
}