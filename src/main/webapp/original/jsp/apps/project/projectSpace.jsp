<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<!DOCTYPE html>
<html class="h100b" style="${transparentStyle}">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<script type="text/javascript" src="${path}/ajax.do?managerName=calEventManager"></script>
<script type="text/javascript" src="${path}/apps_res/calendar/js/showTimeLineData.js"></script>
<script type="text/javascript" src="<c:url value='/apps_res/project/js/projectSpace.js${v3x:resSuffix()}'/>"></script>
<style>
  .stadic_head_height{
    height:70px;
  }
  .stadic_body_top_bottom{
    top: 85px;
    bottom: 0px;
  }
</style>
<title>项目空间</title>
</head>
<body class="h100b" style="${transparentStyle}overflow-x:auto;overflow-y:hidden;">
	<div class="stadic_layout  over_hidden" style="overflow: hidden;">
		<div class="stadic_layout_head stadic_head_height banner-layout">
			<div class="portal-layout-cell">
				<input type="hidden" id="projectId" value="${project.id }"/>
				<input type="hidden" id="projectName" value="${ctp:toHTML(project.projectName )}"/>
				<input type="hidden" id="from" value="${from}"/>
				<iframe onload="init_location4roject();projectHeadListener()" src="${headUrl}" id="head" name="head" frameborder="0" allowtransparency="true" class="w100b h100b" style="position:absolute;"></iframe>
			</div>
		</div>
		<div class="stadic_layout_body stadic_body_top_bottom clearfix">
			<iframe onload="projectBodyListener()" src="${bodyUrl}&rnd=<%=java.lang.Math.random()%>" id="body" name="body" frameborder="0" allowtransparency="true" class="w100b h100b" style="position:absolute;"></iframe>
		</div>
	</div>
</body>
<script type="text/javascript">
$("#body").load(function(){
	initSpaceHotSpot();
});
//空间栏目热点初始化方法
function initSpaceHotSpot(){
	if(getCtpTop().cBgColor){
		resetSectionTabColor(getCtpTop().cBgColor.color);
		try {
			setContentAreabgc(getCtpTop().sectionContentColor.color, getCtpTop().sectionContentColor.colorOpacity);
		} catch (e) {}
		try{
			resetSectionTabBgColor(getCtpTop().sectionHeadBgColor.color, getCtpTop().sectionHeadBgColor.colorOpacity);
		}catch(e){}
		try{
			resetSectionTabFontColor(getCtpTop().sectionHeadFontColor.color, getCtpTop().sectionHeadFontColor.colorOpacity);
		}catch(e){}	
	}else{
		//栏目头部颜色
		if (getCtpTop().$.ctx.hotspots.cBgColor) {
			resetSectionTabColor(getCtpTop().$.ctx.hotspots.cBgColor.hotspotvalue);
		}
		//栏目内容区颜色 (框架加载完毕之后设置)
		if (getCtpTop().$.ctx.hotspots.sectionContentColor) {
			initMainFrameHotSpot();
		}
	}
}

//初始化空间main栏目热点
function initMainFrameHotSpot(){
	try {
		setContentAreabgc(getCtpTop().$.ctx.hotspots.sectionContentColor.hotspotvalue, getCtpTop().$.ctx.hotspots.sectionContentColor.ext5);
	} catch (e) {}
	try{
		resetSectionTabBgColor(getCtpTop().$.ctx.hotspots.sectionHeadBgColor.hotspotvalue, getCtpTop().$.ctx.hotspots.sectionHeadBgColor.ext5);
	}catch(e){}
	try{
		resetSectionTabFontColor(getCtpTop().$.ctx.hotspots.sectionHeadFontColor.hotspotvalue, getCtpTop().$.ctx.hotspots.sectionHeadFontColor.ext5);
	}catch(e){}	
}

