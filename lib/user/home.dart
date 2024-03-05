import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'customers.dart';
import 'order.dart';
import 'payments.dart';
import 'package:arokya/main.dart';

class u_home extends StatefulWidget {
  @override
  State<u_home> createState() => _u_homeState();
}

class _u_homeState extends State<u_home> {
  late String? name = '';

  @override
  void initState() {
    super.initState();
  }

  void logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: ((context) => login())),
        (Route route) => false);
  }

  @override
  Widget build(BuildContext context) {
    fetch();
    return Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: logout, icon: Icon(Icons.logout))],
          title: Text('$name'),
        ),
        body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Padding(
            padding: EdgeInsets.all(30),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Image(
                          image: AssetImage("assets/payments.png"),
                          height: MediaQuery.sizeOf(context).height * 0.2,
                          width: MediaQuery.sizeOf(context).width * 0.67,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => payment()));
                            },
                            child: Text('Payment')),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Image(
                          image: AssetImage("assets/order.jpg"),
                          height: MediaQuery.sizeOf(context).height * 0.2,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => order()));
                            },
                            child: Text('Order')),
                      ])),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(children: [
                        Image(
                          image: AssetImage("assets/customer.jpg"),
                          height: MediaQuery.sizeOf(context).height * 0.2,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => customer()));
                            },
                            child: Text('Customers'))
                      ]))
                ],
              ),
            ),
          ),
        ));
  }

  void fetch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    name = sharedPreferences.getString('Name');
    setState(() {});
  }
}
