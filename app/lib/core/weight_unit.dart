enum WeightUnit { G, KG, LBS }
WeightUnit parseWeightUnit(String wu) {
  switch (wu) {
    case 'G':
      return WeightUnit.G;
    case 'KG':
      return WeightUnit.KG;
    case 'LBS':
      return WeightUnit.LBS;
    default:
      return null;
  }
}

String weightUnitToStr(WeightUnit wu) {
  switch (wu) {
    case WeightUnit.G:
      return 'G';
    case WeightUnit.KG:
      return 'KG';
    case WeightUnit.LBS:
      return 'LBS';
    default:
      return null;
  }
}
