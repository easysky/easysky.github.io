$(function(){
	var curr="";
	AdjustBox();
	$("li").click(function(){
		openNewWindow("https://mp.weixin.qq.com/s/"+$(this).attr("data"));
		if (curr!=""){
			$("li[data='"+curr+"']").css({"background-color":"transparent","border-left":"6px solid #f2f2f2"});
		}
		$(this).css({"background-color":"#ddd","border-left":"6px solid #080"});
		curr=$(this).attr("data");
	});
	function openNewWindow(sUrl){
		var a=$("<a href='"+sUrl+"' target='_blank'>"+sUrl+"</a>").get(0),e=document.createEvent('MouseEvents');
		e.initEvent('click',true,true);
		a.dispatchEvent(e);
	}
});
$(window).resize(function(){
	AdjustBox();
});
function AdjustBox(){
	var dw=$(window).width();
	if (dw>=1400){
		$(".cat").css("width",(dw-48)/4);
		$(".list ul li").css("font-size","0.8em");
	}else if (dw>=720){
		$(".cat").css("width",(dw-24)/2);
		$(".list ul li").css("font-size","0.9em");
	}else{
		$(".cat").css("width",dw-12);
		$(".list ul li").css("font-size","1.0em");
	}
	if (dw>=720){
		$(".list").css("height",$(window).height()-100);
	}
}