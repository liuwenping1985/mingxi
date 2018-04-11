<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="docHeader.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<%@ include file="../../common/INC/noCache.jsp"%>
<%@page import="java.util.List" %>
<%@ taglib prefix="ctp" uri="http://www.seeyon.com/ctp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/thirdMenu.js${v3x:resSuffix()}" />"></script>
<link rel="stylesheet" href="<c:url value="/skin/default/skin.css"/>">
<link rel="stylesheet" type="text/css" href="<c:url value="/apps_res/doc/css/doc.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery-debug.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/docFavorite.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/ui/seeyon.ui.tooltip-debug.js${v3x:resSuffix()}" />"></script>
<title>${ctp:i18n('doc.collect.title')}</title>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/apps_res/doc/js/knowledgeBrowseUtils.js" />"></script>
<%@ include file="rightHead.jsp"%>
<script type="text/javascript">
	var myFavority = true;
	docLibType = 1;
	docLibId = "${docLibId}";
	showCtpLocation('F04_myCollection');
<!--
window.onload = function (){
	var condition = "${condition}";
	var value1  = "${value1}";
	var value2  = "${value2}";
	if(condition=='title'){
		document.getElementById("title").value = value1;
	}else if(condition=='userName'){
		document.getElementById("userName").value = value1;
	}else if(condition=='createDate'){
		document.getElementById("fromTime").value = value1;
		document.getElementById("toTime").value = value2;
	}else{
		if(value1==""||value1==null){
			value1 = 1;
		}
		document.getElementById("frType").value = value1;
	}
	try{
		showCondition(condition,value1,value2);
	}catch(e){
	
	}
	
}

function searchMyFavority(){
	var condition = document.searchForm.condition.value;
	var userName = document.getElementById("userName").value;
	var fromTime = document.getElementById("fromTime").value;
	var toTime = document.getElementById("toTime").value;
	var title = document.getElementById("title").value;
	//var frType = document.getElementById("frType").options[document.getElementById("frType").selectedIndex].value;
	var condition = $("#condition option:selected").val();
	var frType = "";
	if(condition == "frType"){
		frType = $("#frType option:selected").val();
	}
    
	if(condition == "createDate"){
		if(fromTime != null && toTime != null ){
			var result = compareDate(fromTime, toTime);
			if(result > 0){
				alert(v3x.getMessage("V3XLang.calendar_endTime_startTime"));
				return ;
			}
		}
	}
	
	window.location.href = docURL + "?method=myCollection&condition="+condition+"&userName=" + encodeURIComponent(userName) + "&fromTime=" + fromTime + "&toTime=" + toTime+ "&title=" + encodeURIComponent(title) + "&frType=" + frType;
}

function selectRow(currentTd){
	var e = v3x.getEvent();
	var tmp;
	if (ie5){
		tmp = e.srcElement;
	}else if (dom){
		tmp = e.target;
	}
	if(tmp.tagName == 'INPUT'){
		return;
	}

	//清零权限列表
	docListAclMap = new Properties();
	docListAclMap.put('parent', new docListAcl('${param.all}', '${param.edit}', '${param.add}',
		'${param.readonly}', '${param.browse}', '${param.list}', 'false', 'false', 'false', appData.doc, 'false'));
	var isV5Member = '${CurrentUser.externalType == 0}';
	if(isV5Member == "true"){
		ctrlDocMenuByAclMap();
	}
	
	var currentTr = getParent(currentTd, "TR");
	var currentTbody = getParent(currentTr, "tbody");
	if(currentTr != null && currentTbody != null){
		redoStyle();
		changeSelectedStyle(currentTr);
		currentSelectTr = currentTr;
		var thisCheckbox = getCheckboxFromTr(currentTr);
		if(thisCheckbox != undefined && thisCheckbox != null) {
			noSelected(thisCheckbox.name);
			if(thisCheckbox.disabled != true){
				thisCheckbox.click();
			}
		}
	}
}

