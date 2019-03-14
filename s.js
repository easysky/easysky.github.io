var ua=/Android|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent)?1:0,ss=[[(ua?"m":"www")+".baidu.com","/s?word=","百度"],["cn.bing.com","/search?q=","必应"],[(ua?"m":"www")+".so.com","/s?q=","360"],[(ua?"wap":"www")+".sogou.com","/web"+(ua?"/searchlist.jsp?keyword=":"?query="),"搜狗"],[(ua?"m":"www")+".yandex.com","/search/?text=","Yandex"],[(ua?"m.":"")+"mijisou.com","/?q=","秘迹"]],skey=window.location.search,sik=getCookie();
$(function(){
	if(ua){
		$("#left").hide();
	}else{
		$("#left span").html($("h1").text());
	}
	$("#right").html($("#box").html());
	var bflag=0;
	if(skey!=""){
		skey=skey.substring(1).split("=")[1];
		if(skey!=""){
			bflag=1;
		}
	}
	if(bflag){
		setPos();
		dorun(skey);
		$("#curr span").text(ss[sik][2]);
		$("#right span").eq(sik).css("background-color","#800");
	}else{
		$("#box span").eq(sik).css("background-color","#800");
		$("#main2").hide(),$("#main").show();
	}
	$("#curr").hover(function(){
		$(this).hide(),$("#right").show();
	});
	$("#right").mouseleave(function(){
		if($(window).width()<980){
			$(this).hide(),$("#curr").show();
		}
	});
	$("#box span").click(function(){
		sik=$(this).index(),skey=$("#main input").val();
		if(skey==""){
			window.location.href="http://"+ss[sik][0];
		}else{
			setCookie(sik);
			window.location.href="/?q="+skey;
			//window.location.href="http://"+window.location.host+"/?q="+skey;
		}
	});
	$("#right span").click(function(){
		sik=$(this).index(),skey=$("#center input").val();
		$("#sse").attr("src","https://"+ss[sik][0]+ss[sik][1]+skey),$("#right span").css("background-color","#0a3b76"),$(this).css("background-color","#800"),$("#curr span").text(ss[sik][2]);
		setCookie(sik);
	});
	$("#left").click(function(){
		$("#nav").show(),$("#tit").hide(),$("#sse").css("height",$(window).height()-5);
	});
	$("#nav").click(function(){
		$("#tit").show(),$("#nav").hide(),$("#sse").css("height",$(window).height()-50);
	});
});
function go(i){
	skey=(i==0)?$("#main input").val():$("#center input").val();
	if((event.keyCode==13)&&(skey!="")){
		if(i==0){
			window.location.href="/?q="+skey;
			//window.location.href="http://"+window.location.host+"/?q="+skey;
		}else{
			$("#sse").attr("src","https://"+ss[sik][0]+ss[sik][1]+skey),$("#right span").css("background-color","#0a3b76"),$(this).css("background-color","#800"),$("#curr span").text(ss[sik][2]);
		}
	}
}
$(window).resize(function(){
	setPos();
});
function setPos(){
	$("#sse").css("height",$(window).height()-50);
	if($(window).width()>=980){
		$("#curr").hide(),$("#right").css("width","480px"),$("#center").css("margin","0 480px 0 125px"),$("#right").show();
	}else{
		$("#right").hide(),$("#right").css("width","90px"),$("#center").css("margin","0 90px 0 125px"),$("#curr").show();
	}
}
function dorun(){
	$("#center input").val(skey);
	$("#sse").attr("src","https://"+ss[sik][0]+ss[sik][1]+skey);
	$("#main").hide();
	$("#main2").show();
}
function setCookie(value){
	var Days=30;
	var exp=new Date();
	exp.setTime(exp.getTime()+Days*24*60*60*1000);
	document.cookie="Sse="+value;
	//document.cookie="Sse="+value+";expires="+exp.toGMTString();
}
function getCookie(){
	var sc=document.cookie;
	if(sc!=""){
		sc=sc.split("=")[1];
		if(sc==""){
			sc=0;
		}
	}else{
		sc=0;
	}
	return sc;
}