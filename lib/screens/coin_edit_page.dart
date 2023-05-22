import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CoinEditPage extends StatefulWidget {
  const CoinEditPage({Key? key}) : super(key: key);

  @override
  State<CoinEditPage> createState() => _CoinEditPageState();
}

class _CoinEditPageState extends State<CoinEditPage> {
  final symController = TextEditingController();
  final holdController = TextEditingController();
  final priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add coin'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                border : OutlineInputBorder(),
                labelText: 'Write Symbol'
              ),
              maxLines: 1,
              controller: symController,
            ),
            SizedBox(height: 8.0),
            TextField(
              decoration: InputDecoration(
                  border : OutlineInputBorder(),
                  labelText: 'Write Amount'
              ),
              maxLines: 1,
              controller: holdController,
            ),
            SizedBox(height: 8.0),
            TextField(
              decoration: InputDecoration(
                  border : OutlineInputBorder(),
                  labelText: 'Write Price'
              ),
              maxLines: 1,
              controller: priceController,
            ),
          ],
        )
      )
    );
  }
}
