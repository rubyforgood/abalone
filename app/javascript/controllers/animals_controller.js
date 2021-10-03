import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    this.displayEntryPoint()
    this.onInputChange()
  }

  displayEntryPoint() {
    document.querySelector('#animal_collected_true').checked
      ? this.showEntryPoint()
      : this.hideEntryPoint()
  }

  hideEntryPoint() {
    document.querySelector('.animals__entry-point').style.display = 'none';
  }
  
  showEntryPoint() {
    document.querySelector('.animals__entry-point').style.display = 'block';
  }

  onInputChange() {    
    window.addEventListener('change', (event) => {
      if (event.target.value === 'true') {
        this.showEntryPoint();
      } else {
        this.hideEntryPoint();
      }
    });
  }
}
