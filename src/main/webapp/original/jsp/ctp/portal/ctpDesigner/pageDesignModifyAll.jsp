<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/common.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<html class="h100b over_hidden">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="renderer" content="webkit">
<link rel="stylesheet" type="text/css" href="${path}/common/designer/css/pageDesigner.css${ctp:resSuffix()}"/>
<title>${ctp:i18n('menu.page.setting')}</title>
<style>
	.stadic_layout{
		background:#C4CBCE;
	}
	.stadic_head_height{
	    height:78px;
	    background:#4D6581;
	} 
	.stadic_body_top_bottom{
	    bottom: 0px;
	    top: 98px;
	    overflow:hidden;
	}
</style>
</head>
<body class="h100b over_hidden">
<div class="stadic_layout">
    <div class="stadic_layout_head stadic_head_height">
       <h2 class="pageDesignLogo"></h2>
       <c:set var="listSize" value="${fn:length(list)}"/>
       <ul class="pageDesignMenu <c:if test='${parentAllowChoose !=1 }'> noPermission </c:if>" >
		 	<c:forEach items="${list}" var="item" varStatus="status">
		 		<c:choose>
		 			<c:when test="${item.id == templateId }">
		 				<li class="currentTab defaultTab" templateId="${item.id}" onclick="modifyPortalTemplate('${item.id}',this);"><span class="${item.thumbnail}"></span><strong class="layout_pat_name">${ctp:i18n(item.name) }</strong></li>
		 			</c:when>
		 			<c:otherwise>
		 				<li templateId="${item.id}" <c:if test="${parentAllowChoose==1 }"> onclick="modifyPortalTemplate('${item.id}',this);" </c:if> ><span class="${item.thumbnail}"></span><strong class="layout_pat_name">${ctp:i18n(item.name)}</strong></li>
		 			</c:otherwise>
		 		</c:choose>
			</c:forEach>
		 </ul>
    </div>
    <div class="stadic_layout_body stadic_body_top_bottom">
       <iframe id="currentPortalTemlateFrame" marginwidth="0" marginheight="0" frameborder="0" scrolling="no" style="width: 100%;height: 100%; border:none; margin:0;"></iframe>
    </div>
</div>
</body>
</html>
<script>
var menuSpaceNavigationConfigLabel= "${ctp:i18n('menu.space.navigationConfig')}";
var defaultTemplateId= "${templateId}";
var i18n_adminsavePrompt= "${ctp:i18n('portal.skin.adminsave.prompt')}";
var fileUrlId= "${fileUrlId}";
var from= "${from}";
var cityName="";
//weatherSection get city by sina
try{
	$.getScript("http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js", function(){
		//加载成功
		if(typeof(remote_ip_info)!="undefined"){
			cityName=remote_ip_info.city;
		}
	});
}catch(e){}
// $(function () {
// 	$("#currentPortalTemlateFrame").height($(window).height()-60);
// });
var totalDisplayWidth= 0;
var totalDisplayHeight= 0;
$(function(){
	totalDisplayWidth= $("html").width();
	totalDisplayHeight= $("html").height();
	modifyPortalTemplate("${templateId}");
});

function modifyPortalTemplate(templateId){
	$("#currentPortalTemlateFrame").attr("src","${path }/portal/homePageDesigner.do?method=homePageDesignModify&isDialog=${param.isDialog}&defaultTemplateId=${templateId}&templateId="+templateId+"&totalDisplayWidth="+totalDisplayWidth+"&totalDisplayHeight="+totalDisplayHeight);
	$(".pageDesignMenu li").each(function(){
		var templateIdTemp= $(this).attr("templateId");
		if(templateIdTemp==templateId){
			$(this).addClass("currentTab");
		}else{
			$(this).removeClass("currentTab");
		}
	});
}

