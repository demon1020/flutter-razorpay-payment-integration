import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Razorpay razorpay = Razorpay();
  TextEditingController priceController = TextEditingController(text: "1000");

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    Fluttertoast.showToast(
      msg: "Payment Success",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Fluttertoast.showToast(
      msg: "Payment Failed",
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  @override
  void dispose() {
    razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Razorpay',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Razorpay-Payment-Integration'),
        ),
        body: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.numberWithOptions(signed: false),
                decoration: InputDecoration(
                  hintText: "Enter amount. (eg. 10)",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 50),
              OutlinedButton(
                onPressed: () async {
                  int amount = int.parse(priceController.text);
                  try {
                    Map<String, dynamic> options = {
                      'key': 'rzp_test_SBgo4XrM4EzfBn',
                      //Add key Id from the dashboard || Must be tested on a real device otherwise it will not work and will give some exception
                      'amount': amount * 100,
                      'name': 'Snitch.Co',
                      'description': 'Fine T-Shirt',
                      'prefill': {
                        'contact': '8888888888',
                        'email': 'useremail@razorpay.com'
                      }
                    };
                    razorpay.on(
                        Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
                    razorpay.on(
                        Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);

                    razorpay.open(options);
                  } on Exception catch (e) {
                    Fluttertoast.showToast(
                      msg: e.toString(),
                      toastLength: Toast.LENGTH_SHORT,
                    );
                  }
                },
                child: Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
