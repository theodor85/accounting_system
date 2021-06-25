function addRefClick(event) {
  const div_new_ref = document.getElementById('new_ref')
  const div_container = document.getElementById('container_for_new')
  const add_button = document.getElementById('add_ref')

  if (div_new_ref) {
    div_new_ref.parentNode.removeChild(div_new_ref);
    add_button.innerText = 'Добавить справочник'
  } else {
    fetch('/conf/new_ref')
    .then((response) => {
      return response.text()
    })
    .then((html) => {
      div_container.innerHTML = html
      M.FormSelect.init(document.querySelectorAll('select'), {});
    });

    add_button.innerText = 'Отменить добавление'
  }
}
