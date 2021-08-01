function getElementByXPath(xpath) {
  console.log('getElementByXPath')
  return document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
}

export default getElementByXPath;
