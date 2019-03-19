$(function(){
	var h=location.search.toLowerCase().substr(1),b=0,n="旅途的风景",s,t;
	$("a").attr("target","_blank");
	if(h!=""&&h.length>=2&&$("#"+h).length>0){
		h="#"+h;
		$(".box:not("+h+")").hide();
		s=$(h+" .f_c");
		t=$(h+" .f_t").text();
		$(".left").css("cursor","pointer");
		$(".right li:first").hide();
		$(".f_t").css("cursor","default");
		$(".f_i a").remove();
		b=1;
		$(s).load("post/"+t+".txt txt",function(){
			$(s).show();
			autoimg();
			$("title").html("Journey - "+t);
			$(s).attr("sflag",1);
		});
	}
	$(".right li:first").click(function(){
		$("#sf").toggle();
		if($("#sf").is(":visible")){
			$(".tb").focus();
		}
	});
	$(".f_t").click(function(){
		if(b==1){
			return;
		}
		s=$(this).next().next();
		$(s).toggle();
		if($(s).is(":visible")){
			$("html,body").animate({scrollTop:$(s).offset().top-90},500);
			$("title").html("Journey - "+$(this).text());
		}else{
			$("title").html("Journey - "+n);
		}
		if($(s).attr("sflag")==0){
			$(s).before("<div class='loading'><span></span><span></span><span></span><span></span><span></span></div>");
			$(s).load("post/"+$(this).text()+".txt txt",function(){
				$(".loading").remove();
				autoimg();
				$(s).attr("sflag",1);
			});
		}
	});
	$(".left").click(function(){
		if(b==1){
			window.location.href="/";
		}
	});
	$("#tags span").click(function(){
		$(this).siblings().removeClass("sel");
		if($(this).hasClass("sel")){
			$(this).removeClass("sel");
			t="";
			s=n;
		}else{
			$(this).addClass("sel");
			t=$(this).text().split(" ")[0];
			s="tag: "+t;
		}
		$(".kt").each(function(){
			//$(this).parent().parent().hide().filter(':contains("'+t+'")').show();
			h=$(this).parent().parent();
			if($(this).text().indexOf(t)==-1){
				h.hide();
			}else{
				h.show();
			}
		});
		$("title").html("Journey - "+s);
	});
	$(".btn").click(function(){
		$("#tags span").removeClass("sel");
		var t=$(".tb").val().trim();
		$(".f_t").each(function(){
			var s=$(this).text(),h="#"+$(this).parent().attr("id");
			$("#gt").load("post/"+s+".txt",function(){
				s=$(this).text().replace(/[\r\n]/g,"");
				if(s.indexOf(t)==-1){
					$(h).hide();
				}else{
					$(h).show();
				}
				$("#gt").empty();
				$("title").html("Journey - "+((t=="")?n:("key: "+t)));
			});
		});
	});
	$("#navi").click(function(){
		$("html,body").animate({scrollTop:0},500);
	});
	function autoimg(){
		if($(s).find("img").length!=0){
			$("img").each(function(){
				var img=$(this),rW,rH;
				$("<img/>").attr("src",$(this).attr("src")).load(function(){
					rW=this.width;
					rH=this.height;
					if(rW>=parseInt($(window).width())){
						$(img).css("width","100%").css("height","auto");
					}else{
						$(img).css("width",rW+'px').css("height",rH+'px');
					}
				});
			});
		}
	}
});