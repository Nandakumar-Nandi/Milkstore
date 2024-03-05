import 'package:arokya/user/bill.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class payment extends StatefulWidget {
  const payment({Key? key}) : super(key: key);
  @override
  State<payment> createState() => _paymentState();
}

class _paymentState extends State<payment> {
  String keyword = '', new_balance = '';
  FToast toast = FToast();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    toast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Payments"),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                hintText: 'Enter Customer Id here',
                leading: Icon(Icons.search),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(horizontal: 10)),
                onChanged: (value) => keyword = value,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  gen_bill();
                },
                child: Text('View Bill')),
            SizedBox(
              height: 20,
            ),
            gen_bill(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (keyword == '') {
                        toast.showToast(
                            child: Container(
                              width: 180,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: Colors.redAccent),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  ),
                                  Text("Enter the Id first",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18))
                                ],
                              ),
                            ),
                            gravity: ToastGravity.CENTER,
                            toastDuration: Duration(seconds: 2));
                      } else {
                        ref
                            .child("payments")
                            .child(keyword)
                            .child("Status")
                            .set("Paid");
                      }
                    },
                    child: Text('Paid')),
                SizedBox(width: 30),
                ElevatedButton(
                    onPressed: () {
                      if (keyword == '') {
                        toast.showToast(
                            child: Container(
                              width: 180,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                  color: Colors.redAccent),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                  ),
                                  Text("Enter the Id first",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18))
                                ],
                              ),
                            ),
                            gravity: ToastGravity.CENTER,
                            toastDuration: Duration(seconds: 2));
                      } else {
                        showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Wrap(children: [
                                  AlertDialog(
                                    title: Row(
                                      children: [
                                        Expanded(
                                          flex: 9,
                                          child: Text("Add Balance",
                                              textAlign: TextAlign.center),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(Icons.close)),
                                        )
                                      ],
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Column(
                                        children: [
                                          TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Enter the Amount',
                                              labelText: 'Amount',
                                              border: OutlineInputBorder(),
                                            ),
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) =>
                                                new_balance = value,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                ref
                                                    .child("payments")
                                                    .child(keyword)
                                                    .child("Balance")
                                                    .set(new_balance);
                                              },
                                              child: Text('Add'))
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                              );
                            });
                      }
                    },
                    child: Text('Balance')),
              ],
            ),
            SizedBox(height: 30),
          ]),
        ));
  }

  Widget gen_bill() {
    data();
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.9,
      height: MediaQuery.sizeOf(context).height * 0.65,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text('S.no',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 6,
                    child: Text('Product Name',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 3,
                    child: Text(
                      'Count',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
                Expanded(
                    flex: 3,
                    child: Text('Price',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 3,
                    child: Text('Total',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)))
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            Expanded(
              flex: 9,
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  int count = index + 1;
                  String name = list.elementAt(index).Name;
                  String price = list.elementAt(index).Price;
                  String quantity = list.elementAt(index).Quantity;
                  String total = list.elementAt(index).Total;
                  return Column(children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: Text('$count',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ))),
                        Expanded(
                            flex: 6,
                            child: Text('$name',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ))),
                        Expanded(
                            flex: 2,
                            child: Text(
                              '$quantity',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            )),
                        Expanded(
                            flex: 3,
                            child: Text('$price',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ))),
                        Expanded(
                            flex: 3,
                            child: Text('$total',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                )))
                      ],
                    ),
                    SizedBox(height: 0)
                  ]);
                },
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Row(
              children: [
                Expanded(
                    flex: 9,
                    child: Text("Balance",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 2,
                    child: Text("$balance",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    flex: 9,
                    child: Text("Total",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                Expanded(
                    flex: 2,
                    child: Text("$total",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
              ],
            )
          ]),
        ),
      ),
    );
  }

  late DatabaseReference ref;
  late DataSnapshot ds;
  List<bill_products> list = [];
  double balance = 0, total = 0;
  void data() async {
    print("hey");
    if (keyword != '') {
      await Firebase.initializeApp();
      ref = FirebaseDatabase.instance.ref();
      ds = await ref.child('payments').child(keyword).child("Products").get();
      list.clear();
      for (DataSnapshot d in ds.children) {
        if (d.child("Quantity").value.toString() != '0') {
          bill_products obj = bill_products(
              d.child("Name").value.toString(),
              d.child("Price").value.toString(),
              d.child("Quantity").value.toString(),
              d.child("Total").value.toString());
          list.add(obj);
        }
      }
      ds = await ref.child('payments').child(keyword).get();
      balance = ds.child("Balance").value.toString() != ''
          ? double.parse(ds.child("Balance").value.toString())
          : 0.0;
      total = double.parse(ds.child("Total").value.toString()) + balance;
      setState(() {});
    }
  }
}
