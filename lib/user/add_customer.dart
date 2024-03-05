import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class add_customer extends StatefulWidget {
  const add_customer({super.key});

  @override
  State<add_customer> createState() => _add_customerState();
}

class _add_customerState extends State<add_customer> {
  late String name, id;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add new Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            child: Column(children: [
              TextField(
                onChanged: (value) => name = value,
                decoration: InputDecoration(
                    hintText: 'Enter the Customer name',
                    labelText: 'Name',
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                onChanged: (value) => id = value,
                decoration: InputDecoration(
                    hintText: 'Enter the Customer Id',
                    labelText: 'Id',
                    border: OutlineInputBorder()),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    add_c(false);
                  },
                  child: Text("Add"))
            ]),
          ),
        )),
      ),
    );
  }

  void add_c(done) async {
    String lottie_image = done ? 'done.json' : 'loading.json';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Wait a moment'),
              contentPadding: EdgeInsets.all(10),
              content: Wrap(
                children: [
                  Lottie.asset('assets/' '$lottie_image'),
                ],
              ));
        });
    if (!done) {
      await Firebase.initializeApp();
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      await ref.child("customers").child(id).child('Name').set(name);
      ref
          .child("customers")
          .child(id)
          .child('Id')
          .set(id)
          .then((value) => Navigator.of(context).pop())
          .whenComplete(() => add_c(true));
    } else {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    }
  }
}
