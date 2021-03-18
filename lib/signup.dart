import 'main.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'constant.dart' as constant;
import 'package:http/http.dart' as http;

class SignUpClass extends StatefulWidget {
  @override
  _SignUpClassState createState() => _SignUpClassState();
}

class _SignUpClassState extends State<SignUpClass> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignUp(),
    );
  }
}

class SignUp extends StatefulWidget {
  @override
  SignUpState createState() => SignUpState();

  SignUp();
}

class SignUpState extends State {
  bool visible = false;

  // Getting value from TextField widget.
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Future userSignUp() async {
    // Showing CircularProgressIndicator.
    setState(() {
      visible = true;
    });

    // Getting value from Controller
    String firstnamename = firstnameController.text;
    String lastname = lastnameController.text;
    String email = emailController.text;
    String password = passwordController.text;

print(firstnamename);
    // SERVER LOGIN API URL
    var url = 'https://harshr.000webhostapp.com/flutter_signup.php';

    // Store all data with Param Name.
    var data = {
      'email': email,
      'password': password,
      'firstname': firstnamename,
      'lastname': lastname
    };

print("before response");
    // Starting Web API Call.
    var response = await http.post(url, body: json.encode(data));

      print("after response");
      print(response.body);
    // Getting Server response into variable.
    var message = jsonDecode(response.body);
    print("after message");
print("\nThis is a message "+message);
    // If the Response Message is Matched.
    if (message != 'User already exists') {
      // Hiding the CircularProgressIndicator.

      print("inside if");
      setState(() {
        visible = false;
      });

      // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => new LoginUser()));
    } else {
      // If Email or Password did not Matched.
      // Hiding the CircularProgressIndicator.
      setState(() {
        visible = false;
      });

      // Showing Alert Dialog with Response JSON Message.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text(message),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('User Sign Up Form')),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('User Sign Up Form',
                      style: TextStyle(fontSize: 21))),
              Divider(),
              Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: firstnameController,
                    autocorrect: true,
                    decoration:
                        InputDecoration(hintText: 'Enter Your First Name Here'),
                  )),
              Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: lastnameController,
                    autocorrect: true,
                    decoration:
                        InputDecoration(hintText: 'Enter Your Last Name Here'),
                  )),
              Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: emailController,
                    autocorrect: true,
                    decoration:
                        InputDecoration(hintText: 'Enter Your Email Here'),
                  )),
              Container(
                  width: 280,
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    controller: passwordController,
                    autocorrect: true,
                    obscureText: true,
                    decoration:
                        InputDecoration(hintText: 'Enter Your Password Here'),
                  )),
              RaisedButton(
                onPressed: userSignUp,
                color: Colors.green,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                child: Text('Click Here To Sign Up'),
              ),
              Visibility(
                  visible: visible,
                  child: Container(
                      margin: EdgeInsets.only(bottom: 30),
                      child: CircularProgressIndicator())),
            ],
          ),
        )));
  }
}
