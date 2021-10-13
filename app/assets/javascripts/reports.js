// Replaced by blazer reporting - 1/24/21

var Reports = (function () {
  var chart = null;
  var showChart = async function (element) {
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
      default:
        new SpawningChart(element);
        break;
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
});
