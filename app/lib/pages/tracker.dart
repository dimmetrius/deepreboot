import 'package:app/components/app_drawer.dart';
import 'package:app/model/collection_model.dart';
import 'package:app/model/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TrackerPage extends StatefulWidget {
  final String title = 'FOOD.REBOOT';
  @override
  State<StatefulWidget> createState() => TrackerPageState();
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class TrackerPageState extends State<TrackerPage> {
  DateTime _dateTime = DateTime.now();
  List<JsonMeal> mymeals = [];
  List<int> pfc = [0, 0, 0];

  @override
  void initState() {
    initJson();
    super.initState();
  }

  initJson() async {
    await loadJson(context);
    getMeals();
  }

  getMeals() {
    setState(() {
      mymeals = meals
          .where((el) => DateFormat('dd.MM.yyyy').format(_dateTime) == el.date)
          .toList();
      pfc = [0, 0, 0];
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionModel<Meal> mealsModel = Provider.of<CollectionModel<Meal>>(context);
    CollectionModel<Product> productsModel = Provider.of<CollectionModel<Product>>(context);
    List<Meal> mymeals = mealsModel.records;
    List<Product> products = productsModel.records;
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer('/tracker'),
      appBar: AppBar(
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
                    initialDate: _dateTime == null ? DateTime.now() : _dateTime,
                    firstDate: DateTime(2001),
                    lastDate: DateTime(2021))
                .then((value) => {
                      if (value != null)
                        {
                          setState(() {
                            _dateTime = value;
                            getMeals();
                          })
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
                child:  SingleChildScrollView(child: Column(
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
                return Container(
                    height: 90.0,
                    child: Row(
                      children: <Widget>[
                        Container(
                            width: 90.0,
                            height: 90.0,
                            child: Center(
                              child: Text('*'),
                            )),
                        Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(meal.id),
                                Text('Б: ' +
                                    '0' +
                                    ', Ж: ' +
                                    '0' +
                                    ', У: ' +
                                     '0'),
                                Text('0' + ' kkal')
                              ]),
                        ),
                        Container(
                            width: 90.0,
                            height: 90.0,
                            child: Center(
                              child: Text('0' + 'g'),
                            )),
                      ],
                    ));
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
              childCount: mymeals.length,
            ),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<String>(
              context: context,
              builder: (BuildContext context) => Container(
                    height: 200.0,
                    child: Text('bottom'),
                    color: Colors.red,
                  ));
        },
        tooltip: 'Refresh',
        child: Icon(Icons.add),
      ),
    );
  }
}
