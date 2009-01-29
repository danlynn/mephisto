/* 
	Dynamically attached JS which scans current stylesheets for .CodeRay 
	selectors then adds the default codemacro.css if not found.
*/

function isSelectorMissing(selector) {
	var cssRules;
	if (document.all)
		cssRules = 'rules';
	else if (document.getElementById)
		cssRules = 'cssRules';
	for (var S = 0; S < document.styleSheets.length; S++) {
		var styleSheet = document.styleSheets[S];
		if (!styleSheet.disabled) {
			for (var R = 0; R < styleSheet[cssRules].length; R++) {
				if (styleSheet[cssRules][R].selectorText.indexOf(selector) >= 0)
					return false;
			}
		}
	}
	return true;
}

function attachStyleSheet(url) {
	if(document.createStyleSheet) {
		document.createStyleSheet(url);
	}
	else {
		var styles = "@import url('"+url+"');";
		var newSS = document.createElement('link');
		newSS.rel = 'stylesheet';
		newSS.href = 'data:text/css,'+escape(styles);
		document.getElementsByTagName("head")[0].appendChild(newSS);
	}
}

function addCodeMacroDefaultStyleSheetIfNeeded() {
	try {
		if (isSelectorMissing(".CodeRay")) {
			var prefix = document.location.protocol + "//" + document.location.hostname + ":" + document.location.port;
			attachStyleSheet(prefix+"/plugin_assets/filtered_column_code_macro/default_codemacro.css");
		}
	} catch(e) {}	// fail gracefully to default behavior
}

function addLoadEvent(func) {
	var oldonload = window.onload;
	if (typeof window.onload != 'function') {
		window.onload = func;
	} else {
		window.onload = function() {
			if (oldonload)
				oldonload();
			func();
		}
	}
}
addLoadEvent(addCodeMacroDefaultStyleSheetIfNeeded);
