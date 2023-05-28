import 'package:coin_wallet_demo/screens/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../main.dart';
import 'package:restart_app/restart_app.dart';

class CoinEditPage extends StatefulWidget {
  //final List<String> hold_coin_sym; //보유한 코인들의 티커명을 저장할 리스트
  //final List<double> hold_coin_amount; //보유한 코인들의 양을 저장할 리스트
  //final List<int> hold_coin_price; //보유한 코인들의 매수가를 저장할 리스트
  final List<String> coin_sym;

  //const CoinEditPage(this.hold_coin_sym, this.hold_coin_amount, this.hold_coin_price);
  const CoinEditPage(this.coin_sym);
  //const CoinEditPage({Key? key}) : super(key: key);

  @override
  State<CoinEditPage> createState() => _CoinEditPageState();
}

class _CoinEditPageState extends State<CoinEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _symController = TextEditingController();
  final _amountController = TextEditingController();
  final _priceController = TextEditingController();
  final List<bool> _isSelected = <bool>[true, false];
  var amount;
  var price;
  bool vertical = false;
  @override
  void initState() {
    //print(widget.hold_coin_sym);
    //print(widget.hold_coin_amount);
    //print(widget.hold_coin_price);
    super.initState();
  }
  void disPose() {
    _symController.dispose();
    _amountController.dispose();
    _priceController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff322f38),
      appBar: AppBar(
        title: Text('거래 추가'),
        backgroundColor: Color(0xff322f38),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          key: _formKey,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100.0,
                  child: Text('Side',
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  height: 40.0,
                  child: ToggleButtons(
                    direction: vertical ? Axis.vertical : Axis.horizontal,
                    onPressed: (int index) {
                      setState(() {
                        // The button that is tapped is set to true, and the others to false.
                        for (int i = 0; i < _isSelected.length; i++) {
                          _isSelected[i] = i == index;
                        }
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    selectedBorderColor: _isSelected[0] == true ? Colors.red[700] : Colors.blue[700],
                    fillColor: _isSelected[0] == true ? Colors.red[200] : Colors.blue[200],
                    color: _isSelected[0] == true ? Colors.blue[400] : Colors.red[400],
                    isSelected: _isSelected,
                    children: //button_list
                      <Widget> [
                        Container(
                            width: 98,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  "Buy",
                                  style: TextStyle(color: Colors.red),)],
                            )
                        ),
                        Container(
                            width: 98,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                    "Sell",
                                  style: TextStyle(color: Colors.blue),)],
                            )
                        ),
                      ]// ,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100.0,
                  child: Text(
                      'Symbol'
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  height: 40.0,
                  child: TextFormField(
                    //onSaved: (value) => _sym = value!.trim(),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '심볼을 입력하세요.';
                      }
                      return null;
                    },
                    controller: _symController,
                    decoration: const InputDecoration(
                      border : OutlineInputBorder(),
                      labelText: '티커명',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white,),
                      ),
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100.0,
                  child: Text(
                      'Quantity'
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  height: 40.0,
                  child: TextFormField(
                    //onSaved: (value) => _amount = value!.trim() as double,
                    onChanged: (value) {
                      amount = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '수량을 입력하세요.';
                      }
                      return null;
                    },
                    controller: _amountController,
                    decoration: const InputDecoration(
                      border : OutlineInputBorder(),
                      labelText: '수량',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white,),
                      ),
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100.0,
                  child: Text(
                      'Limit Price'
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  height: 40.0,
                  child: TextFormField(
                    //onSaved: (value) => _price = value!.trim() as int,
                    onChanged: (value) {
                      price = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '가격을 입력하세요.';
                      }
                      return null;
                    },
                    controller: _priceController,
                    decoration: const InputDecoration(
                      border : OutlineInputBorder(),
                      labelText: '거래가격',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.white,),
                      ),
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.0),
            Center(
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  child: Text('Confirm'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    textStyle: GoogleFonts.lato(
                      fontWeight: FontWeight.bold,
                      color: Color(0xff322f38),
                    ),
                  ),
                  onPressed: () async {
                    //값이 전부 입력되지 않은 경우
                    if (_symController.text == '' || _priceController.text == '' ||_amountController.text == '') {
                      showDialog<void> (
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('입력 오류'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget> [
                                    Text('티커명, 수량, 가격을 입력했는지 확인해주세요.'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          }
                      );
                    }
                    //DB에 없는 가상화폐가 입력된 경우
                    else if (widget.coin_sym.contains(_symController.text.toUpperCase()) == false ) {
                      showDialog<void> (
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('입력 오류'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget> [
                                    Text('${_symController.text.toUpperCase()}는 없는 가상화폐 입니다. 티커명을 확인하세요.'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          }
                      );
                    }
                    //매수량이나 금액에 잘못된 값이 입력된 경우
                    else if (double.tryParse(_amountController.text) == null || int.tryParse(_priceController.text) == null) {
                      showDialog<void> (
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('입력 오류'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget> [
                                    Text('수량에는 실수, 가격에는 정수값을 입력하세요.'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          }
                      );
                    }
                    else { //입력에 문제가 없으면 Confirm 진행.
                      final prefs = await SharedPreferences.getInstance();
                      var check_1 = prefs.getStringList((_symController.text.toUpperCase()).trim()); //return이 null이면 없는 키
                      /*
                      매수 거래
                      새로 등록하는 가상화폐인지 체크
                      매수 진행
                      */
                      if (_isSelected[0] == true) {
                        if (check_1 == null) { //새로 등록하는 가상화폐라면
                          prefs.setStringList(_symController.text.toUpperCase(), <String>[_amountController.text, _priceController.text]);
                          showDialog<void> (
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('거래완료'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget> [
                                      Text('정상적으로 매수되었습니다.'),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Loading()), (route) => false);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        else { //이미 등록된 가상화폐라면
                          var _amount_temp = double.parse(check_1[0]) + double.parse(_amountController.text); //기존 수량에서 새로더할 수량을 더함
                          var _price_temp =
                              (double.parse(check_1[0]) * double.parse(check_1[1]) +
                                  double.parse(_amountController.text) * double.parse(_priceController.text)) / _amount_temp; //매수평균가를 다시 계산
                          prefs.setStringList(_symController.text.toUpperCase(), <String>[_amount_temp.toString(), (_price_temp.toInt()).toString()]); //reassign 해줌
                          showDialog<void> (
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('거래완료'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget> [
                                      Text('정상적으로 매수되었습니다.'),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Loading()), (route) => false);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }

                      /*
                      매도 거래
                      보유한 가상화폐인지 아닌지 체크
                      보유 수량을 체크
                      매도 진행
                      */
                      else if (_isSelected[1] == true) {
                        if (check_1 == null) { //보유하지 않은 가상화폐를 매도하려고 한 경우
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Failed'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    //List Body를 기준으로 Text 설정
                                    children: <Widget>[
                                      Text('${_symController.text}는 보유하지 않은 가상화폐 입니다.'),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        else { //보유한 가상화폐를 매도하는 경우
                          if (double.parse(check_1[0]) < double.parse(_amountController.text)) { //보유한 양보다 많은 양을 매도하는 경우 오류
                            showDialog<void>( //거래 오류 출력
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Failed'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      //List Body를 기준으로 Text 설정
                                      children: <Widget>[
                                        Text('보유한 수량보다 많은 양은 매도할 수 없습니다.'),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          else if (double.parse(check_1[0]) > double.parse(_amountController.text)) { //보유한 양보다 적은 양을 매도하는 경우
                            var _amount_temp = double.parse(check_1[0]) - double.parse(_amountController.text);
                            prefs.setStringList(_symController.text.toUpperCase(), <String>[_amount_temp.toString(), check_1[1]]); //reassign 해줌
                            showDialog<void> (
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('거래완료'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget> [
                                        Text('정상적으로 매도되었습니다.'),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Loading()), (route) => false);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          else { //전량 매도의 경우
                            prefs.remove(_symController.text.toUpperCase());
                            showDialog<void> (
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('거래완료'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget> [
                                        Text('정상적으로 매도되었습니다.'),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Loading()), (route) => false);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      }
                    }
                  },
                ),
              ),
            )
          ],
        )
      )
    );
  }
}