//首页更改栏目头部颜色
function resetSectionTabColor(colorValue) {
	if (getCtpTop().isCurrentUserAdmin != "true") {
		sectionTabColor = colorValue;
		sectionTabTextColor = sectionTabColor == 'transparent' ? sectionTabColor : getOpacityRgb(sectionTabColor, 0.2);
		//rgbaOpacity = "rgba(255,255,255," + colorOpacity + ")";
		var mainSrc = $("#body").attr("src");
		if (mainSrc.indexOf(".psml") > 0) {
			var spaceWindow = $("#body")[0].contentWindow;
			if(spaceWindow && spaceWindow.$){
				if($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')){
				  // do nothing
				} else {
				  spaceWindow.$(".index_tabs ul li").css("border-bottom-color",sectionTabColor);
				  spaceWindow.$(".content_area_head_bg").css("background", sectionTabTextColor);
				  $(".skin_column_color").css("background-color", sectionTabColor);
				}
			}
		}
		// 		var mainSrc = $("#body").attr("src");
		// if (mainSrc.indexOf(".psml") > 0) {
		// 	var spaceWindow = $("#body")[0].contentWindow;
		// 	if (spaceWindow && spaceWindow.$) {
		// 		spaceWindow.$(".index_tabs ul li").css("border-bottom-color", sectionTabColor);
		// 		spaceWindow.$(".content_area_head_bg").css("background", sectionTabTextColor);
		// 		if ($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')) {
		// 			// do nothing
		// 		} else {
		// 			if (getCtpTop().systemProductId != 7) {
		// 				spaceWindow.$(".content_area_head").css("background", rgbaOpacity);
		// 			} else {
		// 				spaceWindow.$(".content_area_head").css("background", "#5198cf");
		// 			}
		// 		}
		// 	}
		// }
	}
}

//首页更改栏目内容区颜色、透明度
function setContentAreabgc(areabgc, areaOpacity) {
	var content_area_bgcOpacity = (areaOpacity / 100);
	var newColorValue = colorHexToRgb(areabgc);
	if ($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')) {

	} else {
		newColorValue = newColorValue.replace("rgb", "rgba").replace(")", ", " + content_area_bgcOpacity + ")");
	}
	if ($("#body").contents().find(".content_area_body:first").length == 0) {
		$("#body").contents().find(".portal-header-bg").closest(".portal-layout-cell-banner").css("background-color", newColorValue);
		return;
	}
	if (getCtpTop().systemProductId != 7) {
		$("#body").contents().find(".content_area_body").addClass("body_transparent").css("background-color", newColorValue);
	} else {
		$("#body").contents().find(".content_area_body").addClass("body_transparent").css({
			"background-color": newColorValue,
			"border-right": "solid 1px #ced0d3",
			"border-bottom": "solid 1px #ced0d3",
			"border-left": "solid 1px #ced0d3"
		});
		$("#body").contents().find(".content_area_head").find("a,span").css("color", "#fff");
	}
	$("#body").contents().find(".portal-header-bg").closest(".portal-layout-cell-banner").css("background-color", newColorValue);
}

//首页更改栏目头部背景颜色
function resetSectionTabBgColor(colorValue,colorOpacity){
  var rgbValue = colorHexToRgb(colorValue);
  var spaceWindow = $("#body")[0].contentWindow;
  if(spaceWindow && spaceWindow.$){
	  var ie8RgbValue= rgbValue;
    rgbValue = rgbValue.replace("rgb", "rgba").replace(")", ", " + colorOpacity / 100 + ")");
    spaceWindow.$(".skin_column_bgColor").css("background-color", rgbValue);
    if($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')){
      // do nothing
	  spaceWindow.$(".content_area_head").css("background-color",ie8RgbValue);
    } else {
      if(getCtpTop().systemProductId != 7){
        spaceWindow.$(".content_area_head").css("background-color",rgbValue);
      }else{
        spaceWindow.$(".content_area_head").css("background-color","#5198cf");
      }
    }
  }
}

//首页更改栏目头部文字颜色
function resetSectionTabFontColor(colorValue,colorOpacity){
  var rgbValue = colorHexToRgb(colorValue);
  var spaceWindow = $("#body")[0].contentWindow;
  if(spaceWindow && spaceWindow.$){
	  var ie8RgbValue= rgbValue;
    rgbValue = rgbValue.replace("rgb", "rgba").replace(")", ", " + colorOpacity / 100 + ")");
    spaceWindow.$(".skin_column_fontColor").css("background-color", rgbValue);
    if($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0')){
      // do nothing
	   spaceWindow.$(".index_tabs li span,.index_tabs_line").css("color",ie8RgbValue);
    } else {
        spaceWindow.$(".index_tabs li span").css("color",rgbValue);
    }
  }
}

