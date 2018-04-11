<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="edocHeader.jsp" %>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
var jsEdocType=${edocType};

var isEdocCreateRole=${isEdocCreateRole?'true':'false'};
var list = "${param.list}";

/**********退回************/
function distributeRetreat(){
	var theForm = document.getElementsByName("listForm")[0];
    if (!theForm) {
        return false;
    }
	var id_checkbox = document.getElementsByName("id");
	var hasMoreElement = false;
    var len = id_checkbox.length;
    var countChecked = 0;
    var obj;
    for (var i = 0; i < len; i++) {
        if (id_checkbox[i].checked) {
        	obj = id_checkbox[i];
            hasMoreElement = true;
            countChecked++;
        }
    } 
    //请选择要回退的公文
    if (!hasMoreElement) {
        alert(v3x.getMessage("edocLang.edoc_alertStepBackItem"));
        return true;
    }
  	//只能选择一项公文进行回退
    if(countChecked > 1){
    	alert(v3x.getMessage("edocLang.edoc_alertSelectStepBackOnlyOne"));
        return true;
    }
    //确认要退回该公文吗? 该操作不能恢复
    if (!window.confirm(_("edocLang.edoc_confirmStepBackItem"))) {
        return;
    }
    var summaryId=obj.value;
    try {
		var requestCaller = new XMLHttpRequestCaller(this, "ajaxEdocController", "checkDistributeRetreat", false);
		requestCaller.addParameter(1, "String", summaryId);
		var rs = requestCaller.serviceRequest();
		var ret = rs.split("|");
		if(ret[1] != "") {
			alert("<fmt:message key='edoc.paper.received'/>"+ret[1]+"<fmt:message key='edoc.not.back'/>");//alert("纸质收文《"+ret[1]+"》不允许退回操作。");
			return false;
		}
	}
	catch (ex1) {
		alert("Exception : " + ex1);
		return false;
	}
	
    var resgisteringEdocId = summaryId; 
		var returnValues = v3x.openWindow({
	        url:'exchangeEdoc.do?method=openStepBackDistribute&resgisteringEdocId='+resgisteringEdocId,
	        width:"400",
	        height:"300",
	        resizable:"0",
	        scrollbars:"true",
	        dialogType:"modal"
	        });
		if(returnValues!=null && returnValues != undefined){
			if(1==returnValues[0]){
				theForm.action = genericURL+'?method=distributeRetreat&id='+summaryId+'&stepBackInfo='+encodeURIComponent(returnValues[3]);
				theForm.method = "POST";
				theForm.submit();
			}
		}
}
function setSearchPeopleFields(elements, namesId, valueId) {
	document.getElementById(valueId).value = getIdsString(elements, false);
	document.getElementById(namesId).value = getNamesString(elements);
	document.getElementById(namesId).title = getNamesString(elements);
}

function Search(){

	
	var dateDiv = document.getElementById("backDateDiv");
	if(dateDiv.style.display == "block" && document.getElementById("fromDate").value!="" && document.getElementById("fromDate").value!="") {
		if(compareDate(document.getElementById("fromDate").value,document.getElementById("toDate").value)>0) {
		    alert("<fmt:message key='edoc.timevalidate'/>");
		    return;
		}
	}
	doSearch();
}
	
</script>
<style>
SELECT{
		FONT-SIZE: 10pt; 
		FONT-FAMILY: Times New Roman;
		MARGIN-TOP:1px;		
}
</style>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body scroll="no" onload="setMenuState('menu_darft');">
<div class="main_div_row2">
  		<div class="right_div_row2">
    		     <div class="top_div_row2">
