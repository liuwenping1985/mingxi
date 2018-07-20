<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<%@ include file="../include/header.jsp"%>
<%@ include file="../../apps/doc/pigeonholeHeader.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>	
<script type="text/javascript"
	src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<script type="text/javascript">
<!--
var ctxResources = <c:out value="${CurrentUser.resourceJsonStr}" default="null" escapeXml="false"/>;
 	if('${spaceType}' == '4'){
 	   var theHtml=toHtml("${v3x:toHTML(theType.typeName)}",'<fmt:message key="news.title"/><fmt:message key="label.manage"/>');
       showCtpLocation("",{html:theHtml});
    }
 	window.onload = function(){
 	   showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
	if('${showAudit}'=='false') {
		var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	}else {
		var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
	}
	
	var insertImage = new WebFXMenu;
	   insertImage.add(new WebFXMenuItem("focus", "<fmt:message key='news.setFocus' />", "focusNews('${newsDataURL}?method=focus&type=${newsTypeId}&spaceType=${spaceType}&showAudit=${showAudit}&spaceId=${param.spaceId}&custom=${custom}');", ""));
	     insertImage.add(new WebFXMenuItem("cancelfocus", "<fmt:message key='news.cancelFocus' />", "focusNews('${newsDataURL}?method=focus&type=${newsTypeId}&oper=cancel&spaceType=${spaceType}&showAudit=${showAudit}&spaceId=${param.spaceId}&custom=${custom}','cancel');", ""));


    myBar.add(
         new WebFXMenuButton(
              "image", 
              "<fmt:message key='news.focus' />", 
              "", 
              [17,8], 
              "", 
              insertImage
              )
    );
	
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.cancelIssue.label' bundle='${v3xCommonI18N}'/>", 
			"cancelPublishData('${spaceType}', '${newsTypeId}','${showAudit}', 'news');", 
			[5,9], 
			"", 
			null
			)
	);
	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", 
			"deleteRecord('${newsDataURL}?method=delete&spaceType=${spaceType}&newsTypeId=${newsTypeId}&type=${newsTypeId}&showAudit=${showAudit}&custom=${custom}&spaceId=${param.spaceId}');", 
			[1,3], 
			"", 
			null
			)
	);
	<c:if test="${v3x:hasPlugin('doc')}">
		myBar.add(
			new WebFXMenuButton(
				"newBtn", 
				"<fmt:message key='common.toolbar.pigeonhole.label' bundle='${v3xCommonI18N}' />", 
				"myPigeonhole('<%=com.seeyon.v3x.common.constants.ApplicationCategoryEnum.news.key()%>', '${spaceType}', '${newsTypeId}');", 
				[1,9], 
				"", 
				null
				)
		);
	</c:if>
	
	if ('${spaceType}' == '4') {
		var boardManage = new WebFXMenu;	
		boardManage.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.statistics.label' bundle='${v3xCommonI18N}' />", "viewStatistics('${newsDataURL}?method=publishInfoStc&mode=news&spaceType=${spaceType}&spaceId=${param.spaceId}&typeId=${newsTypeId}');"));
		myBar.add(new WebFXMenuButton("boardManage", "<fmt:message key='common.toolbar.boardmanage.label' bundle='${v3xCommonI18N}' />", null, [12,9], "", boardManage));
	} else {
		var boardManage = new WebFXMenu;	
		boardManage.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.auth.label' bundle='${v3xCommonI18N}' />", "selectPeopleFun_newType()"));
		boardManage.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.statistics.label' bundle='${v3xCommonI18N}' />", "viewStatistics('${newsDataURL}?method=publishInfoStc&mode=news&spaceType=${spaceType}&spaceId=${param.spaceId}&typeId=${newsTypeId}');"));
		myBar.add(new WebFXMenuButton("boardManage", "<fmt:message key='common.toolbar.boardmanage.label' bundle='${v3xCommonI18N}' />", null, [12,9], "", boardManage));
		//myBar.add(new WebFXMenuButton("Count", "<fmt:message key='common.toolbar.statistics.label' bundle='${v3xCommonI18N}'/>", "viewStatistics('${newsDataURL}?method=publishInfoStc&mode=news&spaceType=${spaceType}&spaceId=${param.spaceId}&typeId=${newsTypeId}');", [5,10],"", null));
	}
	
 function changeTypeNew(typeId){
 	var _url = '${newsDataURL}?method=listBoardIndex&newsTypeId='+typeId+'&spaceType=${spaceType}&spaceId=${param.spaceId}&type=' + typeId + '&showAudit=' + ${showAudit};
 	parent.parent.location.href = _url;
 }	
 
