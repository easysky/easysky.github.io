var ua = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ? 1 : 0,
	istd = ("ontouchstart" in document.documentElement) ? 1 : 0;

//function rcolor() {
//	var cc = ["#8b008b", "#008000", "#ff5500", "#000", "#00008b"],
//		i = cc.length - 1;
//	return cc[parseInt(Math.random() * (i + 1), 10)];
//}

function ajaxp(s, t = 0, p = "") {
	var r = null;
	var xhr = new XMLHttpRequest();
	if (t == 0) { //GET
		xhr.open("GET", s, false);
	} else { // POST
		xhr.open("POST", p, false);
		xhr.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	}
	xhr.onreadystatechange = function() {
		if (xhr.readyState == 4 && (xhr.status == 200 || xhr.status == 304)) {
			r = xhr.responseText;
		}
	}
	xhr.send((t == 0) ? "" : (s + "&t=" + Math.random()));
	return r;
}