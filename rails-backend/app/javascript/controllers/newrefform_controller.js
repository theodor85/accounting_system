import ApplicationController from './application_controller.js'

export default class extends ApplicationController {
  
  get(event) {
    console.log(event)
    event.preventDefault()
    this.stimulate('NewRefForm#get', event.target.dataset.reject)
  }

  afterGet(element, reflex, noop, reflexId) {
    console.log('Local after', reflexId)
    M.FormSelect.init(document.querySelectorAll('select'), {});
  }
}
