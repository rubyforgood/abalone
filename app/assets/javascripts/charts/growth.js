var GrowthChart = function (element, data) {
  this.element = element;
  this.chart = Highcharts.chart('chart', {
    title: {
      text: 'Growth Histogram For Measurement ' + data.processed_file_id
    },
    xAxis: [{
      title: {text: 'Length (cm)'},
    }],

    yAxis: [{
      title: {text: 'Count'}
    }],

    series: [
      {
        visible:false,
        showInLegend:false,
        id:"id1",
        data: data.total_animal_lengths
      },
      {
        name: 'Histogram',
        type: 'histogram',
        showInLegend:false,
        baseSeries: "id1",
    }]
  });
}
