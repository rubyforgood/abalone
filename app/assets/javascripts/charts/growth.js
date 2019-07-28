var GrowthChart = function (element, data) {
  this.element = element;
  this.chart = Highcharts.chart('chart', {
    title: {
      text: 'Growth Histogram For Measurement ' + data.processed_file_id
    },
    xAxis: [{
      title: {text: 'Data'},
      alignTicks: false
    }, {
      title: {text: 'Histogram'},
      alignTicks: false,
      opposite: true
    }],

    yAxis: [{
      title: {text: 'Data'}
    }, {
      title: {text: 'Histogram'},
      opposite: true
    }],

    series: [{
      name: 'Histogram',
      type: 'histogram',
      xAxis: 1,
      yAxis: 1,
      baseSeries: 's1',
      zIndex: -1
    }, {
      name: 'Data',
      type: 'scatter',
      data: data.total_animal_lengths,
      id: 's1',
      marker: {
        radius: 1.5
      }
    }]
  });
}
