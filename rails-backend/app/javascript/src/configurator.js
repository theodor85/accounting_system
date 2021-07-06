
// window.addEventListener('load', function(event) {
//   document.getElementById('add_ref').addEventListener('click', function(event) {
//     const div_new_ref = document.getElementById('new_ref')
//     const div_container = document.getElementById('container_for_new')
  
//     if (div_new_ref) {
//       div_new_ref.parentNode.removeChild(div_new_ref);
//       event.target.innerText = 'Добавить справочник'
//     } else {
//       fetch('/conf/new_ref')
//       .then((response) => {
//         return response.text()
//       })
//       .then((html) => {
//         div_container.innerHTML = html
//         M.FormSelect.init(document.querySelectorAll('select'), {});
//       });
  
//       event.target.innerText = 'Отменить добавление'
//     }
//   });
// });
