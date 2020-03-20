var GrowthChart = function (element, data) {
  this.element = element;
  this.chart = Highcharts.chart('chart', {
    title: {
      text: '' //'Growth Histogram For Measurement ' + data.processed_file_id
    },
    xAxis: {
      title: {text: 'Length (cm)'},
      tickInterval: 1,
    },
    yAxis: {
      title: {text: 'Count'},
    },
    series: [
      {
        visible:false,
        showInLegend:false,
        id:"id1",
        data: data.total_animal_lengths,
        color: '#FF0000'
      },
      {
        name: 'Count',
        type: 'histogram',
        showInLegend:false,
        baseSeries: "id1",
        binWidth: 1.0,
        tooltip: {
          pointFormat: '<b>{series.name}: {point.y}</b><br/>{point.x}-{point.x}.99 cm',
          shared: true
      }
    }]
  });
}
