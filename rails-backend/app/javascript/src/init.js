function initMaterialize() {
  M.FormSelect.init(document.querySelectorAll('select'), {});
}

window.addEventListener('load', function(event) {
  console.log('window.addEventListener')
  initMaterialize();
});

export default initMaterialize;
