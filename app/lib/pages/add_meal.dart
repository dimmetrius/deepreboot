import 'package:app/model/collection_model.dart';
import 'package:app/model/data_provider.dart';
import 'package:app/utils/add_meal_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddMealPage extends StatefulWidget {
  final String title = 'FOOD.REBOOT';
  @override
  State<StatefulWidget> createState() => AddMealPageState();
}

class AddMealPageState extends State<AddMealPage> {
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
              Tab(text: 'RECEIPTS'),
            ],
          ),
          title: Text('PRODUCTS'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              iconSize: 35,
              onPressed: () {
                Navigator.of(context).pushNamed('/addproduct', arguments:null);
              },
            )
          ],
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
                        showEditMealDialog(context, p, null);
                      },
                      onLongPress: (){
                        Navigator.of(context).pushNamed('/addproduct', arguments: p);
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
            Center(child: Text('IN DEVELOPMENT')),
            Center(child: Text('IN DEVELOPMENT')),
          ],
        ),
      ),
    );
  }
}