<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22" class="webfx-menu-bar">
	    	<script type="text/javascript">
	    	var edocContorller="${detailURL}";
	    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");

	    	myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.repeal.label' bundle='${v3xCommonI18N}'/>", "javascript:cancelBackEdoc('pending')", [3,8], "", null));
			if(v3x.getBrowserFlag('hideMenu')){
				myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.send.label' bundle='${v3xCommonI18N}' />", "javascript:sendFromWaitSend()", [1,4], "", null));
			}
	    	if(v3x.getBrowserFlag('hideMenu')){
	    		myBar.add(new WebFXMenuButton("edit", "<fmt:message key='common.toolbar.edit.label' bundle='${v3xCommonI18N}' />", "javascript:editFromWaitSend(1, 'listBox')", [1,2], "", null));
	    	}
	    	if(list=="draftBox"){
	    		myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "javascript:deleteItems('draft')", [1,3], "", null));
	    	}
	    	//lijl注销
			//myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "javascript:deleteItems('draft')", [1,3], "", null));    	
			if(list=="retreat" || list=="draftBox") {
				myBar.add(new WebFXMenuButton("", "<fmt:message key='menu.edocNew.return'/>", "javascript:distributeRetreat()", [4,1], "", null));
			}
			<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
	    	document.write(myBar.toString());
	    	document.close();
	    	</script>			
		</td>
		<td class="webfx-menu-bar"><form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
		<v3x:selectPeople id="createUser" panels="Department,Team" selectType="Member" departmentId="${currentUser.departmentId}" jsFunction="setSearchPeopleFields(elements, 'createUserName', 'createUserId')" minSize="0" maxSize="1" />
			<input type="hidden" value="<c:out value='${param.method}' />" name="method">
			<input type="hidden" value="${param.list }" name="list">
			<input type="hidden" value="1" name="subState">
			<input type="hidden" value="<c:out value='${edocType}' />" name="edocType">
			<input type="hidden" value="${param.subType }" name="subType"/>	
			<div class="div-float-right">
				<div class="div-float">
					<select name="condition" onChange="showNextSpecialCondition(this)" class="condition">
				    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
					    <option value="subject"><fmt:message key="common.subject.label" bundle="${v3xCommonI18N}" /></option>
					    <option value="docMark"><fmt:message key="edoc.element.wordno.label" /></option>
					    <option value="docInMark"><fmt:message key="edoc.element.wordinno.label" /></option>
					    <option value="backBoxPeople"><fmt:message key="edoc.supervise.people" /></option>
					    <option value="backDate"><fmt:message key="edoc.supervise.date" /></option>
					    <c:if test="${edocType==0}">
					    <option value="backBox"><fmt:message key="edoc.supervise.back" /></option>
					    </c:if>
				  	</select>
			  	</div> 
			  	<div id="subjectDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	<div id="docMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	<div id="docInMarkDiv" class="div-float hidden"><input type="text" name="textfield" class="textfield"></div>
			  	<div id="backBoxPeopleDiv" class="div-float hidden">
			  	<input type="text" name="textfield"  class="textfield" >
			  	</div>
			  	<div id="backDateDiv" class="div-float hidden">
			  		<input type="text" name="textfield" id="fromDate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,575,140);" readonly>
			  		-
			  		<input type="text" name="textfield1" id="toDate" class="input-date" onclick="whenstart('${pageContext.request.contextPath}',this,675,140);" readonly>
			  	</div>
			  	<div id="backBoxDiv" class="div-float hidden">
			  		<select name="textfield" class="condition" style="width:90px">
			  			<option value=""><fmt:message key="common.pleaseSelect.label" /></option>
			  			<option value="2"><fmt:message key="edoc.supervise.back.2" /></option>
			  			<option value="4"><fmt:message key="edoc.supervise.back.4" /></option>
			  		</select>			
			  	</div>
			  	<div onclick="javascript:Search()" class="condition-search-button"></div>
		  	</div></form>
		</td>		
	</tr>                              
	</table>
             </div>
    <div class="center_div_row2" id="scrollListDiv">
		
			<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
			<input type="hidden" value="" name="docBack" />
			<input type="hidden" name="edocType" value="${edocType}"/>
			<input type="hidden" value="${param.list }" name="list">
			<input type="hidden" name="__ActionToken" readonly value="SEEYON_A8" > <%-- post提交的标示，先写死，后续动态 --%>
			<!-- 接收从弹出页面提交过来的数据 -->
			<input type="hidden" name="popJsonId" id="popJsonId" value="">
			<input type="hidden" name="popNodeSelected" id="popNodeSelected" value="">
			<input type="hidden" name="popNodeCondition" id="popNodeCondition" value="">
			<input type="hidden" name="popNodeNewFlow" id="popNodeNewFlow" value="">
			<input type="hidden" name="allNodes" id="allNodes" value="">
			<input type="hidden" name="nodeCount" id="nodeCount" value="">
			<input type="hidden" name="isSendBackBox" id="isSendBackBox" value="${param.subState==4}">
			<v3x:table htmlId="pending" data="pendingList" var="col" className="sort ellipsis edocellipsis">
                <v3x:column width="3%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
					<input type='checkbox' name='id' value="${col.summary.id}" affairId="${col.affairId}" caseId="${col.summary.caseId}" processId="${col.summary.processId }" templeteId="${col.summary.templeteId }" substate="${col.affair.subState}"/>
				</v3x:column>			
				<c:set value="${v3x:escapeJavascript(col.summary.subject)}" var="subject"  />

				<!-- lijl update click 注销的click是进入编辑状态 -->
