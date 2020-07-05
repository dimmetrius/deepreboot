double toDouble(dynamic i) {
  String _i = i.toString();
  return double.tryParse(_i) ?? 0.0;
}

String strNumFromDouble(double n, [int digits = 0]) {
  double _n = n ?? 0;
  _n = _n.isNaN ? 0 : _n;
  return _n.toStringAsFixed(digits);
}
