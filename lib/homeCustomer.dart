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
        title: Text('Daftar Adopter', style: TextStyle(fontSize: 16)),
      ),
      body: Column(
        children: [
          Expanded(
            child: createListView(),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: RaisedButton(
                color: Colors.lightGreen,
                child: Text(
                  "Tambah Adopter",
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  // membuat sistem menunggu sampai terjadi Blocking
                  var customer = await navigateToFormCustomer(context, null);
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
        ],
      ),
    );
  }

  Future<Customer> navigateToFormCustomer(
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
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepOrangeAccent,
              child: Icon(Icons.party_mode),
            ),
            title: Text(
              this.customerList[index].nameCustomer,
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  this.customerList[index].telp,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
                Text(
                  this.customerList[index].alamat,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () async {
                //TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Customer
                int result =
                    await dbHelper.deleteCustomer(this.customerList[index].id);
                if (result > 0) {
                  updateListView();
                }
              },
            ),
            onTap: () async {
              var customer = await navigateToFormCustomer(
                  context, this.customerList[index]);
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

  //update List customer
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      //TODO 1 Select data dari DB
      Future<List<Customer>> customerListFuture = dbHelper.getCustomerList();
      customerListFuture.then((customerList) {
        setState(() {
          this.customerList = customerList;
          this.count = customerList.length;
        });
      });
    });
  }
}
