var SpawningChart = function(element) {
  this.element = element;
  this.chart   = Highcharts.chart('chart', {
    chart: {
      type: 'column'
    },
    title: {
      text: 'Animals Spawned by Year'
    },
    xAxis: {
      categories: ['2015', '2016', '2017', '2018', '2019']
    },
    yAxis: {
      title: {
        text: '# of Animals'
      }
    },
    series: [
      {
        name: 'BML',
        data: [120, 88, 246, 275, 182]
      }, 
      {
        name: 'TAF',
        data: [75, 100, 90, 108, 117]
      },
      {
        name: 'UCSB',
        data: [177, 80, 92, 120, 155]
      }
    ]
  });
}
