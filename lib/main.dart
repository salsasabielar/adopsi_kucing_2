//kode utama Aplikasi tampilan awal
import 'package:flutter/material.dart';
import 'home.dart';
import 'homeCustomer.dart'; //package letak folder Anda

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Adopsi Kucing",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            centerTitle: true,
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Kucing",
                ),
                Tab(text: "Adopter"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Home(),
              HomeCustomer(),
            ],
          ),
        ),
      ),
    );
  }
}