<!--				<c:set var="click" value="editWaitSend('${col.summary.id}','${col.affairId}',1)"/>-->
				<c:set var="click" value="openDetail('', 'from=sended&affairId=${col.affairId}&from=Pending')"/>
				<c:set var="isRead" value="true"/>
				<v3x:column width="4%" type="String" label="edoc.element.secretlevel.simple" className="cursor-hand sort" read="${isRead}"
				  onClick="${click}">
				<span title="<v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/>"><v3x:metadataItemLabel metadata="${colMetadata.edoc_secret_level}" value="${col.summary.secretLevel}"/></span>&nbsp;
				</v3x:column>
				<v3x:column width="20%"  type="String" label="common.subject.label" className="cursor-hand sort mxtgrid_black" read="${isRead}" importantLevel="${col.summary.urgentLevel}" 
				bodyType="${col.bodyType}"  value="${col.summary.subject}" alt="${col.summary.subject}" hasAttachments="${col.summary.hasAttachments}"  onClick="${click}" />
				
				<v3x:column width="13%"  type="String" label="edoc.element.wordno.label" className="cursor-hand sort" read="${isRead}"
				alt="${col.summary.docMark}"  onClick="${click}">
					<span title="${v3x:toHTML(col.summary.docMark)}">${v3x:toHTML(col.summary.docMark)}</span>&nbsp;
				</v3x:column>
				<v3x:column width="12%"  type="String" label="edoc.element.wordinno.label" className="cursor-hand sort" read="${isRead}"
				value="${col.summary.serialNo}" alt="${col.summary.serialNo}"  onClick="${click}" />				
				<v3x:column width="10%" type="Date" label="edoc.supervise.startdate" className="cursor-hand sort" read="${isRead}"
				 onClick="${click}">
					<span title="<fmt:formatDate value="${col.summary.createTime}" pattern="${datePattern}"/>"><fmt:formatDate value="${col.summary.createTime}" pattern="${datePattern}"/></span>&nbsp;
				</v3x:column>
				<v3x:column width="10%" type="String" label="edoc.supervise.date" className="cursor-hand sort deadline-${col.affair.updateDate}" 
				read="${isRead}"  onClick="${click}" alt="${v3x:_(pageContext, isOvertop)}">
					<span title="<fmt:formatDate value="${col.affair.updateDate}" pattern="${datePattern}"/>"><fmt:formatDate value="${col.affair.updateDate}" pattern="${datePattern}"/></span>
				</v3x:column>
				 <v3x:column width="10%" type="String" label="edoc.supervise.people" className="cursor-hand sort deadline-${col.affair.extProps.stepBackName}" 
				read="${isRead}"  onClick="${click}" alt="${v3x:_(pageContext, isOvertop)}" value="${col.affair.extProps.stepBackName}"/>
				 
				<v3x:column width="10%" type="String" label="edoc.supervise.back" className="cursor-hand sort deadline-${col.summary.worklfowTimeout}" 
				read="${isRead}"  onClick="${click}" alt="${v3x:_(pageContext, isOvertop)}" >
				  <c:if test="${col.affair.subState==2}"><fmt:message key="edoc.supervise.back.2" /></c:if>
				   <c:if test="${col.affair.subState==4}"><fmt:message key="edoc.supervise.back.4" /></c:if>
				</v3x:column>
				<v3x:column width="8%" type="String" align="center" label="processLog.list.title.label" >
					<span onclick="showDetailAndLog('${col.summary.id}','${col.summary.processId}','','${col.summary.edocTypeEnum}');" class="icon_com display_block flowdaily_com cursor-hand"></span>
				</v3x:column>			
			</v3x:table>
			<div style="display:none" id="processModeSelectorContainer">
			</div>
			
			</form>  
			</form>  
		</div>
  </div>
</div>
<%--<c:if test="${not empty flash}" >
    <c:out value="${flash}" escapeXml="false" />
</c:if>--%>
<iframe name=tempIframe id=tempIframe style="height:0px;width:0px;"></iframe>
<script type="text/javascript">
<!--
initIpadScroll("scrollListDiv",550,870);
//showDetailPageBaseInfo("detailFrame", "<fmt:message key='edoc.workitem.state.darft' />", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_2011"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
//-->
initIpadScroll("scrollListDiv",550,870);
</script>
</body>
</html>