//栏目头部文字更多颜色设置
function getSectionTabMoreFontColor(){
  var colorValue = $("#currentPortalTemlateFrame")[0].contentWindow.sectionHeadFontColor.color;
  var colorOpacity = $("#currentPortalTemlateFrame")[0].contentWindow.sectionHeadFontColor.colorOpacity*0.7;
  var sectionMoreTextColor =  "";
  if(colorValue){
  	if($.browser.msie && ($.browser.version == '8.0' || $.browser.version == '7.0' || $.browser.version == '6.0' || document.documentMode =="7")){
    	sectionMoreTextColor = colorValue;
    }else{
    	sectionMoreTextColor = colorValue.replace("rgb", "rgba").replace(")", ", " + colorOpacity / 100 + ")");
    }
  }else{
    sectionMoreTextColor = "";
  }
  return sectionMoreTextColor;
}

/**
 * @description dialog组件回调此方法
 */
function OK(jsonArgs) {
 	var innerButtonId= jsonArgs.innerButtonId;
  	if(innerButtonId=='ok'){
  		$("#currentPortalTemlateFrame")[0].contentWindow.savePageDataFunction();
  		return "ok";
 	}
}


function openD(url){
	var _client_width = document.body.clientWidth;
    var _client_height = document.documentElement.clientHeight;
   
    var htmlStr = '<div class="mask simpleDialog_mask" style="width:100%; z-index: 999; position: absolute; background-color: #000000;filter: alpha(opacity=25); -moz-opacity: 0.25; opacity: 0.25;height:'+_client_height+'px"></div>';
    htmlStr += '<div class="simpleDialog" style=" position: absolute; z-index: 1000; background:none; top:98px; left:0; height:'+(_client_height-98)+'px; width:'+_client_width+'px"><iframe src="'+url+'"  marginwidth="0" marginheight="0" frameborder="0" scrolling="no" allowTransparency="true" style=" width: 100%;height: 100%; border:none; margin:0;"></iframe></div>';
    $('body').prepend(htmlStr);
}
function closeD(url,decoration){
	$('body').find('.simpleDialog_mask,.simpleDialog').fadeOut().remove();
	if(url==null||url==''||url=='undifend'){
		url = $('#currentPortalTemlateFrame')[0].contentWindow.$('#main').attr('src');
	}else{
		$('#currentPortalTemlateFrame')[0].contentWindow.personalSpaceUrl=url;
	}
	if(decoration!=null&&decoration!=''&&decoration!='undifend'){
		url+="?decoration="+decoration;
	}
	if (url.indexOf("?") == -1) {
	    url = url + "?uu=" + getUUID();
    } else {
        url = url + "&uu=" + getUUID();
    }
	$('#currentPortalTemlateFrame')[0].contentWindow.$('#main').attr('src', url);
	$('#currentPortalTemlateFrame')[0].contentWindow.$('#main').load(function(){
		if(decoration!=null&&decoration!=''&&decoration!='undifend'){
			$('#currentPortalTemlateFrame')[0].contentWindow.personalSpaceDecorator=decoration;
		}
		$('#currentPortalTemlateFrame')[0].contentWindow.mainLoadReset();
	});
	window.top.isMustNeedReloadForDesigner= true;
	//此方法应该预留参数，取消的时候不刷新#main框架

}

$(window).resize(function(){
	if($(".simpleDialog_mask").length){
		$(".simpleDialog_mask").height($(".stadic_layout").height());
		$(".simpleDialog").height($(".stadic_layout").height()-98);
		$(".simpleDialog").width($(".stadic_layout").width()-40);
	}
});

function showLocation(){
	
}

function refreshSpaceCurrentClass(){
	
}

$(document).ready(function() {
	if($.browser.msie && (document.documentMode =="7")){//360兼容模式  需要计算高度
	    var _client_height = document.documentElement.clientHeight;
	    $("#currentPortalTemlateFrame").css("height", _client_height-$(".stadic_layout_head").height()-20);
	}
});
window.top.isExcuteParentClose= true;
window.onbeforeunload= function(){
	if(window.top.isExcuteParentClose){
		if($("#currentPortalTemlateFrame")[0].contentWindow.closeDesignerParentWindow){
			$("#currentPortalTemlateFrame")[0].contentWindow.closeDesignerParentWindow();
		}else{
			closeDesignerWindow();
		}
	}
	
}

function closeDesignerWindow(){
	window.close();
}
</script>