var ua=/Android|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent)?1:0,ss=[[(ua?"m":"www")+".baidu.com","/s?word=","百度"],["cn.bing.com","/search?q=","必应"],[(ua?"m":"www")+".so.com","/s?q=","360"],[(ua?"wap":"www")+".sogou.com","/web"+(ua?"/searchlist.jsp?keyword=":"?query="),"搜狗"],["360.bban.fun","/search?q=","谷歌"],[(ua?"m.":"")+"mijisou.com","/?q=","秘迹"]],sk=window.location.search,si=getCookie("e"),isfs=0;
$(function(){
	var nflag=0,bflag=0,str="";
	$("#main h1,#left span").text($("title").text());
	for (var i=0;i<ss.length;i++){
		str+="<span>"+ss[i][2]+"</span>";
	}
	$("#box,#right").html(str);
	if(ua){
		$("#left").hide();
		$("#center").css("margin-left","0.5em");
	}
	if(sk!=""){
		sk=decodeURI(sk.substring(1).split("=")[1]);
		if(sk!=""){
			bflag=1;
		}
	}
	if(bflag){
		setPos();
		$("#center input").attr("value",sk);
		$("#sse").attr("src","https://"+ss[si][0]+ss[si][1]+sk);
		$("#main").hide();
		$("#main2").show();
		$("#curr span").text(ss[si][2]);
		$("#right span").eq(si).css("background-color","#800");
	}else{
		$("#box span").eq(si).css("background-color","#800");
		$("#main2").hide(),$("#main").show();
	}
	$("#curr").click(function(){
		$(this).hide();
		$("#right").show();
		nflag=1;
	});
	$("#box span").click(function(){
		si=$(this).index(),sk=$("#main input").val();
		if(sk==""){
			window.location.href="http://"+ss[si][0];
		}else{
			setCookie(si);
			window.location.href="/?q="+sk;
		}
	});
	$("#right span").click(function(){
		if($(this).index()!=si){
			si=$(this).index(),sk=$("#center input").val();
			$("#sse").attr("src","https://"+ss[si][0]+ss[si][1]+sk);
			$("#right span").css("background-color","#0a3b76");
			$(this).css("background-color","#800");
			$("#curr span").text(ss[si][2]);
			setCookie(si);
		}
		if(nflag==1){
			$("#right").hide();
			$("#curr").show();
			nflag=0;
		}
	});
	$("#left").click(function(){
		$("#nav").show();
		$("#tit").hide();
		$("#sse").css("height",$(window).height());
		isfs=1;
	});
	$("#nav").click(function(){
		$("#tit").show();
		$("#nav").hide();
		$("#sse").css("height",$(window).height()-50);
		isfs=0;
	});
});
function go(i){
	sk=(i==0)?$("#main input").val():$("#center input").val();
	if((event.keyCode==13)&&(sk!="")){
		if(i==0){
			window.location.href="/?q="+sk;
		}else{
			$("#sse").attr("src","https://"+ss[si][0]+ss[si][1]+sk);
		}
	}
}
$(window).resize(function(){
	setPos();
});
function setPos(){
	if(isfs){
		$("#sse").css("height",$(window).height());
	}else{
		$("#sse").css("height",$(window).height()-50);
	}
}
function setCookie(value){
	var Days=300,exp=new Date();
	exp.setTime(exp.getTime()+Days*24*60*60*1000);
	document.cookie="e="+value+";expires="+exp.toGMTString();
}
function getCookie(objName){
	var arrStr=document.cookie.split(";");
	for (var i=0;i<arrStr.length;i++){
		var temp=arrStr[i].split("=");
		if (temp[0]==objName) return unescape(temp[1]);
	}
	return 0;
}