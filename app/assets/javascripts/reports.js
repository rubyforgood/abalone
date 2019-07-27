var Reports = (function() {
  var chart = null;

  var showChart = function(element) {
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
        new GrowthChart(element);
        break;
      default:
        console.log("Unknown chart type " + element.id);
    }
  };

  return {
    showChart: showChart
  };
})();

document.addEventListener('DOMContentLoaded', function() {
  if (document.getElementById('chart') === null) return; 

  var tabs = document.querySelectorAll('.tabs li');

  for (var i = 0; i < tabs.length; i++) {
    tabs[i].addEventListener('click', function() {
      if (this.classList.contains('is-active')) return;

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