function readyToPersonalLearn(flag){
	if(hasSelectedData()){
		selectPeopleFun_perLearn();
	}else{
		return;
	}
}
//-->
</script>
<style>
/***layout*row1+row2***/
.main_div_row2 {
 width: 100%;
 height: 100%;
 _padding-left:0px;
}
.right_div_row2 {
 width: 100%;
 height: 100%;
 _padding:54px 0px 0px 0px;
}
.main_div_row2>.right_div_row2 {
 width:auto;
 position:absolute;
 left:0px;
 right:0px;
}
.center_div_row2 {
 width: 100%;
 height: 100%;
 /*background-color:#00CCFF;*/
 overflow:auto;
}
.right_div_row2>.center_div_row2 {
 height:auto;
 position:absolute;
 top:82px;
 bottom:0px;
}
.top_div_row2 {
 height:82px;
 width:100%;
 /*background-color:#9933FF;*/
 position:absolute;
 top:0px;
}
/***layout*row1+row2****end**/
.sort img{
	vertical-align: middle;
}
.border_t {
  border-top: 1px solid #dfdfdf;
}
.webfx-menu-bar{ padding-left: 0; }
.mxt-window-footer {line-height: 40px;}
</style>
</head>
<body class="page_color">
<div class="main_div_row2">
	<c:set value="${v3x:currentUser()}" var="currentUser" />
  <div class="right_div_row2 iframeRight border-right" style="border-right-width:0px">
    <div class="top_div_row2" style="min-width:800px">
		<table height="40" border="0" width="100%" cellspacing="0" cellpadding="0" >
				
			<tr>
				<td id="rightMenuBar" height="40" class="webfx-menu-bar"  valign="top">	
					<script>
						//知识管理工具栏菜单
						//是否是V5人员
						var isV5Member = '${CurrentUser.externalType == 0}';
						// 发送到二级菜单
						var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
						var sendToSubItems = new WebFXMenu;
						// 高级二级菜单
						var forwardSubItems = new WebFXMenu;
						if(isV5Member == "true"){
							sendToSubItems.add(new WebFXMenuItem("favorite", "<fmt:message key='doc.menu.sendto.favorite.label'/>", "addMyFavorite('undefined');", ""));
							sendToSubItems.add(new WebFXMenuItem("learning", "<fmt:message key='doc.menu.sendto.learning.label'/>", "readyToPersonalLearn('top')", ""));	
							sendToSubItems.add(new WebFXMenuItem("link", "<fmt:message key='doc.menu.sendto.other.label'/>", "selectDestFolder('undefined','1','1','1','link');", ""));
							
							forwardSubItems.add(new WebFXMenuItem("col", "<fmt:message key='common.toolbar.transmit.col.label' bundle='${v3xCommonI18N}' />", "sendToCollFromMenu()", ""));
							//A6s去掉转发邮件
							var onlyA6s= true;
							if(onlyA6s!="true"){
								forwardSubItems.add(new WebFXMenuItem("mail", "<fmt:message key='common.toolbar.transmit.mail.label' bundle='${v3xCommonI18N}' />", "sendToMailFromMenu()", ""));
							}
							myBar.add(new WebFXMenuButton("sendto", "<fmt:message key='doc.menu.sendto.label'/>", "",[9,1],"<fmt:message key='doc.menu.sendto.label'/>", sendToSubItems));
							myBar.add(new WebFXMenuButton("move", "<fmt:message key='doc.menu.move.label'/>", "selectDestFolder('undefined','1','1','1','move');",[2,1],"<fmt:message key='doc.menu.move.label'/>", null));
							myBar.add(new WebFXMenuButton("forward", "<fmt:message key='common.advance.label' bundle='${v3xCommonI18N}'/>", "",[17,1],"<fmt:message key='common.advance.label' bundle='${v3xCommonI18N}'/>", forwardSubItems));
						}
						myBar.add(new WebFXMenuButton("del", "<fmt:message key='doc.jsp.cancel.collection' bundle='${v3xCommonI18N}' />", "delF('topOperate','topOperate')",[1,3],"<fmt:message key='doc.jsp.cancel.collection' bundle='${v3xCommonI18N}' />", null));
						document.write(myBar);
						
						// 控制菜单操作权限
						//initFun('true', 'true', 'true', 'true', 'true', 'true', 'true', 'false', 'false', 'false', 'false', 'false', 'false', 'false','false','false');
						
					</script>
				</td>
			</tr>
			<tr>
				<td colspan="2" class="main-bg" valign="top">
					<form action="" name="searchForm" id="searchForm" method="post" onSubmit="return false" style="margin: 0px">
			            <div class="div-float-right" style="padding-top:8px;">
			                <div class="div-float">
			                    <select name="condition" id="condition"  onChange="showNextCondition(this)" class="condition">
			                        <option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
									<option value="title"><fmt:message key="doc.search.title.label" bundle="${v3xCommonI18N}" /></option>
			                        <c:if test="${CurrentUser.externalType == 0 }">
				                        <option value="userName"><fmt:message key="doc.search.creator.label" bundle="${v3xCommonI18N}" /></option>
				                        <option value="createDate"><fmt:message key="doc.search.createtime.label" bundle="${v3xCommonI18N}" /></option>
				                        <option value="frType"><fmt:message key="doc.search.category.label" bundle="${v3xCommonI18N}" /></option>
			                        </c:if>
			                    </select>
			                </div>
			                <div id="titleDiv" class="div-float hidden"><input type="text" id="title" name="title" class="textfield"></div>
							<div id="userNameDiv" class="div-float hidden"><input type="text" id="userName" name="userName" class="textfield"></div>
			                <div id="createDateDiv" class="div-float hidden">
			                    <input type="text" class="textfield" id="fromTime" style="cursor:hand;width: 80px;" name="fromTime" onClick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly value="">-
			                    <input type="text" class="textfield" id="toTime" style="cursor:hand;width: 80px;" name="toTime" onClick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly value="">
			                </div>
			                <div id="frTypeDiv" class="div-float hidden">
			                    <select name="frType" id="frType" class="condition">
									<c:forEach items="${types}" var="type">
											<option value="${type.id}" title="${v3x:toHTML(v3x:_(pageContext, type.name))}">
												<c:set var="typeName" value="${v3x:getLimitLengthString(v3x:_(pageContext, type.name), 15,'...')}" />
												${v3x:toHTML(typeName)}
											</option>
									</c:forEach>
			                    </select>
			                </div>
			                <div onClick="searchMyFavority();" class="condition-search-button"></div>
			            </div>
			        </form>

					<div class="body_location" style="border-left:none;border-right:none;border-top:none;border-bottom: none;padding-left: 10px; background-color: white; height: 40px; line-height: 40px; padding:0 10px 0 10px;">
						<fmt:message key='system.menuname.MyCollection' />
					</div>
					<div class="border_t"></div>
				</td>
			</tr>
		</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv" style="overflow: hidden;">
		<div id="ScrollDIV" class="border_l">
			<%@ include file="myFavorityTable.jsp"%>
		</div>
    </div>
	<IFRAME height="0%" name="empty" style="display:none;" id="empty" width="0%" frameborder="0"></IFRAME>
  </div>
</div>
</body>
</html>
