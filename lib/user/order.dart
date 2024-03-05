import 'package:arokya/user/product.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'customer_class.dart';

class order extends StatefulWidget {
  const order({Key? key}) : super(key: key);

  @override
  State<order> createState() => _orderState();
}

class _orderState extends State<order> {
  String keyword = " ";
  double bill_total = 0;
  late DataSnapshot ds;
  late String username = '';
  List<product> list = [];
  List<int> count_value = [];
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  TextEditingController search = TextEditingController();
  String date = DateFormat("dd-MM-yyyy").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    bill_total = 0;
    for (int i = 0; i < list.length; i++) {
      bill_total = bill_total + list.elementAt(i).total;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              controller: search,
              hintText: 'Enter Customer Id here',
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 10)),
              trailing: [
                IconButton(
                    onPressed: () {
                      fetch(search.text);
                    },
                    icon: Icon(Icons.search))
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Card(
            color: Colors.blue,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    'Customer Details',
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Row(
                    children: [
                      Text(
                        "Name:",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        username,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        "Id:",
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        keyword,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.grey,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return getlist(index);
                  }),
            ),
          )
        ]),
      ),
      bottomNavigationBar: bottomwidget(context),
    );
  }

  Widget bottomwidget(BuildContext context) {
    if (keyword == ' ') {
      return Container(
        height: 0,
      );
    } else {
      return Container(
        height: MediaQuery.sizeOf(context).height * 0.07,
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(children: [
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '₹$bill_total',
                      style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                )),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    placeorder();
                  },
                  child: Text("Place Order")),
            ),
            SizedBox(width: 10),
            Expanded(
                flex: 1,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () {
                      fetch(keyword);
                      ref.child("payments").child(keyword).set("");
                      setState(() {});
                    },
                    child: Text(
                      "Reset Order",
                    )))
          ]),
        ),
      );
    }
  }

  void fetch(value) async {
    list = [];
    list.clear();
    count_value = [];
    keyword = value;
    await Firebase.initializeApp();
    ds = await ref.child('/products/Milk').get();
    for (DataSnapshot d in ds.children) {
      product data = product(d.child("Name").value,
          double.parse(d.child("Price").value.toString()));
      list.add(data);
    }
    ds = await ref.child('/products/Curd').get();
    for (DataSnapshot d in ds.children) {
      product data = product(d.child("Name").value,
          double.parse(d.child("Price").value.toString()));
      list.add(data);
    }
    DataSnapshot dname = await ref.child("customers").child(keyword).get();
    username = dname.child("Name").value.toString();
    DataSnapshot ds1 = await ref.child("payments").child(keyword).get();
    if (ds1.child("Date").exists && ds1.child("Date").value == date) {
      for (int i = 0; i < list.length; i++) {
        count_value.add(int.parse(ds1
            .child("Products")
            .child(i.toString())
            .child("Quantity")
            .value
            .toString()));
        list.elementAt(i).total =
            ds1.child("Products").child(i.toString()).child("Total").exists
                ? double.parse(ds1
                    .child("Products")
                    .child(i.toString())
                    .child("Total")
                    .value
                    .toString())
                : 0;
      }
    } else {
      count_value = List.filled(list.length, 0);
    }
    print(count_value);
    setState(() {});
  }

  Widget getlist(index) {
    if (keyword == "") {
      return Text("wait");
    } else {
      String name = list.elementAt(index).Name;
      double total = list.elementAt(index).total;
      double price = list.elementAt(index).Price;
      int count = count_value.elementAt(index);
      total = count * price;
      TextEditingController controller = TextEditingController(text: '$count');
      return Card(
        elevation: 5,
        margin: EdgeInsets.fromLTRB(5, 5, 5, 10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(
                  children: [
                    Text(
                      "Product Name",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Column(
                  children: [
                    Text("Price",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                    Text('$price',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold))
                  ],
                ),
                Column(
                  children: [
                    Text("Count",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                    Text('$count',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold))
                  ],
                ),
                Column(
                  children: [
                    Text("Total",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold)),
                    Text('$total',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold))
                  ],
                )
              ]),
              Divider(thickness: 4),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {
                            if (count > 0) {
                              count = count - 1;
                              count_value[index] = count;
                              total = count * price;
                              list.elementAt(index).total = total;
                              setState(() {});
                            }
                          },
                          icon: Icon(Icons.remove))),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: controller,
                      onSubmitted: (value) {
                        count_value[index] =
                            int.tryParse(controller.text) as int;
                        total = count_value[index] * price;
                        list.elementAt(index).total = total;
                        setState(() {});
                      },
                      cursorHeight: 20,
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                          onPressed: () {
                            count = count + 1;
                            count_value[index] = count;
                            total = count * price;
                            list.elementAt(index).total = total;
                            setState(() {});
                          },
                          icon: Icon(Icons.add))),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  void placeorder() async {
    DataSnapshot old = await ref.child("payments").child(keyword).get();
    if (old.child("Total").exists) {
      ref
          .child("record_history")
          .child(keyword)
          .child(old.child("Date").value.toString())
          .set(old.value);
    }
    for (int i = 0; i < list.length; i++) {
      ref
          .child("payments")
          .child(keyword)
          .child("Products")
          .child(i.toString())
          .child("Name")
          .set(list.elementAt(i).Name);
      ref
          .child("payments")
          .child(keyword)
          .child("Products")
          .child(i.toString())
          .child("Price")
          .set(list.elementAt(i).Price);
      ref
          .child("payments")
          .child(keyword)
          .child("Products")
          .child(i.toString())
          .child("Quantity")
          .set(count_value[i].toString());
      ref
          .child("payments")
          .child(keyword)
          .child("Products")
          .child(i.toString())
          .child("Total")
          .set(list.elementAt(i).total);
    }
    ref.child("payments").child(keyword).child("Date").set(date);
    ref.child("payments").child(keyword).child("Status").set("");
    ref.child("payments").child(keyword).child("Total").set(bill_total);
    ref
        .child("payments")
        .child(keyword)
        .child("Balance")
        .set(old.child("Balance").value.toString());
  }
}
