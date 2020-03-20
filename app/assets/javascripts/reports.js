var Reports = (function () {
  var chart = null;
  var showChart = async function (element) {
    document.getElementsByClassName('growth-parameters')[0].classList.add('is-hidden');
    switch (element.id) {
      case 'spawning-chart':
        new SpawningChart(element);
        break;
      case 'production-chart':
        new ProductionChart(element);
        break;
      case 'mortality-chart':
        new MortalityChart(element);
        break;
      case 'growth-chart':
        //var randomFileNumber = Reports.randomFileNumber()
        var parameters = document.getElementsByClassName('growth-parameters')[0]
        parameters.classList.remove('is-hidden');

        try {
          var processed_file_id = parameters.getAttribute('data-processed-file-id')
          var measurementDate = parameters.getAttribute('data-measurement-date')
          var shlCaseNumber = parameters.getAttribute('data-case-number')
          var response = await fetch('reports/lengths/' + processed_file_id + '?date=' + measurementDate + '&shl_case_number=' + shlCaseNumber)
          var growthReportData = await response.json();
          new GrowthChart(element, growthReportData);
        } catch(e) {
          new EmptyChart(element);
          // alert(`Could not retrieve any data for file.`)
        }
        break;
      default:
        console.log("Unknown chart type " + element.id);
    }
  };

  return {
    showChart: showChart
  };
})();

// TODO: get id of a specific measurement.
// var currentFile = 0
// Reports.randomFileNumber = function() {
//   if (currentFile >= 4) currentFile = 0
//   return ++currentFile
// }

document.addEventListener('DOMContentLoaded', function () {
  if (document.getElementById('chart') === null) return;

  var tabs = document.querySelectorAll('.tabs li');

  for (var i = 0; i < tabs.length; i++) {
    tabs[i].addEventListener('click', function () {
      // if (this.classList.contains('is-active')) return;

      for (var i = 0; i < tabs.length; i++) {
        if (tabs[i] !== this) {
          tabs[i].classList.remove('is-active');
        }
      }

      this.classList.toggle('is-active');

      Reports.showChart(this);
    });
  }

  Reports.showChart(document.querySelectorAll('.tabs .is-active')[0]);

  // Add cohort filter dropdown toggling
  var cohort_filter = document.getElementById('cohort-filter')
  cohort_filter.addEventListener("click", function() {
    cohort_filter.parentNode.classList.toggle('is-active');
  });

  // Add measurment date filter dropdown toggling
  var date_filter = document.getElementById('date-filter')
  date_filter.addEventListener("click", function() {
    date_filter.parentNode.classList.toggle('is-active');
  });

  // TODO: Add this back in later, after backend code is cleaned up
  // Initialize all input of type date
  // var calendars = bulmaCalendar.attach('.bulma-calendar[type="date"]', {
  //   displayMode: 'dialog',
  //   isRange: false,
  // });
});
