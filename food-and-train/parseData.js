const folder = './src/'
const filename = 'food.csv';

const csv = require('csv-parser');
const fs = require('fs');
const results = [];

fs.createReadStream(folder + filename)
  .pipe(csv())
  .on('data', data => results.push(data))
  .on('end', () => {
    fs.writeFileSync(folder + filename + '.json', JSON.stringify(results))
  });
