import 'package:app/model/auth_model.dart';
import 'package:app/model/collection_model.dart';
import 'package:app/model/data_provider.dart';
import 'package:app/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddMealPage extends StatefulWidget {
  final String title = 'FOOD.REBOOT';
  @override
  State<StatefulWidget> createState() => AddMealPageState();
}

class AddMealPageState extends State<AddMealPage> {
  showAddDialog(BuildContext context, Product product) async {
    AuthModel auth = Provider.of<AuthModel>(context, listen: false);
    CollectionModel<Meal> mealsModel =
        Provider.of<CollectionModel<Meal>>(context, listen: false);
    WhereFilter qf = mealsModel.getFilterByName('startTs');
    DateTime _dateTime =
        DateTime.fromMillisecondsSinceEpoch(qf.isGreaterThanOrEqualTo);
    final TextEditingController _weightController = TextEditingController();
    Meal addMeal = await showDialog<Meal>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: AspectRatio(
              aspectRatio: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(product.name),
                  Row(
                    children: [
                      Expanded(
                          //height: 50.0,
                          //width: 50.0,
                          child: TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        controller: _weightController,
                        decoration: const InputDecoration(labelText: 'Weight'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Weight';
                          }
                          return null;
                        },
                      )),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                  child: Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  }),
              FlatButton(
                  child: Text(
                    "SAVE",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    double weight =
                        double.tryParse(_weightController?.text) ?? 0.0;
                    if (weight == 0.0) return;
                    Navigator.of(context).pop(
                      Meal(
                        id: Uuid().v4(),
                        creatorID: auth.user.uid,
                        productID: product.id,
                        time: getDateStartTs(_dateTime),
                        weight: weight,
                        name: product.name,
                        kkal: weight / 100 * product.kkal,
                        protein: weight / 100 * product.protein,
                        fat: weight / 100 * product.fat,
                        carb: weight / 100 * product.carb,
                        sugar: weight / 100 * product.sugar,
                        fibers: weight / 100 * product.fibers,
                      ),
                    );
                  }),
            ],
          );
        });
    if (addMeal != null) {
      print(addMeal.toMap());
      await mealsModel.addRecordWithId(addMeal, addMeal.id);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionModel<Product> productsModel =
        Provider.of<CollectionModel<Product>>(context);
    List<Product> products = productsModel.records;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'ALL'),
              Tab(text: 'PRESETS'),
              Tab(text: 'MY'),
            ],
          ),
          title: Text('Product list'),
        ),
        body: TabBarView(
          children: [
            CustomScrollView(
              slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Product p = products[index];
                    return GestureDetector(
                      child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 10),
                          height: 90.0,
                          child: Row(
                            children: <Widget>[
                              Container(
                                  width: 90.0,
                                  height: 90.0,
                                  child: Center(
                                    child: Icon(Icons.fastfood),
                                  )),
                              Expanded(
                                child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(p.name),
                                      Text('P: ' +
                                          p.protein.toString() +
                                          ', F: ' +
                                          p.fat.toString() +
                                          ', C: ' +
                                          p.carb.toString()),
                                      Text('Sug: ' +
                                          p.sugar.toString() +
                                          ', Fib: ' +
                                          p.fibers.toString())
                                    ]),
                              ),
                              Container(
                                  width: 90.0,
                                  height: 90.0,
                                  child: Center(
                                    child: Text(p.kkal.toString() + ' kkal'),
                                  )),
                            ],
                          )),
                      onTap: () {
                        showAddDialog(context, p);
                      },
                    );
                    /*
                return ListTile(
                  /*
                  leading: Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Icon(Icons.label),
                    ),
                  ),
                  */
                  trailing: Text(meal.m + 'g'),
                  title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(meal.product),
                        Text('Б: '+meal.pg+', Ж: '+meal.fg+', У: ' + meal.cg),
                        Text(meal.kkal + ' kkal')
                      ]),
                );
                */
                  },

                  /// Set childCount to limit no.of items
                  childCount: products.length,
                )),
              ],
            ),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
