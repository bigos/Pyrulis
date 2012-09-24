// ==UserScript==
// @name        hyperspec-decorator
// @namespace   /Groups/AI/html/cltl/
// @include     http://www.lispworks.com/documentation/HyperSpec/Body/*
// @version     1
// ==/UserScript==



// make adding styles easy
function addGlobalStyle(css) {
    try {
    var elmHead, elmStyle;
    elmHead = document.getElementsByTagName('head')[0];
    elmStyle = document.createElement('style');
    elmStyle.type = 'text/css';
    elmHead.appendChild(elmStyle);
    elmStyle.innerHTML = css;
    } catch (e) {
    if (!document.styleSheets.length) {
        document.createStyleSheet();
    }
    document.styleSheets[0].cssText += css;
    }
}

//change <p><b> into <h3>
var kids, obj;
var oh, ih;
kids = document.body.children;
for (var k = 0; k < kids.length; k ++) {
    obj = kids[k];
    if (obj.outerHTML.match(/<p><b>.*:<\/b><\/p>/)) {
	ih = obj.firstChild.innerHTML;
	oh = obj.outerHTML;
	console.log(obj.firstChild.innerHTML);
	obj.outerHTML = '<h3>'+ih+'</h3>'
    } 
}

addGlobalStyle('body{padding: 1em; font-size: 16px; font-weight: 100; font-family: helvetica, verdana, sans-serif;}');
addGlobalStyle('tt{color: #b00; font-weight: normal; font-size:1em;padding: 0.25em; font-family: monospace; }');
addGlobalStyle('p{line-height:1.5em;}');
addGlobalStyle('p b{font-weight: bold; letter-spacing: 2px;}');
addGlobalStyle('pre{line-height:1.25em;border:solid #dee 1px; background:#f8fff8; padding:0.75em;font-size:1em;font-family: monospace ;}');
addGlobalStyle('code{line-height:1.25em; }');

addGlobalStyle('h3{padding:0.25em; background: #eef; }');

