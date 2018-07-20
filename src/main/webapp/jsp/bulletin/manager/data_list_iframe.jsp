<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ include file="../include/taglib.jsp"%>
<html>
<head>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
${v3x:skin()}
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
<script type="text/javascript">
<!--
var ctxResources = <c:out value="${CurrentUser.resourceJsonStr}" default="null" escapeXml="false"/>;
	if('${spaceType}' == '1'){
	  var theHtml=toHtml("${v3x:toHTML(theType.typeName)}",'<fmt:message key="bulletin.label.1"/><fmt:message key="oper.manage"/>');
      showCtpLocation("",{html:theHtml});
	}
	if('${spaceType}' == '4'){
	  var theHtml=toHtml("${v3x:toHTML(theType.typeName)}",'<fmt:message key="bul.data_shortname"/><fmt:message key="oper.manage"/>');
	  showCtpLocation("",{html:theHtml});
	}
	window.onload = function(){	
		if('${v3x:escapeJavascript(param.condition)}' == '')
			return;
		if('${v3x:escapeJavascript(param.condition)}' == 'publishUserId')
			bulShowCondition("${v3x:escapeJavascript(param.condition)}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", '${param.showPer}');	
		else 
			showCondition("${v3x:escapeJavascript(param.condition)}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "${param.textfield1}");		
	}
	function changeTypeNew(typeId){
 		var _url = '${bulDataURL}?method=listBoardIndex&bulTypeId='+typeId+'&spaceType=${spaceType}&type=' + typeId +'&showAudit=${v3x:escapeJavascript(showAudit)}&spaceId=${param.spaceId}';
 		parent.parent.location.href = _url;
 	}	
	function changeDepartment(typeId){
 		var _url = '${bulDataURL}?method=listMain&spaceType=${v3x:escapeJavascript(param.spaceType)}&type='+typeId;
 		parent.location.href = _url;
 	}
	var myBar; 
	if('${spaceType}' == '2'||'${spaceType}' == '4'|| '${v3x:escapeJavascript(showAudit)}'=='false' )
		myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	else
		myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
	
	var operTop = new WebFXMenu;
    	operTop.add(new WebFXMenuItem("top", "<fmt:message key='oper.set' /><fmt:message key='oper.top' />", "topData('${bulDataURL}?method=top&bulTypeId=${bulTypeId}&type=${bulTypeId}&spaceType=${spaceType}&showAudit=${v3x:escapeJavascript(showAudit)}&spaceId=${param.spaceId}','${topCount}', '${topedCount}');", ""));
		operTop.add(new WebFXMenuItem("canceltop", "<fmt:message key='oper.cancel' /><fmt:message key='oper.top' />", "topData('${bulDataURL}?method=top&spaceType=${spaceType}&bulTypeId=${bulTypeId}&type=${bulTypeId}&oper=cancel&showAudit=${v3x:escapeJavascript(showAudit)}&spaceId=${param.spaceId}','${topCount}', '${topedCount}', 'cancel');", ""));
	myBar.add(
		new WebFXMenuButton(
			"operTop", 
			"<fmt:message key='common.toolbar.oper.top.label' bundle='${v3xCommonI18N}'/>", 
			null, 
			[5,8], 
			"", 
			operTop
			)
	);
	myBar.add(
		new WebFXMenuButton("cancelPublish",
		 	"<fmt:message key='common.toolbar.cancelIssue.label' bundle='${v3xCommonI18N}'/>", 
		 	"cancelPublishData('${spaceType}', '${bulTypeId}','${v3x:escapeJavascript(showAudit)}');", 
		 	[5,9], 
		 	"", 
		 	null
		 	)
	);
	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", 
			"deleteRecord('${bulDataURL}?method=delete&spaceType=${spaceType}&bulTypeId=${bulTypeId}&type=${bulTypeId}&showAudit=${v3x:escapeJavascript(showAudit)}&spaceId=${param.spaceId}');", 
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
				"myPigeonhole('<%=com.seeyon.v3x.common.constants.ApplicationCategoryEnum.bulletin.key()%>', '${spaceType}', '${bulTypeId}');", 
				[1,9], 
				"", 
				null
				)
		);
	</c:if>
	var boardManage = new WebFXMenu;
	if ('${spaceType}' == '4') {
		boardManage.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.statistics.label' bundle='${v3xCommonI18N}' />", "viewStatistics('${newsURL}?method=publishInfoStc&mode=bulletin&typeId=${bulTypeId}&type=byRead&typeId=${bulTypeId}&spaceId=${param.spaceId}');"));
	} else {
		if('${spaceType}' != '1'){
			boardManage.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.auth.label' bundle='${v3xCommonI18N}' />", "selectPeopleFun_bulType()"));
		}
		boardManage.add(new WebFXMenuItem("", "<fmt:message key='common.toolbar.statistics.label' bundle='${v3xCommonI18N}' />", "viewStatistics('${newsURL}?method=publishInfoStc&mode=bulletin&typeId=${bulTypeId}&type=byRead&typeId=${bulTypeId}&spaceId=${param.spaceId}');"));
   }
	myBar.add(new WebFXMenuButton("boardManage", "<fmt:message key='common.toolbar.boardmanage.label' bundle='${v3xCommonI18N}' />", null, [12,9], "", boardManage));
	
