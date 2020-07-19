const {gql} = require('apollo-server-express');

const filterGenerator = (tp) => {
  return `
  "where filter for ${tp} definition"
  input ${tp}Filter {
    isEqualTo: ${tp}
    isLessThan: ${tp}
    isLessThanOrEqualTo: ${tp}
    isGreaterThan: ${tp}
    isGreaterThanOrEqualTo: ${tp}
    isInValues: [${tp}]
  }
  `;
};

const typeDefs = gql`

# A type that describes the user
type User {
  id: String!
  login: String
  name: String
  email: String
  phone: String
}

type Manufacturer {
  id: String!
  name: String!
}

enum WeightUnit {
  G
  KG
  LBS
  piece
  serving
}

type ReceiptEntry {
  id: String!
  food: Food!
  kkal: Float!
  protein: Float!
  fat: Float!
  carb: Float!
  sugar: Float!
  weight: Float!
  weightUnit: WeightUnit!
}

type Receipt {
  id: String!
  ts: Int!
  name: String!
  description: String
  kkal: Float!
  protein: Float!
  fat: Float!
  carb: Float!
  sugar: Float!
  weight: Float!
  weightUnit: WeightUnit!
  entries: [ReceiptEntry]!
  creator: User!
}

"A type that describes the Product"
type Product {
  id: String!
  ts: Int!
  name: String!
  manufacturer: Manufacturer
  kkal: Float!
  protein: Float!
  fat: Float!
  carb: Float!
  sugar: Float!
  fibers: Float!
  creator: User!
}

union Food = Receipt | Product

type Meal {
  id: String!
  ts: Int!
  name: String!
  time: Int
  kkal: Float!
  protein: Float!
  fat: Float!
  carb: Float!
  sugar: Float!
  fibers: Float!
  food: Food
  weight: Float
  weightUnit: WeightUnit
  user: User
}

${filterGenerator('Float')}
${filterGenerator('Int')}
${filterGenerator('String')}

input ProductsWhereFilter {
  id: StringFilter
  kkal: FloatFilter
}

input MealsWhereFilter {
  id: StringFilter
}

type Query {
  products(where: [ProductsWhereFilter]!) : [Product]
  meals(where: [MealsWhereFilter]) : [Meal]
}
`;

module.exports = typeDefs;