<c:if test="${fn:length(typeList)>0}">
	var sendToSubItems = new WebFXMenu;
	var moveToType ="";
		<c:forEach items="${typeList}" var="bulTypeItem" varStatus="index">
			sendToSubItems.add(new WebFXMenuItem("bti${index}", "${v3x:toHTML(v3x:getSafeLimitLengthString(bulTypeItem.typeName, 15,'...'))}", "changeTypeNew('${bulTypeItem.id}');", "", "${v3x:toHTML(bulTypeItem.typeName)}"));
			moveToType=moveToType+"${bulTypeItem.id}"+",";
		</c:forEach>
	myBar.add(new WebFXMenuButton("sendto", "<fmt:message key='common.toolbar.board.switch.label' bundle='${v3xCommonI18N}'/>", "", [9,6],"", sendToSubItems));
	myBar.add(new WebFXMenuButton("moveBtn", "<fmt:message key='bulletin.menu.move.label' bundle='${bulI18N}'/>","moveTo(moveToType);",[2,1], "", null));
</c:if>
	
if('${spaceType}' != '3'&&'${spaceType}' != '18'){
	onlyLoginAccount_newType = true;
	hiddenOtherMemberOfTeam_newType = true;
}

isNeedCheckLevelScope_newType = false;

	baseUrl='${newsDataURL}?method=';
	
	function setPeopleFieldsW(elements,type){
		var selectedValue;
		if(!elements){
			selectedValue = "";
		}else{
			selectedValue = getIdsString(elements,true);
		}

		var form_ = document.getElementById("listForm");
		form_.target = "emptyIframe";
		form_.action = "${newsDataURL}?method=configWrite&act=save&typeId=${theType.id}&userIds=" + selectedValue+"&spaceId=${param.spaceId}";
		form_.submit();
		if(selectedValue!=''){
         alert(v3x.getMessage("bulletin.bulletin_boardAuth_success"));
        }
	}

var hiddenPostOfDepartment_newType=true;//岗位去掉


<c:if test="${v3x:hasPlugin('extinterPlugin')}">
<fmt:setBundle basename="com.seeyon.v3x.ext.resources.i18n.ExtResources" var="v3xExtI18N"/>
//branches_a8_v350_r_gov GOV-2343 lijl Add
<fmt:setBundle basename="com.seeyon.v3x.news.resources.i18n.NewsResources" var="newsI18N"/>
var sendName ="";
if("${(v3x:getSysFlagByName('sys_isGovVer')=='true')}"){
	sendName = "<fmt:message key='ext.account.news.push${v3x:suffix()}' bundle='${newsI18N}'/>";	
}else{
	sendName = '${param.type}' == 1 ? "<fmt:message key='ext.org.news.push' bundle='${v3xExtI18N}'/>" : "<fmt:message key='ext.account.news.push' bundle='${v3xExtI18N}'/>";	
}
var bindingType = '${param.type}' == 1 ? 5 : 6;	
myBar.add(
		new WebFXMenuButton(
			"systemSend", 
			sendName,
			"extInterSend();",  
			[4,1], 
			"", 
			null
			)
	);