<c:choose>

	<c:when test="${spaceType ne '1'}">
		<c:if test="${fn:length(typeList)>0}">
			var sendToSubItems = new WebFXMenu;
			var moveToType ="";
			<c:forEach items="${typeList}" var="bulTypeItem" varStatus="index">
				sendToSubItems.add(new WebFXMenuItem("bti${index}", "${v3x:toHTML(v3x:getSafeLimitLengthString(bulTypeItem.typeName, 15,'...'))}", "changeTypeNew('${bulTypeItem.id}');", "", "${v3x:toHTML(bulTypeItem.typeName)}"));
				moveToType=moveToType+"${bulTypeItem.id}"+",";
			</c:forEach>
			myBar.add(new WebFXMenuButton("sendto", "<fmt:message key='common.toolbar.board.switch.label' bundle='${v3xCommonI18N}'/>", "", [9,6],"", sendToSubItems));
			myBar.add(new WebFXMenuButton("moveBtn", "<fmt:message key='bulletin.menu.move.label'/>","moveTo(moveToType);",[2,1], "", null));
		</c:if>
	</c:when>
	<c:otherwise>
		<c:if test="${deptSpaceModelsLength>1}">
			var changeDepartemtMenu = new WebFXMenu;
			<c:forEach items="${deptSpaceModels}" var="deptSpace" varStatus="index">
			  <c:if test="${deptSpace.entityId != bulTypeId}">
				changeDepartemtMenu.add(new WebFXMenuItem("deptSpace${index}", "${v3x:getSafeLimitLengthString(deptSpace.spacename, 15,'...')}", "changeDepartment('${deptSpace.entityId}');", "", "${v3x:toHTML(deptSpace.spacename)}"));
			   </c:if>
			 </c:forEach>
			myBar.add(new WebFXMenuButton("sendto", "<fmt:message key='bull.board.change'/>", "", [9,6],"", changeDepartemtMenu));
		</c:if>
	</c:otherwise>
</c:choose>

	baseUrl='${bulDataURL}?method=';
	function saveForm(operType){
		$('form_oper').value=operType;
		$('dataForm').submit();
	}
		
	if('${spaceType}' == '1' ||'${spaceType}' == '2'){
	  onlyLoginAccount_bulType = true;
	}
    isNeedCheckLevelScope_bulType = false;
	
	function setPeopleFieldsW(elements,type){
		var selectedValue;
		if(!elements){
			selectedValue = "";
		}else{
			selectedValue = getIdsString(elements,true);
		}
		
		document.getElementById("userIds").value = selectedValue;
		var form_ = document.getElementById("listForm");
		form_.target = "emptyIframe";
		form_.action = "${bulDataURL}?method=configWrite&act=save&typeId=${theType.id}&spaceId=${param.spaceId}";
		form_.submit();
	    if(selectedValue!=''){
	      alert(v3x.getMessage("bulletin.bulletin_boardAuth_success"));
	    }
	}

var hiddenPostOfDepartment_bulType=true;

if('${spaceType}' != '3') {
	hiddenOtherMemberOfTeam_bulType = true;
}


