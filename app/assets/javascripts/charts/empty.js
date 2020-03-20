var EmptyChart = function (element) {
  this.element = element;
  this.chart = Highcharts.chart('chart', {
    title: {
      text: 'Please select a measurement date or a cohort to start.' //'Growth Histogram For Measurement ' + data.processed_file_id
    },
    xAxis: {
      title: {text: 'Length (cm)'},
      tickInterval: 1,
    },
    yAxis: {
      title: {text: 'Count'},
    },
    series: []
  });
}
