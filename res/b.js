var page = -1, //当前页码
	moods = ["说", "疑惑", "感叹", "生气", "讨厌", "希望", "郁闷", "高兴", "分享", "想知道"],
	lst_au = "",
	lst_ebtn = "", //上一个编辑按钮
	lst_index = 0, //最后一篇文章的序列号
	bx = document.getElementById("box"),
	nxt = document.getElementById("next"),
	ppbox = document.getElementById("pbox"),
	pplist = document.getElementById("plist"),
	player = document.getElementById("player");
t_post = ajaxp("data/list.log").trim().split("|");
act();
//自动滚动
const obj = new IntersectionObserver(itm => {
	if (itm[0].isIntersecting) {
		act();
	}
});
obj.observe(nxt);

bx.addEventListener("click", function(e) {
	var ele = e.target;
	if (ele.nodeName == "SPAN") {
		if (ele.className.indexOf("si_") == 0) { //点击图片、音频、视频缩略图
			var u = ele.className.substr(3, 1);
			if (u != "a") {
				var sd = ele.nextElementSibling,
					s = sd.getAttribute("data"),
					w = sd.getAttribute("tip");
				if (sd.getAttribute("flag") == "0") {
					sd.innerHTML = nxt.innerHTML;
					if (u == "p") { //图片
						var img = document.createElement("img");
						img.src = s;
						img.onload = function() {
							sd.innerHTML = "<div class='mbox'><img src='" + s + "' title='" + w + "'/><span class='clox iconfont icon-guanbi'></span></div>";
							img.remove();
						}
					} else { //视频
						sd.innerHTML = s;
					}
					sd.setAttribute("flag", "1");
				}
				if (u == "p") {
					sd.style.display = "block";
					ele.style.display = "none";
				} else {
					w = sd.style.display !== "block";
					sd.style.display = w ? "block" : "none";
					ele.style.textShadow = "0 0 " + (w ? "10px" : 0) + " #f00";
				}
			} else { //音频
				var s = ele.getAttribute("data").split(":"),
					t = "",
					m = ppbox.style.display;
				if (m == "none" || m == null) {
					ppbox.style.display = "block";
				}
				if (s[0] == "wy") {
					t = "https://music.163.com/song/media/outer/url?id=";
				} else if (s[0] == "kw") {
					t = "https://apis.jxcxin.cn/api/kuwo?type=mp3&id=";
				} else {
					//t="http://";
					t = getpath();
				}
				if (ele.getAttribute("flag") == "0") {
					pplist.insertAdjacentHTML("beforeend", "<span src='" + t + s[1] + "'>" + s[2] + "</span>");
					ele.setAttribute("flag", "1");
					var sd = pplist.lastElementChild;
					if (lst_au != "" && sd != lst_au) {
						lst_au.style.backgroundColor = "#f1f3f4";
					}
					sd.style.backgroundColor = "#c6d4e5";
					lst_au = sd;
				} else {
					lst_au.style.backgroundColor = "#f1f3f4";
					var pitem = pplist.querySelectorAll("span"),
						m = -1;
					for (var i = 0; i < pitem.length; i++) {
						if (pitem[i].innerText == s[2]) {
							m = i;
							break;
						}
					}
					pitem[m].style.backgroundColor = "#c6d4e5";
					lst_au = pitem[m];
				}
				pplay(t + s[1]);
				if (ppbox.style.display !== "block") {
					ppbox.style.display = "block";
				}
				setTimeout(() => {
					ppbox.style.display = "none";
				}, "2500");
			}
		}
		if (ele.className.indexOf("clox") == 0) { //隐藏图像
			ele.parentNode.parentNode.previousElementSibling.style.display = "inline";
			ele.parentNode.parentNode.style.display = "none";
		}
	}
	if (ele.nodeName == "IMG") { //新窗口打开图片
		openlink(ele.getAttribute("src"));
		return 0;
	}
});

document.getElementById("gotop").addEventListener("click", function() { //滚动到顶按钮
	window.scrollTo(0, 0);
});
document.getElementById("aulist").addEventListener("click", function() { //显示播放器 按钮
	var b = ppbox.style.display;
	ppbox.style.display = (b !== "block") ? "block" : "none";
});
ppbox.addEventListener("mouseover", function() {
	pplist.style.display = "block";
});
ppbox.addEventListener("mouseout", function() {
	pplist.style.display = "none";
});
pplist.addEventListener("click", function(e) {
	e.preventDefault();
	var ele = e.target;
	if (ele.nodeName == "SPAN") {
		pplay(ele.getAttribute("src"));
	}
	if (lst_au != "") {
		lst_au.style.backgroundColor = "#f1f3f4";
	}
	ele.style.backgroundColor = "#c6d4e5";
	lst_au = ele;
});

