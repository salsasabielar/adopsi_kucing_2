import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dbhelper.dart';
import 'formCustomer.dart';
import 'model/customer.dart';

//pendukung program asinkron
class HomeCustomer extends StatefulWidget {
  @override
  HomeCustomerState createState() => HomeCustomerState();
}

class HomeCustomerState extends State<HomeCustomer> {
  DbHelper dbHelper = DbHelper(); //konstruktor
  int count = 0;
  List<Customer> customerList;

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    if (customerList == null) {
      customerList = List<Customer>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Adopter'),
      ),
      body: Column(children: [
        Expanded(
          child: createListView(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text(
                "Tambah Adopter",
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () async {
                // membuat sistem menunggu sampai terjadi Blocking
                var customer = await navigateToEntryForm(context, null);
                // membuat sistem menunggu sampai terjadi Blocking
                if (customer != null) {
                  //TODO 2 Panggil Fungsi untuk Insert ke DB
                  int result = await dbHelper.insertCustomer(customer);
                  if (result > 0) {
                    updateListView();
                  }
                }
              },
            ),
          ),
        ),
      ]),
    );
  }

  Future<Customer> navigateToEntryForm(
      BuildContext context, Customer customer) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return FormCustomer(customer);
    }));
    return result;
  }

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.ad_units),
            ),
            title: Text(
              this.customerList[index].name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "No. Telp : " + this.customerList[index].telp,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Alamat : " + this.customerList[index].alamat,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () async {
                //TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Item
                int result =
                    await dbHelper.deleteCustomer(this.customerList[index].id);
                if (result > 0) {
                  updateListView();
                }
              },
            ),
            onTap: () async {
              var customer =
                  await navigateToEntryForm(context, this.customerList[index]);
              //TODO 4 Panggil Fungsi untuk Edit data
              int result = await dbHelper.updateCustomer(customer);
              if (result > 0) {
                updateListView();
              }
            },
          ),
        );
      },
    );
  }

  //update List item
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      //TODO 1 Select data dari DB
      Future<List<Customer>> itemListFuture = dbHelper.getCustomerList();
      itemListFuture.then((customerList) {
        setState(() {
          this.customerList = customerList;
          this.count = customerList.length;
        });
      });
    });
  }
}
