<%@ page language="java" contentType="text/html;charset=UTF-8"%>
<%@ include file="/common/js/common.jsp"%>
<html>
    <head>
        <meta charset="utf-8">
        <title>index</title>
        <script type="text/javascript">
        $(function(){
        	$("ul.left li").click(function(){
        		var tempThis = $(this);
        		if(!tempThis.hasClass("current")){
	        		tempThis.siblings("li").removeClass("current");
	        		tempThis.addClass("current");
	        		var target = $("#"+tempThis.find("a").attr("tgt"));
	        		if(target.size()>0){
	        			target.removeClass("hidden");
	        			target.siblings("div").addClass("hidden");
	        		}
	        		target = null;
        		}
        		tempThis = null;
        	});
        });
        </script>
    </head>
    <body class="body_main">
	    <div id="tabs2" class="">
		    <div id="tabs2_head" class="common_tabs clearfix bg_color_gray">
		        <ul class="left">
		            <li class="current"><a href="javascript:void(0)" tgt="tab1_div"><span>div1</span></a></li>
		            <li><a href="javascript:void(0)" tgt="tab2_div"><span>div2</span></a></li>
		            <li><a href="javascript:void(0)" tgt="tab3_div"><span>div3</span></a></li>
		            <li><a href="javascript:void(0)" tgt="tab4_div"><span>div4</span></a></li>
		        </ul>
		    </div>
		    <div id="tabs2_body" class="common_tabs_body ">
		        <div id="tab1_div">1</div>
		        <div id="tab2_div" class="hidden">2</div>
		        <div id="tab3_div" class="hidden">3</div>
		        <div id="tab4_div" class="hidden">4</div>
		    </div>
		</div>
    </body>
</html>
