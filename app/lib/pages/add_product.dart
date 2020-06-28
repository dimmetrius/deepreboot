import 'package:app/model/auth_model.dart';
import 'package:app/model/collection_model.dart';
import 'package:app/model/data_provider.dart';
import 'package:app/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddProductPage extends StatefulWidget {
  final String title = 'FOOD.REBOOT';
  @override
  State<StatefulWidget> createState() => AddProductPageState();
}

class AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isNew = true;
    CollectionModel<Product> productsModel =
        Provider.of<CollectionModel<Product>>(context);
    AuthModel auth = Provider.of<AuthModel>(context);
    Product product = ModalRoute.of(context).settings.arguments;
    if (product != null) {
      isNew = false;
    } else {
      product = Product();
    }

    TextEditingController _nameController =
        TextEditingController(text: product.name ?? '');
    TextEditingController _protController =
        TextEditingController(text: strNumFromDouble(product.protein));
    TextEditingController _fatController =
        TextEditingController(text: strNumFromDouble(product.fat));
    TextEditingController _carbController =
        TextEditingController(text: strNumFromDouble(product.carb));
    TextEditingController _sugController =
        TextEditingController(text: strNumFromDouble(product.sugar));
    TextEditingController _fibController =
        TextEditingController(text: strNumFromDouble(product.fibers));
    TextEditingController _kkalController =
        TextEditingController(text: strNumFromDouble(product.kkal));

    return Scaffold(
        appBar: AppBar(
          title: Text(isNew ? 'NEW' : 'EDIT' + ' PRODUCT'),
        ),
        body: Form(
            key: _formKey,
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _nameController,
                        decoration:
                            const InputDecoration(labelText: 'Product name'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Enter Product name plese';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _protController,
                        decoration:
                            const InputDecoration(labelText: 'Proteins'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Enter Proteins plese';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _fatController,
                        decoration: const InputDecoration(labelText: 'Fats'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Enter Fats plese';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _carbController,
                        decoration: const InputDecoration(labelText: 'Carbs'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Enter Carbs plese';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _sugController,
                        decoration: const InputDecoration(labelText: 'Sugar'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Enter Sugar plese';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _fibController,
                        decoration: const InputDecoration(labelText: 'Fibers'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Enter Fibers plese';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _kkalController,
                        decoration: const InputDecoration(labelText: 'KCal'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Enter KCal plese';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            color: greenPrimary,
                            child: Text('CANCEL'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          FlatButton(
                            color: greenPrimary,
                            child: Text('SAVE'),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                product
                                  ..id = product.id ?? Uuid().v4()
                                  ..creatorID =
                                      product.creatorID ?? auth.user.uid
                                  ..name = _nameController.text
                                  ..protein = toDouble(_protController.text)
                                  ..fat = toDouble(_fatController.text)
                                  ..carb = toDouble(_carbController.text)
                                  ..sugar = toDouble(_sugController.text)
                                  ..fibers = toDouble(_fibController.text)
                                  ..kkal = toDouble(_kkalController.text);

                                if (isNew) {
                                  productsModel.addRecordWithId(
                                      product, product.id);
                                } else {
                                  productsModel.update(product, product.id);
                                }

                                Navigator.of(context).pop();
                              }
                            },
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
