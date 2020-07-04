import React, {useEffect, useState} from 'react';
import './App.css';
import ReactPivot from './rp/index';

var Emitter = require('wildemitter')


const TextWithToolTip = ({text, tooltip}) => (
  <div className="tooltip">
    {text}
    <span className="tooltiptext">{tooltip}</span>
  </div>
)
const daysOfWeek = ['Вс','Пн','Вт','Ср','Чт','Пт','Сб'];
const getToolTipText = (row) => {
  const {P, F, C, K, FBR, SGR} = row;
  return [`Б: ${P}`, `Ж: ${F}`, `У: ${C}`, `клтч.: ${FBR}`,`схр.: ${SGR}`,`Ккал ${K}`].join(';\n');
}


const getDateFromStr = (dStr) => {
  const [dd, mm, yyyy] = dStr.split('.')
  const d = new Date(yyyy, mm - 1, dd);
  return d;
}

const getWeekFromDate = (d) => {
  return ISO8601_week_no(d);
}

const getWeekFromDStr = (dStr) => {
  const d = getDateFromStr(dStr);
  return ISO8601_week_no(d);
}

const ISO8601_week_no = (dt) => {
  var tdt = new Date(dt.valueOf());
  var dayn = (dt.getDay() + 6) % 7;
  tdt.setDate(tdt.getDate() - dayn + 3);
  var firstThursday = tdt.valueOf();
  tdt.setMonth(0, 1);
  if (tdt.getDay() !== 4) {
    tdt.setMonth(0, 1 + ((4 - tdt.getDay()) + 7) % 7);
  }
  return 1 + Math.ceil((firstThursday - tdt) / 604800000);
}

var dimensions = [
  {
    value: (row) => {
      return getDateFromStr(row['date']);      
    },
    sortBy: (row) => { return getDateFromStr(row['date']).getTime() }, 
    title: 'Дата',
    template: (val, row) => {
      const dStr = row['date'];
      const d = new Date(val);
      const day = d.getDay();
      const dayOfWeek = daysOfWeek[day];
      return `${dStr}, ${dayOfWeek}`;
    }
  },
  {value: 'meal', title: 'Прием'},
  {
    value: 'product', 
    title: 'Продукт', 
    template: (val, row) => <TextWithToolTip text={`${row['Продукт']}`} tooltip={getToolTipText(row)}/>
  },
  {
    title: 'Неделя',
    value: (row) => getWeekFromDStr(row.date) ,
    className: 'alignRight',
  },
]

const emitter = new Emitter();

/*
const activeDimensions = ['Дата', 'Продукт'];

let dimsCount = activeDimensions.length;

emitter.on('activeDimensions', function (dims) {
  dimsCount = dims.length;
});
*/

const round = (num, p = 0) => {
  const exp = Math.pow(10, p);
  return Math.round(num*exp)/exp;
};
const parse = (val = '0') => parseFloat(val.replace(',','.'));
const reduce = function(row, memo) {
  const {M, Pg, Fg, Cg, FBRg, SGRg, Kcal} = row;
  memo.count = 1;
  memo.kcal = (memo.kcal || 0) + parse(Kcal);
  memo.m = (memo.m || 0) + parse(M);
  memo.p = (memo.p || 0) + parse(Pg);
  memo.f = (memo.f || 0) + parse(Fg);
  memo.c = (memo.c || 0) + parse(Cg);

  memo.fbr = (memo.fbr || 0) + parse(FBRg);
  memo.sgr = (memo.sgr || 0) + parse(SGRg);

  memo.calcP = /*(memo.calcP || 0) */  memo.p * 4;
  memo.calcF = /*(memo.calcF || 0) */  memo.f * 9;
  memo.calcC = /*(memo.calcC || 0) */  memo.c * 4;
  memo.calcAll = /*(memo.calcAll || 0) */ memo.calcP + memo.calcF + memo.calcC;
  memo.percP = /*(memo.percP || 0) */ memo.calcP/memo.calcAll*100;
  memo.percF = /*(memo.percF || 0) */ memo.calcF/memo.calcAll*100;
  memo.percC = /*(memo.percC || 0) */ memo.calcC/memo.calcAll*100;
  return {...memo, ...row}
}

const calculations = [
  {
    title: 'М г',
    value: (row) => `${round(row.m)} г.`,
    className: 'alignRight',
    sortBy: (row) => row.m,
  },

  {
    title: 'Б г, %',
    value: (row) => row.p,
    className: 'alignRight',
    template: (val, row) => `${round(row.p)} г, ${round(row.percP)}%`,
    sortBy: (row) => row.p,
  },

  {
    title: 'Ж г, %',
    value: (row) => row.f,
    className: 'alignRight',
    template: (val, row) => `${round(row.f)} г, ${round(row.percF)}%`,
    sortBy: (row) => row.f,
  },

  {
    title: 'У г, %',
    value: (row) => row.c,
    template: (val, row) => `${round(row.c)} г, ${round(row.percC)}%`,
    className: 'alignRight',
    sortBy: (row) => row.c,
  },

  {
    title: 'Клтч. г',
    value: (row) => row.fbr,
    template: (val, row) => `${round(row.fbr, 1)} г`,
    className: 'alignRight',
    sortBy: (row) => row.fbr,
  },

  {
    title: 'Схр. г',
    value: (row) => row.sgr,
    template: (val, row) => `${round(row.sgr, 1)} г`,
    className: 'alignRight',
    sortBy: (row) => row.sgr,
  },

  {
    title: 'Ккал',
    value: (row) => row.kcal,
    template: (val, row) => `${round(row.kcal)}`,
    className: 'alignRight',
    sortBy: (row) => row.kcal,
  },
  
  /*
  {
    title: 'Amount',
    value: 'amountTotal',
    template: function(val, row) {
      return '$' + val.toFixed(2)
    },
    className: 'alignRight'
  },
  {
    title: 'Avg Amount',
    value: function(row) {
      return row.amountTotal / row.count
    },
    template: function(val, row) {
      return '$' + val.toFixed(2)
    },
    className: 'alignRight'
  }
  */
]
function App() {
  const [usersData, setUsersData] = useState('');
  useEffect(() => {
    fetch('https://deepreboot.firebaseio.com/food_csv.json')
    .then((response) => {
      return response.json();
    })
    .then((data) => {
      setUsersData({
        "dimmetrius": data,
      });
    });
  }, []);
  const search = (window.location.search || '').replace('?','');
  const pairs = search.split('&');
  const obj = pairs.reduce((sum, el) => {
    const [par, val] = el.split('=');
    sum[par] = val;
    return {...sum};
  }, {});
  
  const curDate = new Date();
  const curYear = curDate.getFullYear();
  const curWeek = ISO8601_week_no(curDate);
  const week = parseFloat(obj['w']) || curWeek;
  const year = parseFloat(obj['y']) || curYear;
  const user = obj['u'] || '-';

  const inp = (usersData[user] || []).filter(item => {
    const d = getDateFromStr(item.date);
    const w = getWeekFromDate(d);
    const y = d.getFullYear();
    return w === week && y === year;
  });

  const activeDimensions = ['Дата', 'Прием', 'Продукт'];
  const pivotParams = {
    rows: inp,
    eventBus: emitter,
    dimensions: dimensions, 
    calculations: calculations,
    reduce: reduce,
    activeDimensions: activeDimensions,
    nPaginateRows: 300
  }

  return (
    <div className="App">
    <h3>{`Дневник питания на ${week} неделе ${year}-го года`}</h3>
    <ReactPivot {...pivotParams} />
    </div>
  );
}

export default App;
