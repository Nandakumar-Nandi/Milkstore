import 'package:arokya/user/add_customer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'customer_class.dart';
import 'package:firebase_core/firebase_core.dart';

class customer extends StatefulWidget {
  const customer({Key? key}) : super(key: key);

  @override
  State<customer> createState() => _customerState();
}

class _customerState extends State<customer> {
  late DatabaseReference ref;
  late DataSnapshot ds;
  List<customer_class> o_list = [], list = [];
  void fetch() async {
    await Firebase.initializeApp();
    ref = FirebaseDatabase.instance.ref();
    ds = await ref.child("customers").get();
    for (DataSnapshot d in ds.children) {
      customer_class data = customer_class(
          d.child("Name").value.toString(), d.child("Id").value.toString());
      o_list.add(data);
    }
    setState(() {
      list = o_list;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    fetch();
  }

  Widget c_list(customer_class list) {
    customer_class d = list;
    String name = list.name, id = list.id;

    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Name',
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '$name',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                )
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'Id',
                  style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '$id',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                )
              ])
            ],
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Customers')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            SearchBar(
              hintText: 'Enter Customer Id here',
              leading: Icon(Icons.search),
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 10)),
              onChanged: (value) => search(value),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => add_customer()));
                },
                child: Text('Add Customer')),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return c_list(list.elementAt(index));
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  search(String value) {
    print(value);
    setState(() {
      List<customer_class> newlist = [];
      o_list.forEach((data) {
        if (data.name.contains(value)) {
          newlist.add(data);
        }
      });
      list = newlist;
    });
  }
}
