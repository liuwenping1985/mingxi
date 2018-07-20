<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="pragma" contect="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<%@ include file="supervision_header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/common_footer.jsp"%>
<title>
<c:if test="${supType == 70}">督查事项台账</c:if>
<c:if test="${supType == 0}">上级交办</c:if>
<c:if test="${supType == 1}">会议议定</c:if>
<c:if test="${supType == 2}">来文办件</c:if>
<c:if test="${supType == 3}">领导批示</c:if>
</title>
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/supervision/css/dialog.css${v3x:resSuffix()}" />">
<script>
$(document).ready(function () {
	$("div.layout_center").height($("#layout").height());
	$("div.layout_west").height($("#layout").height());

	//IE7西面组件显示有问题
	if($("#westSp_layout")!=null) {
		$("#westSp_layout").height($("#layout").height());
		var tableEl = $("#westSp_layout").find("table").eq(0);
		if(tableEl){
			var tempHeight = $("#layout").height();
			tableEl.css("margin-top", (tempHeight - 54)/2);
		}
	}

	//收起首页左导航
	if(getCtpTop() && getCtpTop().$.hideLeftNavigation) {
		getCtpTop().$.hideLeftNavigation();
	}

	//IE7下可能导致Iframe宽度未加载完成的情况下，内部html已经进行加载了
	showList('${supType}','${supMemberIds}');

	//督办人员对于的div铺满剩下的区域
	var h1 = $(".info_left_nav:eq(0)").height();
	var h2 = $(".info_box_display:eq(0)").height();
	$(".info_box_display:eq(1)").css({"height":($(".layout_west").height()-2*h1-h2-65),"overflow-y":"auto"});
});

var oldSupType = '${supType}';//前面选中的菜单类型
var oldSupMember = '${supMemberIds}';
function showList(supType,memberId,isnew){//isnew点击督办人操作
	//根据左侧菜单，top显示
	if(isnew || supType==70){
		$("#headTitle").html("督查事项台账");
	}else if(supType==0){
		$("#headTitle").html("上级交办");
	}else if(supType==1){
		$("#headTitle").html("会议议定");
	}else if(supType==2){
		$("#headTitle").html("来文办件");
	}else if(supType==3){
		$("#headTitle").html("领导批示");
	}else if(supType=='100'){
		$("#headTitle").html("全部");
	}
	if(isnew || supType == 70){//督办人
		supType = 70;
		if(memberId.indexOf(",") == -1){
			$("#member"+memberId).addClass("xl_bg_click");
			if(memberId != oldSupMember){
				if(oldSupMember.indexOf(",") == -1){
					$("#member"+oldSupMember).removeClass("xl_bg_click");
				}
			}
			$("#supType_"+oldSupType).removeClass("xl_bg_click");
			oldSupMember = memberId;
		}else{//领导四大类页面全部
			$("#supType_"+supType).addClass("xl_bg_click");
			$("#member"+oldSupMember).removeClass("xl_bg_click");
			if(supType != oldSupType){
				$("#supType_"+oldSupType).removeClass("xl_bg_click");
			}
			oldSupType = supType;
		}
	}else{//四大分类
		//修改左侧选中样式
		$("#supType_"+supType).addClass("xl_bg_click");
		if(supType != oldSupType){
			$("#supType_"+oldSupType).removeClass("xl_bg_click");
		}
		$("#member"+oldSupMember).removeClass("xl_bg_click");
     oldSupType = supType;
	}
	var url = "${path}/form/formData.do?method=getFormMasterDataList&supType="+supType+"&rCode=${rCode}";
	if(memberId){
		url = url + "&supMemberIds=" + memberId;
	}else{
		url = url + "&supMemberIds=${supMemberIds}";
	}
	if(isnew){
		url = url + "&isPersonal=true";//督办事项台账，表示点击具体的督办人员信息
	}else{
		url = url + "&isPersonal=false";
	}
     $("#tab_iframe").attr("src", url);
}

</script>
</head>
<body class="h100b over_hidden">
<!--第一部分：页面顶端部分-->
	<div class="list-header">
		<!--左边部分-->
		<div class="list-header-left">
			<b></b>
			<span class="list-header-left-title" id="headTitle"></span>
		</div>
		<!--右边部分-->
		<div class="list-header-right">
			<a href="#"></a>
		</div>
	</div>
<div id='layout' class="comp over_hidden" comp="type:'layout'" style="top:-16px;">
	<div class="layout_west over_hidden" layout="width:140,minWidth:50,maxWidth:140,spiretBar:{show:true,handlerL:function(){$('#layout').layout().setWest(0);},handlerR:function(){$('#layout').layout().setWest(130);}}" style="border:none;background:#fff">
		<c:if test="${rCode eq 'F20_SuperviseLeaderSpace' || rCode eq 'F20_SuperviseStaffSpace'}">
			<div class="info_left_nav">
	            <span class="info_report"></span>
	            <span class="info_box_title_font" style="font-family: '黑体'">分类</span>
	            <span class="info_box_title_hook"></span>
	        </div>
			<div class="info_box_display">
			<c:if test="${rCode eq 'F20_SuperviseStaffSpace'}">
				<span id="supType_70" class="resCode" onclick="showList(${supType},'${supMemberIds}')">
	              	全部
	           	</span>
	        </c:if>
	        <c:if test="${rCode eq 'F20_SuperviseLeaderSpace'}">
				<span id="supType_100" class="resCode" onclick="showList(100)">
	              	全部
	           	</span>
	        </c:if>
				<span id="supType_0" class="resCode" onclick="showList(0)">
	              	上级交办
	           	</span>
	           	<span id="supType_1" class="resCode"  onclick="showList(1)">
	            	会议议定
	            </span>
	            <span id="supType_2" class="resCode"  onclick="showList(2)">
	            	来文办件
	            </span>
		        <span id="supType_3" class="resCode"  onclick="showList(3)">
	            	领导批示
	            </span>
	        </div>
        </c:if>
        <c:if test="${rCode eq 'F20_SuperviseStaffSpace'}">
	        <div class="info_left_nav">
	               <span class="info_report info_report_person"></span>
	            <span class="info_box_title_font" style="font-family: '黑体'">督办人员</span>
	            <span class="info_box_title_hook"></span>
	        </div>
			<div class="info_box_display" style="height: 100%">
	         <c:forEach var="member" items="${memebers}" varStatus="i">
                  <span id="member${member.id }" class="resCode" onclick="showList('${supType}','${member.id }',true)">
	              	${member.name }
	           	</span>
             </c:forEach>
	        </div>
        </c:if>
	</div>
	<div class="layout_center over_hidden">
		<iframe id="tab_iframe" width="100%" height="100%" frameborder="0"></iframe>
	</div>
</div>

</body>
</html>
