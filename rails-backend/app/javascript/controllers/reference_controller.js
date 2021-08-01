import ApplicationController from './application_controller'
import { getElementByXPath, getElementsByXPath } from '../src/utils'

export default class extends ApplicationController {
  static targets = [ "name" ]

  new_field (event) {
    console.log('newfield', event)

    console.log('rjyhnhjkkth внутри: ', this)
    console.log('Значение внутри: ', this.nameTarget.value)

    const ref = {
      name: this.nameTarget.value,
      fields: [
        {name: 'qw', type: 'asd'},
        {name: 'qw', type: 'asd'},
      ]
    }

    this.stimulate('Reference#new_field', ref)
  }

  remove_field(event) {
    console.log('removefield', this.data.element.dataset.index)
    this.stimulate('Reference#remove_field', parseInt(this.data.element.dataset.index))
  }
}