function act() {
	var n = 0;
	for (var i = 0; i < t_post.length; i++) {
		if (i < lst_index) {
			continue;
		}
		if (n >= 10 || lst_index >= t_post.length) {
			break;
		}
		var t = ajaxp("data/" + t_post[i] + ".txt").trim().split("`"),
			g = "<div class='entry'><strong>" + t[0] + "</strong><span class='prefix m" + t[1] + "'>" + moods[t[1]] + "</span>" + pformat(t[2]) + "<div class='entry-meta'><span class='iconfont icon-date'></span>&nbsp;&nbsp;" + tformat(t_post[i]) + "</div></div>";
		nxt.insertAdjacentHTML("beforebegin", g);
		if (lst_index >= t_post.length - 1) {
			nxt.remove();
		}
		n++;
		lst_index++;
	}
}

function pplay(s) {
	player.src = s;
	player.play();
}

function pformat(s) {
	var r = s.replace(/\[a@(.+?)=(.+?)\]/ig, "<a target='_blank' href='$2'>[$1]</a>");
	r = r.replace(/\[b=(.+?)\]/ig, "<strong>$1</strong>");
	r = r.replace(/\[i=(.+?)\]/ig, "<em>$1</em>");
	r = r.replace(/\[c@(#[0-9a-z]+)=(.+?)\]/ig, "<span style='color:$1'>$2</span>");
	r = r.replace(/\[g=(.+?)\]/ig, "<div class='blo'>$1</div>");
	r = r.replace(/\[dzb=(.+?)\]/ig, "<div class='dzb'>$1</div>");
	r = r.replace(/\[au=wy:([0-9]+):(.+?)\]/ig, "<span class='si_a iconfont icon-Music-1' data='wy:$1:$2' flag='0'></span>");
	r = r.replace(/\[au=kw:([0-9]+):(.+?)\]/ig, "<span class='si_a iconfont icon-Music-1' data='kw:$1:$2' flag='0'></span>");
	r = r.replace(/\[au=(.+?):(.+?)\]/ig, "<span class='si_a iconfont icon-Music-1' data='dr:$1:$2' flag='0'></span>");
	r = r.replace(/\[img@?(.*?)=#gt:(.+?)\]/ig, "<div class='mbox'><img src='https://s1.ax1x.com/$2' title='$1'></div>");
	r = r.replace(/\[img@?(.*?)=#(.+?)\]/ig, "<div class='mbox'><img src='$2' title='$1'></div>");
	r = r.replace(/\[img@?(.*?)=gt:(.+?)\]/ig, "<span class='si_p iconfont icon-picture-fill'></span><div class='mask' flag='0' tip='$1' data='https://s1.ax1x.com/$2'></div>");
	r = r.replace(/\[img@?(.*?)=(.+?)\]/ig, "<span class='si_p iconfont icon-picture-fill'></span><div class='mask' flag='0' tip='$1' data='$2'></div>");
	r = r.replace(/\[v=(.+?)\]/ig, "<span class='si_p iconfont icon-weishipin'></span><div class='mask' flag='0' data='<video controls=&quot;controls&quot; src=&quot;$1&quot;></video>'></div>");
	r = r.replace(/\[p\]/ig, "<br>");
	r = r.replace(/\[bl=([0-9]+):([0-9]+)\]/ig, "<span class='si_v iconfont icon-video'></span><div class='mask' flag='0' data='<iframe src=&quot;//player.bilibili.com/player.html?aid=$1&amp;cid=$2&page=1&quot; scrolling=&quot;no&quot; border=&quot;0&quot; frameborder=&quot;no&quot; framespacing=&quot;0&quot; allowfullscreen=&quot;true&quot;></iframe>'></div>");
	return r;
}

function tformat(s) {
	return s.substr(0, 4) + "-" + s.substr(4, 2) + "-" + s.substr(6, 2) + " " + s.substr(8, 2) + ":" + s.substr(10, 2) + ":" + s.substr(12, 2);
}

function openlink(url) {
	var a = document.createElement("a");
	a.href = url;
	a.target = "_blank";
	e = document.createEvent("MouseEvents");
	e.initEvent("click", true, true);
	a.dispatchEvent(e);
}

function getpath() {
	var r = document.createElement("a");
	r.href = "../home/media/%E9%9F%B3%E4%B9%90/";
	return r.href;
}