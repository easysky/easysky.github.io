var ua=/Android|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent)?1:0,ss=[[(ua?"m":"www")+".baidu.com","/s?word=","百度"],["cn.bing.com","/search?q=","必应"],[(ua?"m":"www")+".so.com","/s?q=","360"],[(ua?"wap":"www")+".sogou.com","/web"+(ua?"/searchlist.jsp?keyword=":"?query="),"搜狗"],[(ua?"m.":"")+"mijisou.com","/?q=","秘迹"],["yandex.com","/search/?text=","Yandex"],["vip.kuaimen.bid","/search?&q=","谷歌"],["search.mysearch.com","/web?q=","MySearch"],["gugeji.com","/search?&q=","咕咯鸡"]],sk=window.location.search,si=0,yid=0,tit=$("title").text();
$(function(){
	var str="";
	for (var i=0;i<ss.length;i++){
		str+="<span>"+ss[i][2]+"</span>";
	}
	$("#box").html(str);
	$("#main h2").text(tit);
	if(sk!=""){
		var arrStr=sg(sk);
		si=arrStr["s"],sk=arrStr["q"];
		if(typeof(si)=="undefined"||/^[0-8]{1}$/g.test(si)==false){
			si=0;
		}
		if(typeof(sk)=="undefined"){
			sk="";
		}else{
			sk=decodeURI(sk);
		}
		$(".loading span").css("background",["red","#f18000","#8600ff","#080","#4969c7","black"][parseInt(Math.random()*6,10)]);
		$(".loading,#main h2").toggle();
	}
	$("#box span").eq(si).css("background-color","#080");
	$("input").val(sk);
	$("title").text(ss[si][2]+"搜索 - "+tit);
	if(sk!=""){
		yid=setTimeout("jump()","2500");
	}
	$("#box span").click(function(){
		si=$(this).index(),sk=$("input").val();
		window.location.href="https://"+ss[si][0]+((sk=="")?"":(ss[si][1]+sk));
		$("title").text(ss[si][2]+"搜索 - "+tit);
	});
	$(".fo a:eq(3)").click(function(){
		$("#info").toggle(300);
	});
	$("#info").click(function(){
		$(this).hide(300);
	});
	$("input").click(function(){
		clearTimeout(yid);
		$(".loading").hide();
		$("#main h2").show();
	});
});
function go(){
	sk=$("input").val();
	if(event.keyCode==13&&sk!=""){
		jump();
	}
}
function jump(){
	window.location.href="https://"+ss[si][0]+ss[si][1]+sk;
}
function sg(str){
	str=str.substring(1);
	var arr=str.split("&"),obj=[];
	for (var i=0;i<arr.length;i++){
		var temp=arr[i].split("=");
		obj[temp[0]]=temp[1];
	}
	return obj;
}