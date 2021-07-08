import ApplicationController from './application_controller.js'

export default class extends ApplicationController {
  connect () {
    super.connect()
    // add your code here, if applicable
  }
  get(event) {
    console.log(event)
    event.preventDefault()
    this.stimulate('NewRefForm#get', false)
  }

  beforeGet(element, reflex, noop, reflexId) {
    console.log('Local before', reflexId)
  }
}
