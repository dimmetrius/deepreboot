import 'package:app/model/auth_model.dart';
import 'package:app/model/collection_model.dart';
import 'package:app/model/data_provider.dart';
import 'package:app/utils/app_theme.dart';
import 'package:app/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

showEditMealDialog(BuildContext context, Product product, Meal meal,
    [int num = 0]) async {
  bool isNew = true;
  if (meal != null) {
    isNew = false;
  }
  Meal editMeal = meal ?? new Meal(num: num);
  AuthModel auth = Provider.of<AuthModel>(context, listen: false);
  CollectionModel<Meal> mealsModel =
      Provider.of<CollectionModel<Meal>>(context, listen: false);
  WhereFilter qf = mealsModel.getFilterByName('startTs');
  DateTime _dateTime =
      DateTime.fromMillisecondsSinceEpoch(qf.isGreaterThanOrEqualTo);
  final TextEditingController _weightController =
      TextEditingController(text: meal?.weight?.toStringAsFixed(0) ?? '');
  ValueNotifier<int> numNotifier = ValueNotifier<int>(editMeal?.num ?? 0);
  Meal addMeal = await showDialog<Meal>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: AspectRatio(
            aspectRatio: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      autofocus: false,
                      readOnly: true,
                      controller: TextEditingController(text: product.name),
                      decoration: const InputDecoration(labelText: 'Product'),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
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
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: numNotifier,
                        builder: (context, n, child) {
                          return DropdownButton<int>(
                            focusColor: Colors.red,
                            value: n,
                            icon: Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black),
                            underline: Container(
                              height: 2,
                              color: greenPrimary,
                            ),
                            onChanged: (int newValue) {
                              numNotifier.value = newValue;
                            },
                            items: <int>[0, 1, 2, 3, 4]
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(mealNums[value]),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ],
                )
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
                  editMeal
                    ..id = editMeal.id ?? Uuid().v4()
                    ..creatorID = auth.user.uid
                    ..productID = product.id
                    ..num = numNotifier.value
                    ..time = getDateStartTs(_dateTime)
                    ..weight = weight
                    ..name = product.name
                    ..kkal = weight / 100 * product.kkal
                    ..protein = weight / 100 * product.protein
                    ..fat = weight / 100 * product.fat
                    ..carb = weight / 100 * product.carb
                    ..sugar = weight / 100 * product.sugar
                    ..fibers = weight / 100 * product.fibers;
                  Navigator.of(context).pop(editMeal);
                }),
          ],
        );
      });
  if (addMeal != null) {
    print(addMeal.toMap());
    if (isNew) {
      await mealsModel.addRecordWithId(addMeal, addMeal.id);
      Navigator.of(context).pop();
    } else {
      await mealsModel.update(addMeal, addMeal.id);
    }
  }
}