//branches_a8_v350_r_gov GOV-2343 lijl Add
var pushLog="";
if("${(v3x:getSysFlagByName('sys_isGovVer')=='true')}"){
	pushLog = "<fmt:message key='dee.push.log${v3x:suffix()}' bundle='${newsI18N}'/>";	
}else{
	pushLog = "<fmt:message key='dee.push.log' bundle='${v3xExtI18N}'/>";	
}
myBar.add(new WebFXMenuButton("systemLog",pushLog,"extInterLog();",[4,1],"",null));
</c:if>
<c:if test="${v3x:hasPlugin('websiteIntegrate')}">
myBar.add(
    new WebFXMenuButton(
      "pushOutside", 
      "<fmt:message key='websiteIntegrate.toolbar.buttonname.js'/>",
      "checkPushOutside();",  
      [4,1], 
      "", 
      null
    )
);
var websiteIntegrate = {
    websiteIntegrate_grid_nochoicerow_js:"<fmt:message key='websiteIntegrate.grid.nochoicerow.js'/>",
    websiteIntegrate_push_success_js:"<fmt:message key='websiteIntegrate.push.success.js'/>",
    websiteIntegrate_push_fail_js:"<fmt:message key='websiteIntegrate.push.fail.js'/>",
    websiteIntegrate_push_tryagain_js:"<fmt:message key='websiteIntegrate.push.tryagain.js'/>",
    websiteIntegrate_push_checkpushed_js:"<fmt:message key='websiteIntegrate.push.checkpushed.news.js'/>",
    websiteIntegrate_push_timeout_js:"<fmt:message key='websiteIntegrate.push.timeout.js'/>"
};
</c:if>
if(${outerSpace != null}){
	myBar.add(
			new WebFXMenuButton(
				"outerPushBtn", 
				"推送门户：${outerSpace.sectionLabel}", 
				"outerSectionPush('${newsDataURL}?method=outerSectionPush&sectionId=${outerSpace.id}&spaceType=${spaceType}&newsTypeId=${newsTypeId}&type=${newsTypeId}&showAudit=${showAudit}&custom=${custom}&spaceId=${param.spaceId}','${outerSpace.sectionLabel}');", 
				[1,4], 
				"", 
				null
				)
		);
	myBar.add(
			new WebFXMenuButton(
				"outerDelBtn", 
				"取消推送门户", 
				"outerSectionDel('${newsDataURL}?method=outerSectionCancel&spaceType=${spaceType}&newsTypeId=${newsTypeId}&type=${newsTypeId}&showAudit=${showAudit}&custom=${custom}&spaceId=${param.spaceId}','${outerSpace.sectionLabel}');", 
				[1,5], 
				"", 
				null
				)
		);
	

	}
//-->
</script>
<c:if test="${v3x:hasPlugin('extinterPlugin')}">
<script type="text/javascript" src="<c:url value="/apps_res/ext/js/ext.js${v3x:resSuffix()}" />"></script>
</c:if>
<style>
.webfx-menu-bar {
    height:30px;
    vertical-align: middle;
    background: #ededed;
}
</style>

