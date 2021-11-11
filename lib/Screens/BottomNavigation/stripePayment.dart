import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stripe_sdk/stripe_sdk.dart';
import 'package:stripe_sdk/stripe_sdk_ui.dart';
import 'package:http/http.dart' as http;

import '../../Constant.dart';

class Payment extends StatefulWidget {

  static const id = 'Payment';

  final token;
  final price;
  final email;
  final eventId;

  Payment({this.token, this.price, this.email, this.eventId});


  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {

  final String postCreateIntentURL = "https:/yourserver/postPaymentIntent";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final StripeCard card = StripeCard();


  bool buttonStatus = true;
  final Stripe stripe = Stripe(
    "pk_test_51HmqUGK8xYnb88TS81qyUufHSlGzpkDzopIjxWiOuipqXLp6TTi2ygbshvHqB9j5PVwvr3SeVYXCESpaijSaSSGT00W5qCetTe", //Your Publishable Key
    stripeAccount: "acct_1HmqUGK8xYnb88TS", //Merchant Connected Account ID. It is the same ID set on server-side.
    returnUrlForSca: "stripesdk://3ds.stripesdk.io", //Return URL for SCA
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: amber,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context, buttonStatus);
          },
        ),
        title: Text("Stripe Payment"),
      ),
      body: new SingleChildScrollView(
        child: new GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: SafeArea(
            child: Column(
              children: [
                CardForm(
                    formKey: formKey,
                    card: card
                ),
                Container(
                  child: RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      child: const Text('Buy', style: TextStyle(fontSize: 20)),
                      onPressed: () {
                        formKey.currentState.validate();
                        formKey.currentState.save();
                        buy(context);
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void buy(context) async{
    final StripeCard stripeCard = card;
    final String customerEmail = getCustomerEmail();

    if(!stripeCard.validateCVC()){showAlertDialog(context, "Error", "CVC not valid."); return;}
    if(!stripeCard.validateDate()){showAlertDialog(context, "Errore", "Date not valid."); return;}
    if(!stripeCard.validateNumber()){showAlertDialog(context, "Error", "Number not valid."); return;}

    Map<String, dynamic> paymentIntentRes = await createPaymentIntent(stripeCard, customerEmail);
    String clientSecret = paymentIntentRes['client_secret'];
    String paymentMethodId = paymentIntentRes['payment_method'];
    String status = paymentIntentRes['status'];

    if(status == 'requires_action') //3D secure is enable in this card
      paymentIntentRes = await confirmPayment3DSecure(clientSecret, paymentMethodId);


    if(paymentIntentRes['status'] != 'succeeded'){
      showAlertDialog(context, "Warning", "Canceled Transaction.");
      return;
    }

    if(paymentIntentRes['status'] == 'succeeded'){
      showAlertDialog(context, "Success", "Thanks for buying!");

      Map<String,String> header = {
        'Content-type':'application/json',
        'Accept':'application/json',
        'Authorization':'${widget.token}'
      };

      String lur = "$url"+"/payment/ConfirmPayment/${widget.eventId}";

      http.post(lur, headers: header).then((value) {
        print(value.statusCode);
        if(value.statusCode >= 200 && value.statusCode < 300){

          setState(() {
            buttonStatus = false;
          });
        }
      });


      return;
    }
    showAlertDialog(context, "Warning", "Transaction rejected.\nSomething went wrong");
  }

  Future<Map<String, dynamic>> createPaymentIntent(StripeCard stripeCard, String customerEmail) async{
    String clientSecret;
    Map<String, dynamic> paymentIntentRes, paymentMethod;

      try{
        paymentMethod = await stripe.api.createPaymentMethodFromCard(stripeCard);
        clientSecret = await postCreatePaymentIntent(customerEmail, paymentMethod['id']);
        paymentIntentRes = await stripe.api.retrievePaymentIntent(clientSecret);
      }catch(e){
        print("ERROR_CreatePaymentIntentAndSubmit: $e");
        showAlertDialog(context, "Error", "Something went wrong. Try again");
      }
      return paymentIntentRes;
    }


  Future<String> postCreatePaymentIntent(String email, String paymentMethodId) async{
    String clientSecret;

    Map data = {
      "EventId" : widget.eventId,
      "email" : widget.email,
      "PaymentMethodId" : paymentMethodId,
      "price": widget.price
    };

    String sb = jsonEncode(data);

    http.Response response = await http.post(
      "$url"+"/payment/createpayment",
      headers: <String, String>{
        'Content-type':'application/json',
        'Accept':'application/json',
        'Authorization':'${widget.token}'
      },
      body: sb,
    );
    clientSecret = json.decode(response.body);
    return clientSecret;
  }

  Future<Map<String, dynamic>> confirmPayment3DSecure(String clientSecret, String paymentMethodId) async{
    Map<String, dynamic> paymentIntentRes_3dSecure;
    try{
      await stripe.confirmPayment(clientSecret, paymentMethodId: paymentMethodId);
      paymentIntentRes_3dSecure = await stripe.api.retrievePaymentIntent(clientSecret);
    }catch(e){
      print("ERROR_ConfirmPayment3DSecure: $e");
      showAlertDialog(context, "Error", "Something went wrong.");
    }
    return paymentIntentRes_3dSecure;
  }


  String getCustomerEmail(){
    String customerEmail;
    //Define how to get this info.
    // -Ask to the customer through a textfield.
    // -Get it from firebase Account.
    customerEmail = "alessandro.berti@me.it";
    return customerEmail;
  }

  showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return  AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              }, // dismiss dialog
            ),
          ],
        );
      },
    );
  }
}
