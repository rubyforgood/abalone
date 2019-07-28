var returned_data = {};
var start_date = 'Sat, 20 Jul 2019';
var end_date = 'Mon, 29 Jul 2019';
var tags = ['a', 'b', 'c'];
var population = '';

Rails.ajax({
    url: "/growth_rates?start_date="+start_date+"&end_date="+end_date+"&tags="+tags+'&population='+population,
    type: "get",
    success:{(returned_data = data) }
});


var seriesOptions = [],
    seriesCounter = 0,
    names = tags;

//seriesOptions[i] = {
//    name: name,
//    data: data
//};

var GrowthChart = function(element) {
  this.element = element;
    this.chart = Highcharts.stockChart('growth-chart', {
        rangeSelector: {
            selected: 4
        },
        yAxis: {
            labels: {
                formatter: function () {
                    return (this.value > 0 ? ' + ' : '') + this.value + '%';
                }
            },
            plotLines: [{
                value: 0,
                width: 2,
                color: 'silver'
            }]
        },

        plotOptions: {
            series: {
                compare: 'percent',
                showInNavigator: true
            }
        },

        tooltip: {
            pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b> ({point.change}%)<br/>',
            valueDecimals: 2,
            split: true
        },

        series: seriesOptions
    });
};


function name_iter(i, name) {

    $.getJSON('https://www.highcharts.com/samples/data/' + name.toLowerCase() + '-c.json',    function (data) {

        seriesOptions[i] = {
            name: name,
            data: data
        };

        // As we're loading the data asynchronously, we don't know what order it will arrive. So
        // we keep a counter and create the chart when all the data is loaded.
        seriesCounter += 1;

        if (seriesCounter === names.length) {
            createChart();
        }
    });
};


names.forEach(name_iter)
