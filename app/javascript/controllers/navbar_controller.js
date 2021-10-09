import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
  }
    
  open(){
    $("#nav-burger").toggleClass("is-active");
    $("#nav-menu").toggleClass("is-active");
    $("#nav-menu").toggleClass("hidden");
  }
}