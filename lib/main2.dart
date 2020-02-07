import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    title: 'Simple Interest App',
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController prinController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  var _selectedItem;
  String displayResult = '';

  List _currencies = ['Naira', 'Rupee', 'Dollar', 'Others'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Interest Calculator'),
      ),
      // backgroundColor: Colors.black12,
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            CircleAvatar(
              radius: 68,
              backgroundImage: AssetImage(
                'assets/images/kidnap.jpeg',
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: prinController,
                keyboardType: TextInputType.number,
                // validator: (String value) {
                //   if (value.isEmpty) {
                //     return 'Please enter principal amount';
                //   }
                //   return 'Please enter principal amount';
                // },
                decoration: InputDecoration(
                  helperText: 'Test',
                  labelText: 'Principal',
                  hintText: 'Please enter the principal amount (e.g 1000)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: rateController,
                keyboardType: TextInputType.number,
                // validator: (String value) {
                //   if (value.isEmpty) {
                //     return 'Please enter rate amount';
                //   }
                //   return 'Please enter rate amount';
                // },
                decoration: InputDecoration(
                  labelText: 'Rate',
                  hintText: 'Please enter the rate in percent',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: timeController,
                      keyboardType: TextInputType.number,
                      // validator: (String value) {
                      //   if (value.isEmpty) {
                      //     return 'Please enter time';
                      //   }
                      //   return 'Please enter time';
                      // },
                      decoration: InputDecoration(
                        labelText: 'Time',
                        hintText: 'In years',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: DropdownButton<String>(
                      items: _currencies.map((currency) {
                        return DropdownMenuItem<String>(
                          child: Text(currency),
                          value: currency,
                        );
                      }).toList(),
                      onChanged: (String newSelectedValue) {
                        setState(() {
                          this._selectedItem = newSelectedValue;
                        });
                      },
                      value: _selectedItem,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        double p = double.parse(prinController.text);
                        double r = double.parse(rateController.text);
                        double t = double.parse(timeController.text);

                        double totalPayableAmt = p + (p * r * t) / 100;

                        String result =
                            'After $t years, your investment will be the worth of '
                            '$totalPayableAmt $_selectedItem';
                        setState(() {
                          this.displayResult = result;
                        });
                      },
                      color: Colors.lightBlueAccent,
                      elevation: 10.0,
                      child: Text('Calculte'),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {},
                      color: Colors.lightBlueAccent,
                      elevation: 10.0,
                      child: Text('Reset'),
                    ),
                  ),
                ],
              ),
            ),
            Text(displayResult),
          ],
        ),
      ),
    );
  }

  String calculate() {
    double p = double.parse(prinController.text);
    double r = double.parse(rateController.text);
    double t = double.parse(timeController.text);

    double totalPayableAmt = p + (p * r * t) / 100;

    String result = 'After $t years, your investment will be the worth of '
        '$totalPayableAmt $_selectedItem';
    return result;
  }
}
