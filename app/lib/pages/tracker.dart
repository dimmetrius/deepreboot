import 'package:app/components/app_drawer.dart';
import 'package:app/model/collection_model.dart';
import 'package:app/model/data_provider.dart';
import 'package:app/utils/add_meal_dialog.dart';
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
    return element.id == id;
  }, orElse: () => null);
  return p;
}

Meal findMealById(List<Meal> meals, String id) {
  Meal m = meals.firstWhere((element) {
    return element.id == id;
  }, orElse: () => null);
  return m;
}

class TrackerPageState extends State<TrackerPage> {
  Map<String, Meal> selected = Map<String, Meal>();

  bool isProcSum = false;

  addToSelected(Meal meal) {
    setState(() {
      if (selected.containsKey(meal.id)) {
        selected.remove(meal.id);
      } else {
        selected[meal.id] = meal;
      }
    });
  }

  editSelected(BuildContext context, Meal meal, Product product) {
    showEditMealDialog(context, product, meal);
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
    List<Product> products = productsModel.records;
    List<Meal> mymeals = mealsModel.records;
    double sumP = 0, sumF = 0, sumC = 0, sumK = 0, sumFib = 0, sumSug = 0;
    mymeals.forEach((element) {
      sumP += element.protein ?? 0;
      sumF += element.fat ?? 0;
      sumC += element.carb ?? 0;
      sumK += element.kkal ?? 0;
      sumSug += element.sugar ?? 0;
      sumFib += element.fibers ?? 0;
    });

    double sumKKAL = sumP*4 + sumF*9 + sumC*4;
    double percP = sumP*4/(sumKKAL/100);
    double percF = sumF*9/(sumKKAL/100);
    double percC = sumC*4/(sumKKAL/100);

    String pStr = isProcSum ? (strNumFromDouble(percP) + ' %') : (strNumFromDouble(sumP) + ' g');
    String fStr = isProcSum ? (strNumFromDouble(percF) + ' %') : (strNumFromDouble(sumF) + ' g');
    String cStr = isProcSum ? (strNumFromDouble(percC) + ' %') : (strNumFromDouble(sumC) + ' g');

    List<Widget> actions = [];
    if (selected.length == 1) {
      actions.add(IconButton(
          icon: Icon(Icons.edit),
          iconSize: 35,
          onPressed: () {
            String mealID = selected.keys.first;
            Meal meal = findMealById(mymeals, mealID);
            Product product = findProductById(products, meal.productID);
            editSelected(context, meal, product);
          }));
    }
    if (selected.length > 0) {
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
              child: GestureDetector(
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
                              Text(pStr),
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
                              Text(fStr),
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
                              Text(cStr),
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
                    /*
                    Row(children: [
                      Text('Sugars: ' + strNumFromDouble(sumSug)),
                      Text('Fibers: ' + strNumFromDouble(sumFib))
                    ],),
                    */
                    Text(
                      sumK.toStringAsFixed(0) + ' KKAL',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                )),
              ),
              onTap: (){
                setState(() {
                  isProcSum = !isProcSum;
                });
              },
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
                                child: Text(
                                    (meal?.weight?.toStringAsFixed(0) ?? "0") +
                                        ' g'),
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
