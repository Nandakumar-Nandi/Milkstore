import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'user/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {'/': (context) => login(), 'userhome': (context) => u_home()},
  ));
}

class login extends StatefulWidget {
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  String name = '', password = '';
  bool visibility = true;
  late SharedPreferences sharedPreferences;

  void checkuser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    print(sharedPreferences.getString("Name").toString());
    if (sharedPreferences.getString("Name") != null) {
      await Firebase.initializeApp();
      Navigator.pushNamedAndRemoveUntil(
          context, 'userhome', (Route route) => false);
    }
  }

  Future<void> check() async {
    await Firebase.initializeApp();
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/employee");
    DataSnapshot dataSnapshot = await ref.child(name).get();
    if (dataSnapshot.exists) {
      if (dataSnapshot.child("Password").value.toString() == password) {
        print("success");
        sharedPreferences.setString('Name', name);
        sharedPreferences.setString('Type', 'employee');
        Navigator.pushNamedAndRemoveUntil(
            context, 'userhome', (Route route) => false);
      } else {
        print("Wrong Password");
      }
    } else {
      print("No account found");
    }
  }

  @override
  Widget build(BuildContext context) {
    checkuser();
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
      child: Container(
          child: Column(
        children: [
          Lottie.asset('assets/cow.json'),
          Text(
            'LOGIN',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextField(
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Enter Your Name',
                        labelText: 'Name',
                        border: OutlineInputBorder()),
                    onChanged: (value) => name = value,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  passwordwidget(),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: check,
                    child: Text('Login'),
                  )
                ],
              ),
            ),
          )
        ],
      )),
    )));
  }

  Widget passwordwidget() {
    if (visibility) {
      return TextField(
        obscureText: visibility,
        obscuringCharacter: '*',
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.fingerprint),
            suffixIcon: IconButton(
              icon: Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  visibility = visibility ? false : true;
                });
              },
            ),
            hintText: 'Enter Your Password',
            labelText: 'Password',
            border: OutlineInputBorder()),
        onChanged: (value) => password = value,
      );
    } else {
      return TextField(
        obscureText: visibility,
        obscuringCharacter: '*',
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.fingerprint),
            suffixIcon: IconButton(
              icon: Icon(Icons.visibility),
              onPressed: () {
                setState(() {
                  visibility = visibility ? false : true;
                });
              },
            ),
            hintText: 'Enter Your Password',
            labelText: 'Password',
            border: OutlineInputBorder()),
        onChanged: (value) => password = value,
      );
    }
  }
}
