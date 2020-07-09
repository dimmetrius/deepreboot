const {gql} = require('apollo-server-express');
const typeDefs = gql`
type User {
  id: String!
  login: String!
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
  product: Product!
  weight: Float
}

type Receipt {
  id: String!
  name: String!
  description: String
  kkal: Float
  protein: Float
  fat: Float
  carb: Float
  creator: User
  weight: Float
  weightUnit: WeightUnit
  entries: [ReceiptEntry]
  steps: [String]
}

type Product {
  id: String!
  manufacturer: Manufacturer
  kkal: Float
  protein: Float
  fat: Float
  carb: Float
  receipt: Receipt
  creator: User
}

type Meal {
  id: String!
  time: Int
  product: Product
  weight: Float
  weightUnit: WeightUnit
  user: User
}

type YesNoQuestion {
  id: String!
  text: String!
  rightAns: YesNoAnswerEnum
}

enum YesNoAnswerEnum {
  Yes
  No
}

type YesNoAnswer {
  id: String!
  question: YesNoQuestion!
}

type FirstSecondQuestion {
  id: String!
  text: String!
  firstDescr: String!
  secondDescr: String!
  picUrl1: String
  picUrl2: String
}

enum FirstSecondAnswerEnum {
  First
  Second
}

type FirstSecondAnswer {
  id: String!
  question: FirstSecondQuestion
  answer: FirstSecondAnswerEnum
}

union Question = YesNoQuestion
union Answer = YesNoAnswer | FirstSecondAnswer

type GameLevel {
  id: String!
  npp: Int
  questions: [Question]
  answers: [Answer]
}

type Game {
  levels: [GameLevel]
}

input Filter {
  key: String!
}

type Query {
  getGame : Game
  products(filters: [Filter]) : [Product]
}
`;

module.exports = typeDefs;