<c:if test="${v3x:hasPlugin('extinterPlugin')}">
<fmt:setBundle basename="com.seeyon.v3x.ext.resources.i18n.ExtResources" var="v3xExtI18N"/>
var sendName = '${v3x:escapeJavascript(param.type)}' == 1 ? "<fmt:message key='ext.org.bulletin.push' bundle='${v3xExtI18N}'/>" : "<fmt:message key='ext.account.bulletin.push' bundle='${v3xExtI18N}'/>";
var bindingType = '${v3x:escapeJavascript(param.type)}' == 1 ? 3 : 4;
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

myBar.add(
		new WebFXMenuButton(
			"systemLog", 
			"<fmt:message key='dee.push.log' bundle='${v3xExtI18N}'/>",
			"extInterLog();",  
			[4,1], 
			"", 
			null
			)
	);
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
</c:if>
var websiteIntegrate = {
    websiteIntegrate_grid_nochoicerow_js:"<fmt:message key='websiteIntegrate.grid.nochoicerow.js'/>",
    websiteIntegrate_push_success_js:"<fmt:message key='websiteIntegrate.push.success.js'/>",
    websiteIntegrate_push_fail_js:"<fmt:message key='websiteIntegrate.push.fail.js'/>",
    websiteIntegrate_push_tryagain_js:"<fmt:message key='websiteIntegrate.push.tryagain.js'/>",
    websiteIntegrate_push_checkpushed_js:"<fmt:message key='websiteIntegrate.push.checkpushed.buls.js'/>",
    websiteIntegrate_push_timeout_js:"<fmt:message key='websiteIntegrate.push.timeout.js'/>"
};