</head>
<body class="padding5">
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2" style="z-index:9999">
		<c:if test="${v3x:hasPlugin('extinterPlugin')}">
				<%
				request.setCharacterEncoding("UTF-8");
				%>
				<fmt:message key='common.button.ok.label' bundle='${v3xExtI18N}' var='ext_ok'/>
				<fmt:message key='common.button.cancel.label' bundle='${v3xExtI18N}' var='ext_cancel'/>
				<jsp:include page="../../ext_inter/openDiv.jsp">
					<jsp:param name="ok" value="${ext_ok}" />
					<jsp:param name="cancel" value="${ext_cancel}" />
				</jsp:include>	
			</c:if>
		
		<c:set value="${v3x:parseElements(managerId, 'id', 'entityType')}" var="ids"/>
		<v3x:selectPeople id="newType" panels="Department,Post,Level,Team" selectType="Member,Account,Department,Level,Team,Post" minSize="0" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setPeopleFieldsW(elements)" originalElements="${ids}" />
		<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="${showAudit==false?'':''}">
		<tr>
			<td>
			<script type="text/javascript">
			<!--
			<%-- //TODO yangwulin 2012-10-26 <v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/> --%>
				document.write(myBar);	
			//-->
			</script>
			</td>
			<c:if test="${showAudit}">
				<td align="right" class="webfx-menu-bar-gray">
			</c:if>
			<c:if test="${!showAudit}">
				<td align="right" class="webfx-menu-bar">
			</c:if>
			
			
		<form action="${newsDataURL}" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
		    <input type="hidden" value="${spaceType}" name="spaceType" id="spaceType">
			<input type="hidden" value="<c:out value='${param.method}' />" name="method">
			<input type="hidden" value="${theType.id}" name="typeId" id="typeId">
			<input type="hidden" value="${theType.id}" name="type" id="type">
			<input type="hidden" value="${param.spaceId}" name="spaceId" id="spaceId">
			<input type="hidden" value="${showAudit}" name="showAudit" id="showAudit">
			<input type="hidden" name="custom" value="${custom}">
			<div class="div-float-right">
				<div class="div-float">
					<select name="condition" id="condition" 
					onChange="showNextCondition(this)" class="condition">
						<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
						<option value="title"><fmt:message key="news.biaoti.label" /></option>
						<option value="publishUserId"><fmt:message key="news.data.createUser" /></option>
						<option value="keywords"><fmt:message key="news.data.keywords" /></option>
						<option value="brief"><fmt:message key="news.data.brief" /></option>
						<option value="publishDate"><fmt:message key="news.data.publishDate" /></option>
						<option value="updateDate"><fmt:message key="news.data.updateDate" /></option>
					</select>
				</div>
		
				<div id="titleDiv" class="div-float hidden">
					<input type="text" name="textfield"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()">
				</div>
				<div id="publishUserIdDiv" class="div-float hidden">
					<input type="text" name="textfield"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()">
				</div>
				<div id="keywordsDiv" class="div-float hidden">
					<input type="text" name="textfield"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()">
				</div>
				<div id="briefDiv" class="div-float hidden">
					<input type="text" name="textfield"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()">
				</div>
				<div id="publishDateDiv" class="div-float hidden">		
					<input type="text" name="textfield" id="startdate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly > - 
					<input type="text" name="textfield1" id="enddate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly >
				</div>
				<div id="updateDateDiv" class="div-float hidden">		
                    <input type="text" name="textfield" id="startdate1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly > - 
                    <input type="text" name="textfield1" id="enddate1" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly >
                </div>
				<div onclick="javascript:doSearchInq()" class="condition-search-button div-float"></div>
			</div>
		</form>
		</td>
		</tr>
		</table>
    
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<c:set scope="request" var="onDblClick" value="publishDataLine" />
		<c:set scope="request" var="detailMethod" value="userView" />
		<form name="listForm" id="listForm" method="post" >
		<v3x:table htmlId="listTable" data="list" var="bean">
			<v3x:column width="5%" align="center"
				label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" 
									dataState='${bean.state}' focusNews='${bean.focusNews}' attflag="${bean.attachmentsFlag}"
				/>
			</v3x:column>
			<c:set var="click" value="showPageByMethod('${bean.id}','${detailMethod}')"/>
			<v3x:column  type="String" width="45%"
				label="news.biaoti.label" className="sort cursor-hand"
				hasAttachments="${bean.attachmentsFlag}"
				bodyType="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}"		
				maxLength="60" symbol="..." onClick="${click}"  alt="${bean.title}" >
				<c:if test="${bean.focusNews==true}">
					<font color='red'>[<fmt:message key="news.focus" />]</font>
				</c:if>
				${v3x:toHTML(bean.title)}
			</v3x:column>
		
			<v3x:column width="15%" type="String"
				label="news.data.createUser" className="sort cursor-hand" onClick="${click}"
				>
				${ bean.createUserName} 
			</v3x:column>
		
			<v3x:column width="15%" type="Date" label="news.data.publishDate" className="sort cursor-hand" onClick="${click}">
				<fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}"/>
		    </v3x:column>
		    <v3x:column width="10%" type="Date" label="news.data.updateDate" className="sort">
						<fmt:formatDate value="${bean.updateDate}" pattern="${datePattern}"/>
					</v3x:column>
		    <v3x:column width="5%" type="Number" label="news.data.readCount" value="${bean.readCount}"/>
		   <c:if test="${outerSpace != null}">	
		    <v3x:column width="5%" type="Number" label="data.outerspaceFlag" className="sort cursor-hand"
						value="${bean.outerspaceFlag==true ? '是':'否'}"/>
		  </c:if>
		</v3x:table>
		</form>
    </div>
  </div>
</div>

<input type="hidden" id="_custom" name="_custom" value="${custom}">
<script type="text/javascript">
<!--
showDetailPageBaseInfo("detailFrame", "${v3x:toHTML(theType.typeName)}", [2,1], pageQueryMap.get('count'), _("NEWSLang.detail_info_606"));
//-->
</script>
<iframe id="emptyIframeId" name="emptyIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>