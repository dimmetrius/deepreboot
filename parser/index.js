const fs = require('fs');
const data = fs.readFileSync('foods.csv', {encoding: 'utf8'});
const lines = data.split('\n');

let inSectionDef = false;
let sectionName = '';
let nameIndex = null;
let endIndex = null;

const isSectionStart = (line = '', index) => {
  const sectionLineStr = "#-------------------------------------------"
  const isSectionStart = sectionLineStr === line.trim();
  if(isSectionStart && !inSectionDef){
    inSectionDef = true;
    nameIndex = index + 1;
    return true;
  }
}
const iSectionName = (line = '', index) => {
  if(inSectionDef && index === nameIndex){
    sectionName = line.replace('#', '').trim();
    endIndex = index + 1;
  }
}

const iSectionEnd = (line = '', index) => {
  if(inSectionDef && endIndex === index){
    inSectionDef = false;
    //sectionName = '';
    nameIndex = null;
    endIndex = null;
  }
}

lines.forEach((line, index) => {
  isSectionStart(line, index);
  iSectionName(line, index);
  iSectionEnd(line, index);
  if('Report Details' === sectionName && !inSectionDef){
    console.log(line);
  }
});