if(${outerSpace != null}){
	myBar.add(
			new WebFXMenuButton(
				"outerPushBtn", 
				"推送门户：${outerSpace.sectionLabel}", 
				"outerSectionPush('${bulDataURL}?method=outerSectionPush&sectionId=${outerSpace.id}&spaceType=${spaceType}&bulTypeId=${bulTypeId}&type=${bulTypeId}&showAudit=${v3x:escapeJavascript(showAudit)}&spaceId=${param.spaceId}','${outerSpace.sectionLabel}');", 
				[1,4], 
				"", 
				null
				)
		);
	myBar.add(
			new WebFXMenuButton(
				"outerDelBtn", 
				"取消推送门户", 
				"outerSectionDel('${bulDataURL}?method=outerSectionCancel&spaceType=${spaceType}&bulTypeId=${bulTypeId}&type=${bulTypeId}&showAudit=${v3x:escapeJavascript(showAudit)}&spaceId=${param.spaceId}','${outerSpace.sectionLabel}');", 
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
	
	<script type="text/javascript">
	 <!--
	 var includeElements_bulType = "${v3x:parseElementsOfTypeAndId(entity)}";
	 //-->
	 </script>
		<c:set value="${v3x:parseElements(managerId, 'id', 'entityType')}" var="ids"/>
		<v3x:selectPeople id="bulType" panels="Department,Post,Level,Team" selectType="Member,Account,Department,Level,Team,Post" minSize="0" 
		departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setPeopleFieldsW(elements)" originalElements="${ids}"/>
	
	<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="${(spaceType==2 || showAudit==false)?'':''}">
	<tr height="22" valign="top" class="webfx-menu-bar">
		<td class="" ${v3x:outConditionExpression(spaceType=='2', '', '')}>
		<script type="text/javascript">
		<!--
		//TODO zhangxw 2012-10-26 v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
		document.write(myBar);
		//-->		
		</script>
		</td>
		<td align="right" class="webfx-menu-bar${v3x:outConditionExpression(showAudit, '-gray', '')}" ${v3x:outConditionExpression(spaceType=='2', '', '')}>
		<form action="${bulDataURL}" name="searchForm" id="searchForm" method="post" onsubmit="return false" style="margin: 0px">
		<input type="hidden" value="<c:out value='${param.method}' />" name="method">
		<input type="hidden" value="${theType.id}" name="type" id="type">
		<input type="hidden" value="${spaceType}" name="spaceType" id="spaceType">
		<input type="hidden" value="${v3x:toHTML(showAudit)}" name="showAudit" id="showAudit">
		<input type="hidden" value="${param.spaceId}" name="spaceId" id="spaceId">
		<input type="hidden" value="${v3x:toHTML(param.custom)}" name="_custom" id="_custom">
		<div class="div-float-right">
			<div class="div-float">
				<select name="condition"  id="condition"
				onChange="showNextCondition(this)" class="condition">
					<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
					<option value="title"><fmt:message key="bul.biaoti.label" /></option>
					<option value="publishUserId"><fmt:message key="bul.data.createUser" /></option>
					<option value="publishDepartmentName"><fmt:message key="bul.data.publishDepartmentId" /></option>
					<option value="publishDate"><fmt:message key="bul.data.publishDate" /></option>
					<option value="updateDate"><fmt:message key="bul.data.updateDate" /></option>
				</select>
			</div>
			<div id="titleDiv" class="div-float hidden">
				<input type="text" name="textfield" id="titleInput"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()">
			</div>
			<div id="publishUserIdDiv" class="div-float hidden">
				<input type="text" name="textfield" id="publishUserIdInput"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()">
			</div>
			<div id="publishDepartmentNameDiv" class="div-float hidden">
				<input type="text" name="textfield" id="publishDepartmentNameInput"  maxlength="50" class="textfield" onkeydown="javascript:searchWithKey()">
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
		<input type="hidden" value="" name="userIds" id="userIds">
		<v3x:table htmlId="listTable" data="list" var="bean" >
			<v3x:column width="5%" align="center"
				label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' id='id' name='id' value='<c:out value="${bean.id}"/>' dataName='${bean.title}'
					dataState='${bean.state}' dataTopOrder='${bean.topOrder}' attFlag="${bean.attachmentsFlag}"
				/>
			</v3x:column>
			
			<c:set var="topStr" value="" />
			<c:set var="click" value="showPageByMethod('${bean.id}','${detailMethod}')" />

			<v3x:column  type="String" onClick="${click}"
				label="bul.biaoti.label" className="sort cursor-hand"
				hasAttachments="${bean.attachmentsFlag}"
				bodyType="${empty bean.ext5 ? bean.dataFormat : 'Pdf'}"
				alt="${bean.title}"
				symbol="..."
				width="19%">
				<c:if test="${bean.topOrder>0}">
					<font color='red'>[<fmt:message key="label.top" />]</font>
				</c:if>
                ${v3x:toHTML(bean.title)}
			</v3x:column>
			
	
			<v3x:column width="16%" type="String" onClick="${click}"
				label="common.issueScope.label" className="sort cursor-hand"
				maxLength="20" value="${v3x:showOrgEntitiesOfTypeAndId(bean.publishScope, pageContext)}" symbol="..."/>
				
			 <v3x:column width="14%" type="String"
                            label="bul.data.publishDepartmentId" className="${readStyle}-span sort" value="${bean.publishDeptName}"
                            alt="${bean.publishDeptName}" />
	
			<v3x:column width="12%" type="String" onClick="${click}"
				label="bul.data.createUser" className="sort cursor-hand" maxLength="12" symbol="..."
				value="${bean.publishMemberName}">
			</v3x:column>
			
		    <v3x:column width="12%" type="Date" onClick="${click}" label="bul.data.publishDate">
				<fmt:formatDate value="${bean.publishDate}" pattern="${datePattern}"/>
		    </v3x:column>
		    <v3x:column width="12%" type="Date" onClick="${click}" label="bul.data.updateDate">
				<fmt:formatDate value="${bean.updateDate}" pattern="${datePattern}"/>
		    </v3x:column>
		    <v3x:column width="5%" type="String" label="bul.data.readCount" className="${readStyle}-span sort"
						value="${bean.readCount}"/>
			<c:if test="${outerSpace != null}">			
			<v3x:column width="5%" type="String" label="data.outerspaceFlag" className="sort cursor-hand"
						value="${bean.outerspaceFlag==true ? '是':'否'}"/>
			</c:if>
		</v3x:table>
		</form>
		<%@ include file="../../apps/doc/pigeonholeHeader.jsp"%>
    </div>
  </div>
</div>

<script type="text/javascript">
<!--
if('${spaceType}' == '2') {
	showDetailPageBaseInfo("detailFrame", "${v3x:toHTML(theType.typeName)}", "/common/images/detailBannner/605.gif", pageQueryMap.get('count'), _("bulletin.detail_info_606_2"));
} else {
	showDetailPageBaseInfo("detailFrame", "${v3x:toHTML(theType.typeName)}", "/common/images/detailBannner/605.gif", pageQueryMap.get('count'), _("bulletin.detail_info_606"));
}
//-->
</script>
<iframe name="emptyIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
</body>
</html>