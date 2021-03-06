import 'package:flutter/material.dart';
import 'package:sqflite_demo/data/db_helper.dart';
import 'package:sqflite_demo/models/product.dart';

class ProductDetail extends StatefulWidget{
  late Product product;
  ProductDetail(this.product);
  @override
  State<StatefulWidget> createState() {
    return _ProductDetailState(product);
  }
}
enum Options{delete,update}

class _ProductDetailState extends State{
  late Product product;
  _ProductDetailState(this.product);
  var dbHelper = DbHelper();
  var txtId= TextEditingController();
  var txtName= TextEditingController();
  var txtDescription= TextEditingController();
  var txtUnitPrice= TextEditingController();

  @override
  void initState() {  //default olarak görünüm
    txtId.text=product.id.toString();
    txtName.text=product.name;
    txtDescription.text=product.description;
    txtUnitPrice.text=product.unitPrice.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("Ürün detayı: ${product.name}"),
        actions: [
          PopupMenuButton<Options>(
            onSelected: selectProcess,
              itemBuilder: (BuildContext context)=> <PopupMenuEntry<Options>>[
                const PopupMenuItem<Options>(
                  value: Options.delete,
                  child: Text("Sil"),
                ),
                const PopupMenuItem<Options>(
                  value: Options.update,
                  child: Text("Güncelle"),
                ),
              ],
          )
        ],
      ),
      body: buildProductDetail(),
    );
  }

  buildProductDetail() {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        children: [
          buildIdField(), buildNameField(), buildDescriptionField(), buildUnitPriceField(),
        ],
      ),
    );
  }

  TextField buildIdField() {
    return TextField(
      decoration: InputDecoration(labelText: "İd"),
      controller: txtId,
    );
  }

  TextField buildNameField() {
    return TextField(
      decoration: InputDecoration(labelText: "Ürün adı"),
      controller: txtName,
    );
  }

  buildDescriptionField() {
    return TextField(
      decoration: InputDecoration(labelText: "Ürün açıklaması"),
      controller: txtDescription,
    );
  }

  buildUnitPriceField() {
    return TextField(
      decoration: InputDecoration(labelText: "Ürün birim fiyatı"),
      controller: txtUnitPrice,
    );
  }

  void selectProcess(Options value) async{
    switch(value){
      case Options.delete:
        await dbHelper.delete(product.id);
        Navigator.pop(context,true);
        break;
      case Options.update:
        await dbHelper.update(Product.withId(id:product.id, name:txtName.text, description:txtDescription.text, unitPrice:double.tryParse(txtUnitPrice.text)!));
        Navigator.pop(context,true);
        break;
      default:
    }
  }
}