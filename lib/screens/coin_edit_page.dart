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
      appBar: AppBar(
        title: Text('가상화폐 추가'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          key: _formKey,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              //onSaved: (value) => _sym = value!.trim(),
              validator: (value) {
                if (value!.isEmpty) {
                  return '심볼을 입력하세요.';
                }
                return null;
              },
              controller: _symController,
              decoration: InputDecoration(
                border : OutlineInputBorder(),
                labelText: '티커명'
              ),
              maxLines: 1,
            ),
            SizedBox(height: 8.0),
            TextFormField(
              //onSaved: (value) => _amount = value!.trim() as double,
              validator: (value) {
                if (value!.isEmpty) {
                  return '수량을 입력하세요.';
                }
                return null;
              },
              controller: _amountController,
              decoration: InputDecoration(
                  border : OutlineInputBorder(),
                  labelText: '수량'
              ),
              maxLines: 1,
            ),
            SizedBox(height: 8.0),
            TextFormField(
              //onSaved: (value) => _price = value!.trim() as int,
              validator: (value) {
                if (value!.isEmpty) {
                  return '가격을 입력하세요.';
                }
                return null;
              },
              controller: _priceController,
              decoration: InputDecoration(
                  border : OutlineInputBorder(),
                  labelText: '매수가격'
              ),
              maxLines: 1,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              child: Text('추가하기'),
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
                textStyle: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff322f38),
                ),
              ),
              onPressed: () async {
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
                else if (widget.coin_sym.contains(_symController.text.trim()) == false ) {
                  showDialog<void> (
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('입력 오류'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget> [
                                Text('없는 가상화폐 입니다. 티커명을 확인해주세요.'),
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
                else {
                  final prefs = await SharedPreferences.getInstance();
                  var check_1 = prefs.getString(_symController.text.trim());
                  if (check_1 == null) {
                    prefs.setStringList(_symController.text.trim(), <String>[_amountController.text.trim(), _priceController.text.trim()]);
                    //widget.hold_coin_sym.add(_symController.text.trim());
                    //widget.hold_coin_amount.add(double.parse(_amountController.text.trim()));
                    //widget.hold_coin_price.add(int.parse(_priceController.text.trim()));
                    showDialog<void> (
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Success'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget> [
                                Text('Your currency has been inserted.'),
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
                  else {
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
                                Text('This coin has already been used.'),
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
                }
              },
            )
          ],
        )
      )
    );
  }
}
