import 'package:app/components/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum WeightUnit { G }

class User {
  String id;
}

class Product {
  Product({this.id, this.name});
  String id;
  String name;
  /*
  id: String!
  manufacturer: Manufacturer
  kkal: double
  protein: double
  fat: double
  carb: double
  receipt: Receipt
  creator: User
  */
}

class Meal {
  Meal(
      {this.id,
      this.time,
      this.product,
      this.weight,
      this.weigthUnit = WeightUnit.G,
      this.user});
  String id;
  DateTime time;
  Product product;
  double weight;
  WeightUnit weigthUnit;
  User user;
}

class TrackerPage extends StatefulWidget {
  final String title = 'FOOD.REBOOT';
  @override
  State<StatefulWidget> createState() => TrackerPageState();
}

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class TrackerPageState extends State<TrackerPage> {
  DateTime _dateTime = DateTime.now();
  static Product grecha = Product(id: 'id', name: 'Гречка');
  List<Meal> meals = [
    Meal(id: '0', time: DateTime.now(), product: grecha, weight: 100.0),
    Meal(id: '1', time: DateTime.now(), product: grecha, weight: 200.0),
    Meal(id: '2', time: DateTime.now(), product: grecha, weight: 300.0),
  ];
  @override
  Widget build(BuildContext context) {
    print(_dateTime);
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
                          })
                        }
                    }),
          ),
        ),
      )),
      body: Container(
        child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.black54,
                ),
            itemCount: meals.length,
            itemBuilder: (context, index) => ListTile(
                  leading: Expanded(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Icon(Icons.label),
                    ),
                  ),
                  trailing: Text(meals[index].weight.toInt().toString() + 'g'),
                  title: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(meals[index].product.name),
                        Text('Б: 33, Ж: 33, У: 44'),
                        Text('100 ккал')
                      ]),
                )),
      ),
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
