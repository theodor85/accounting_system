import ApplicationController from './application_controller'
import getElementByXPath from '../src/utils'

export default class extends ApplicationController {
  newfield (event) {
    
    console.log('newfield', event)

    //     добавить новую строку в таблицу
    const tbody = getElementByXPath('//table/tbody')
    console.log(tbody)

//     /*

//     инициализировать Materialize
//     изменить кнопку на предыдущей строке - сделать кнопку "удалить" (с обработчиком)
//     повесить обработчик на новую кнопку
//     */
  }
}