//16进制颜色值转为rgb
function colorHexToRgb(sColor) {
	var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
	if (sColor && reg.test(sColor)) {
		if (sColor.length === 4) {
			var sColorNew = "#";
			for (var i = 1; i < 4; i += 1) {
				sColorNew += sColor.slice(i, i + 1).concat(sColor.slice(i, i + 1));
			}
			sColor = sColorNew;
		}
		//处理六位的颜色值
		var sColorChange = [];
		for (var i = 1; i < 7; i += 2) {
			sColorChange.push(parseInt("0x" + sColor.slice(i, i + 2)));
		}
		return "rgb(" + sColorChange.join(",") + ")";
	} else {
		return sColor;
	}
}

function getOpacityRgb(color1,Alpha1,color2,Alpha2){
	var R1,R2,G1,G2,B1,B2,Alpha;
	if(color2 == undefined){
		color2 = "rgb(255,255,255)";
		Alpha2 = 1;
		R2 = 255;
		G2 = 255;
		B2 = 255;
	}else{
		color2 = color2+"";
		if(color2.indexOf("#")!=-1){
			color2 = roRgbString(color2); 
		}
		color2 = color2.toLowerCase();
		if(color2.indexOf("rgb(")!=-1){
			var regexp =  /[0-9]{0,3}/g;
		    var fff = color2.match(regexp);
		    for(var i=0;i<fff.length;i++){
			    if(fff[i]==""){
			    	fff.splice(i,1);
			    	i--;
			    }
		    }
			R2 = fff[0];
			G2 = fff[1];
			B2 = fff[2];
		}
	}
	color1 = color1+"";
	if(color1.indexOf("#")!=-1){
		color1 = roRgbString(color1); 
	}
	color1 = color1.toLowerCase();
	if(color1.indexOf("rgb(")!=-1){
		var regexp =  /[0-9]{0,3}/g;
	    var fff = color1.match(regexp);
	    for(var i=0;i<fff.length;i++){
		    if(fff[i]==""){
		    	fff.splice(i,1);
		    	i--;
		    }
	    }
		   
		R1 = fff[0];
		G1 = fff[1];
		B1 = fff[2];
	}
  R   =   R1   *   Alpha1   +   R2   *   Alpha2   *   (1-Alpha1) ;   
  G   =   G1   *   Alpha1   +   G2   *   Alpha2   *   (1-Alpha1) ;    
  B   =   B1   *   Alpha1   +   B2   *   Alpha2   *   (1-Alpha1) ;   
  Alpha   =   1   -   (1   -   Alpha1)   *   (   1   -   Alpha2) ;   
  R   =   R   /   Alpha;    
  G   =   G   /   Alpha;    
  B   =   B   /   Alpha;
  R = isNaN(R)?0:R;
  G = isNaN(G)?0:G;
  B = isNaN(B)?0:B;
  return "rgb("+parseInt(R)+","+parseInt(G)+","+parseInt(B)+")";
  //return "rgb("+R+","+G+","+B+")";
}
function roRgbString(rgb){
	var reg = /^#([0-9a-fA-f]{3}|[0-9a-fA-f]{6})$/;
	var sColor = rgb.toLowerCase();
	if(sColor && reg.test(sColor)){
		if(sColor.length === 4){
			var sColorNew = "#";
			for(var i=1; i<4; i+=1){
				sColorNew += sColor.slice(i,i+1).concat(sColor.slice(i,i+1));	
			}
			sColor = sColorNew;
		}
		//处理六位的颜色值
		var sColorChange = [];
		for(var i=1; i<7; i+=2){
			sColorChange.push(parseInt("0x"+sColor.slice(i,i+2)));	
		}
		//alert("RGB(" + sColorChange.join(",") + ")")
		return "RGB(" + sColorChange.join(",") + ")";
	}else{
		return sColor;	
	}
}
</script>
</html>