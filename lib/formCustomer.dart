import 'package:flutter/material.dart';

import 'model/customer.dart';

class FormCustomer extends StatefulWidget {
  final Customer customer;
  FormCustomer(this.customer);

  @override
  FormCustomerState createState() => FormCustomerState(this.customer);
}

//class controller
class FormCustomerState extends State<FormCustomer> {
  Customer customer;
  FormCustomerState(this.customer);
  TextEditingController nameCustomerController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController telpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //kondisi
    if (customer != null) {
      nameCustomerController.text = customer.nameCustomer;
      alamatController.text = customer.alamat;
      telpController.text = customer.telp;
    }
    //rubah
    return Scaffold(
        appBar: AppBar(
          title: customer == null ? Text('Tambah') : Text('Ubah'),
          leading: Icon(Icons.keyboard_arrow_left),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
              // nama
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: nameCustomerController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nama Adopter',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),

              // alamat
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: alamatController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Alamat Rumah',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),

              // telepon
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: telpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Nomor Telepon',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
                    //
                  },
                ),
              ),

              // tombol button
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
                    // tombol simpan
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          if (customer == null) {
                            // tambah data
                            customer = Customer(
                              nameCustomerController.text,
                              alamatController.text,
                              telpController.text,
                            );
                          } else {
                            // ubah data
                            customer.nameCustomer = nameCustomerController.text;
                            customer.alamat = alamatController.text;
                            customer.telp = telpController.text;
                          }
                          // kembali ke layar sebelumnya dengan membawa objek customer
                          Navigator.pop(context, customer);
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
                    // tombol batal
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Cancel',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
