function getElementByXPath(xpath) {
  console.log('getElementByXPath')
  return document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
}

function getElementsByXPath (xpath) {
  // let aResult = new Array();
  // let a = document.evaluate(xpath, this, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
  // for (var i = 0; i < a.snapshotLength; i++) {
  //     aResult.push(a.snapshotItem(i));
  // }
  // return aResult;
  return document.evaluate(xpath, this, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null)
};

export { getElementByXPath, getElementsByXPath }
