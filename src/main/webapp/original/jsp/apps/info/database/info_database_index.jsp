<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../include/info_header.jsp"%>
<!DOCTYPE html>
<html>
<head>
<title>信息报送应用设置</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<style type="text/css">
  .ie8_tag_width_fix{
    width: auto;
  }
</style>
<script type="text/javascript">

var listType = "${listType}";
function changeTab(listType) {
	if(typeof(listType)=='undefined') {
		listType = "listTemplate";
	}
	var tab = $("#"+listType+"Tab");
	$("#baseTab").find("li").removeClass("current").addClass("common_tabs A");
	tab.addClass("current").removeClass("common_tabs A");


	var url = "infomain.do?method=list"+tab.attr("params");
	//$("#tab_iframe").attr("src", url);
	location.href = "infomain.do?method=dataBaseIndex&listType="+listType;
}

$(document).ready(function() {
	var tab = $("#"+listType+"Tab");
	$("#baseTab").find("li").removeClass("current").addClass("common_tabs A");
	tab.addClass("current").removeClass("common_tabs A");

	var url = "infomain.do?method=list${params}";
	$("#tab_iframe").attr("src", url);

	$.each($("#baseTab li"), function(i, obj) {
		$(this).click(function() {
			changeTab($(this).attr("listType"));
		});
	});

	
	//Tab控件在IE8下显示异常，使用代码进行修复
	$(".no_b_border").each(function(){
		
		//判断语言环境，只有英文环境下有问题
		var regexp = /[\u4e00-\u9fa5]+/;
		if(regexp.test($(this).text())){//中文环境
			
		}else{
			//判断屏幕分辨率
			if(screen.width < 1280){//低分辨率宽度定死
				var parentElId = $(this).parent().attr("id");
				if(parentElId == "listTemplateTab"){
					$(this).css("max-width", "50px");
					$(this).parent().css("max-width", '66px');
				}else if(parentElId == "listFormTab"){
					$(this).css("max-width", "64px");
					$(this).parent().css("max-width", '80px');
				}else if(parentElId == "listPermissionTab"){
					$(this).css("max-width", "50px");
					$(this).parent().css("max-width", '66px');
				}else if(parentElId == "listCategoryTab"){
					$(this).css("max-width", "72px");
					$(this).parent().css("max-width", '88px');
				}else if(parentElId == "listScoreTab"){
					$(this).css("max-width", "96px");
					$(this).parent().css("max-width", '112px');
				}else if(parentElId == "listTaohongTab"){
					$(this).css("max-width", "50px");
					$(this).parent().css("max-width", '66px');
				}else if(parentElId == "listElementTab"){
					$(this).css("max-width", "60px");
					$(this).parent().css("max-width", '76px');
				}else if(parentElId == "switchSettingsTab"){
					$(this).css("max-width", "50px");
					$(this).parent().css("max-width", '66px');
				}
			}else{
				var tempMaxWidth = $(this).css("max-width");
				if(tempMaxWidth){
					var pMaxWidth = parseInt(tempMaxWidth.replace(/px/i, '')) + 16;
					$(this).parent().css("max-width", pMaxWidth + 'px');
				}
			}
		}
	});

});

</script>
</head>
<body>
<div id='layout' class="comp" comp="type:'layout',border:false">
	<div class="layout_north page_color" layout="height:33,sprit:false,border:false">
		<div class="comp" comp="type:'breadcrumb',comptype:'location',code:'F18_infoDatabase'"></div>
		<div>
			<div id="tabs2_head" class="common_tabs clearfix margin_l_5 margin_t_5">
				<ul class="left" id="baseTab">
                    <%--信息模板 --%>
					<li id="listTemplateTab" listType="listTemplate" params="&listType=listTemplate&categoryType=${appType }&categoryId=${appType }"><a id="btn1" class="no_b_border" href="javascript:void(0)" tgt="tab1_div"><span>${ctp:i18n("infosend.dataBase.index.infoTemplate")}</span></a></li>
                    <%--信息报送单 --%>
					<li id="listFormTab" listType="listForm" params="&listType=listForm&appType=${appType }"><a id="btn2" class="no_b_border" href="javascript:void(0)" tgt="tab2_div"><span>${ctp:i18n("infosend.dataBase.index.infoSumSingle")}</span></a></li>
                    <%--节点权限 --%>
					<li id="listPermissionTab" listType="listPermission" params="&listType=listPermission&category=${appName }"><a id="btn3" class="no_b_border" href="javascript:void(0)" tgt="tab3_div"><span>${ctp:i18n("infosend.dataBase.index.nodePermissions")}</span></a></li>
                    <%--信息类型管理 --%>
					<li id="listCategoryTab" listType="listCategory" params="&listType=listCategory&appType=${appType }"><a id="btn4" class="no_b_border" href="javascript:void(0)" tgt="tab4_div"><span>${ctp:i18n("infosend.dataBase.index.infoTypeManager")}</span></a></li>
                    <%--信息评分标准设置 --%>
					<li id="listScoreTab" listType="listScore" params="&listType=listScore&appType=${appType }"><a id="btn5" class="no_b_border" style="max-width:120px;" href="javascript:void(0)" tgt="tab5_div"><span>${ctp:i18n("infosend.dataBase.index.infoScoreCriteria")}</span></a></li>
                    <%--期刊版式 --%>
					<li id="listTaohongTab" listType="listTaohong" params="&listType=listTaohong&appType=${appType }"><a id="btn6" class="no_b_border" href="javascript:void(0)" tgt="tab6_div"><span>${ctp:i18n("infosend.dataBase.index.periodicalsFormat")}</span></a></li>
                    <%--报送单元素 --%>
					<li id="listElementTab" listType="listElement" params="&listType=listElement&appType=${appType }"><a id="btn7" class="no_b_border" style="max-width:120px;" href="javascript:void(0)" tgt="tab7_div"><span>${ctp:i18n("infosend.dataBase.index.submitSingleElement")}</span></a></li>
                    <%--开关设置 --%>
                    <li id="switchSettingsTab" listType="switchSettings" params="&listType=switchSettings"><a id="btn8" class="last_tab no_b_border" style="max-width:120px;" href="javascript:void(0)" tgt="tab8_div"><span>${ctp:i18n('infosend.score.switchSet.title')}</span></a></li>
		        </ul>
			</div>
			<div class="hr_heng"></div>
		</div>

    </div>

	<c:if test="${!hasLeft }">
		<div class="layout_west" id="west" layout="border:false">
		   	<jsp:include page="/WEB-INF/jsp/apps/${leftUrl }.jsp" flush="true" />
	   </div>
   </c:if>

	<div class="layout_center" id="center" style="overflow:hidden;" layout="border:false">
		<iframe id="tab_iframe" width="100%" height="100%" frameborder="0"></iframe>
   	</div>

</div>
</body>
</html>
