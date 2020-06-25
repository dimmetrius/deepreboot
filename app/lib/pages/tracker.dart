import 'package:app/components/app_drawer.dart';
import 'package:app/model/collection_model.dart';
import 'package:app/model/data_provider.dart';
import 'package:app/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrackerPage extends StatefulWidget {
  final String title = 'FOOD.REBOOT';
  @override
  State<StatefulWidget> createState() => TrackerPageState();
}

// final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
Product findProductById(List<Product> products, String id) {
  Product p = products.firstWhere((element) {
    print(element.id);
    return element.id == id;
  }, orElse: () => null);
  print([id, p?.id, p?.name]);
  return p;
}

class TrackerPageState extends State<TrackerPage> {
  Map<String, Meal> selected = Map<String, Meal>();

  addToSelected(Meal meal) {
    setState(() {
      if (selected.containsKey(meal.id)) {
        selected.remove(meal.id);
      } else {
        selected[meal.id] = meal;
      }
    });
  }

  editSelected(BuildContext context){

  }

  deleteSelected(BuildContext context) {
    CollectionModel<Meal> mealsModel =
        Provider.of<CollectionModel<Meal>>(context, listen: false);
    selected.forEach((key, value) {
      mealsModel.remove(key);
    });
    selected.clear();
  }

  @override
  Widget build(BuildContext context) {
    CollectionModel<Meal> mealsModel =
        Provider.of<CollectionModel<Meal>>(context);
    WhereFilter qf = mealsModel.getFilterByName('startTs');
    DateTime _dateTime =
        DateTime.fromMillisecondsSinceEpoch(qf.isGreaterThanOrEqualTo);
    CollectionModel<Product> productsModel =
        Provider.of<CollectionModel<Product>>(context);
    List<Meal> mymeals = mealsModel.records;
    List<Widget> actions = [];
    if(selected.length == 1){
      actions.add(IconButton(
                icon: Icon(Icons.edit),
                iconSize: 35,
                onPressed: () => editSelected(context)));
    }
    if(selected.length > 0){
      actions.add(IconButton(
                icon: Icon(Icons.delete),
                iconSize: 35,
                onPressed: () => deleteSelected(context)));
    }
    actions.add(SizedBox(
              width: 10,
            ));
    return Scaffold(
      //key: scaffoldKey,
      drawer: AppDrawer('/tracker'),
      appBar: AppBar(
          actions: actions,
          title: new Theme(
            data: Theme.of(context),
            child: new Builder(
              builder: (context) => GestureDetector(
                child: Column(children: <Widget>[
                  Text('Diary'),
                  Text(
                    DateFormat('dd.MM.yyyy').format(_dateTime),
                    style: TextStyle(fontSize: 20.0),
                  ),
                ]),
                onTap: () => showDatePicker(
                        context: context,
                        initialDate:
                            _dateTime == null ? DateTime.now() : _dateTime,
                        firstDate: DateTime(2001),
                        lastDate: DateTime(2021))
                    .then((value) => {
                          if (value != null)
                            {
                              mealsModel.setFilters([
                                WhereFilter('startTs', 'time',
                                    isGreaterThanOrEqualTo:
                                        getDateStartTs(value)),
                                WhereFilter('endTs', 'time',
                                    isLessThanOrEqualTo: getDateEndTs(value)),
                              ])
                            }
                        }),
              ),
            ),
          )),
      body: Container(
          child: CustomScrollView(
        slivers: <Widget>[
          ///First sliver is the App Bar
          SliverAppBar(
            leading: Container(width: 0.0),
            // Allows the user to reveal the app bar if they begin scrolling back
            // up the list of items.
            floating: true,
            // Display a placeholder widget to visualize the shrinking size.
            flexibleSpace: Container(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                alignment: FractionalOffset.center,
                child: SingleChildScrollView(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CircleAvatar(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('100%'),
                              Text('Prots', style: TextStyle(fontSize: 10.0))
                            ],
                          ),
                          radius: 30.0,
                          backgroundColor: Colors.red[300],
                        ),
                        CircleAvatar(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('100%'),
                              Text('Fats', style: TextStyle(fontSize: 10.0))
                            ],
                          ),
                          radius: 30.0,
                          backgroundColor: Colors.green,
                        ),
                        CircleAvatar(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('100%'),
                              Text('Carbs', style: TextStyle(fontSize: 10.0))
                            ],
                          ),
                          radius: 30.0,
                          backgroundColor: Colors.orange,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'SUM KKAL',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )),
              ),
            ),
            // Make the initial height of the SliverAppBar larger than normal.
            expandedHeight: 100,
          ),
          SliverList(
            ///Use SliverChildListDelegate and provide a list
            ///of widgets if the count is limited
            ///
            ///Lazy building of list
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                /// To convert this infinite list to a list with "n" no of items,
                /// uncomment the following line:
                /// if (index > n) return null;
                Meal meal = mymeals[index];
                return GestureDetector(
                  child: Container(
                      color: selected.containsKey(meal.id)
                          ? Colors.yellow[200]
                          : Colors.white,
                      height: 90.0,
                      padding: EdgeInsets.symmetric(vertical: 10),
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(meal.name),
                                  Text('P: ' +
                                      meal.protein.toStringAsFixed(2) +
                                      ', F: ' +
                                      meal.fat.toStringAsFixed(2) +
                                      ', C: ' +
                                      meal.carb.toStringAsFixed(2)),
                                  Text('Sug: ' +
                                      meal.sugar.toStringAsFixed(2) +
                                      ', Fib: ' +
                                      meal.fibers.toStringAsFixed(2)),
                                  Text(meal.kkal.toStringAsFixed(0) + ' kkal')
                                ]),
                          ),
                          Container(
                              width: 90.0,
                              height: 90.0,
                              child: Center(
                                child: Text(meal?.weight?.toStringAsFixed(2) ??
                                    "0" + ' g'),
                              )),
                        ],
                      )),
                  onTap: () => addToSelected(meal),
                );
              },

              /// Set childCount to limit no.of items
              childCount: mymeals.length,
            ),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/addmeal');
          /*
          showModalBottomSheet<String>(
              context: context,
              builder: (BuildContext context) => Container(
                    height: 200.0,
                    child: Text('bottom'),
                    color: Colors.red,
                  ));
          */
        },
        tooltip: 'Refresh',
        child: Icon(Icons.add),
      ),
    );
  }
}
