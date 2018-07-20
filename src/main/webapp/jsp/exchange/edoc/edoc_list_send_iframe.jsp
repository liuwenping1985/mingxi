<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="../exchangeHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<style>
.mxtgrid div.bDiv td div{
	padding-bottom:2px;
	padding-top:2px;
	height:auto;
	line-height:1.5;
}
</style>
<c:if test="${v3x:hasPlugin('extinterPlugin') }">
	<fmt:setBundle basename="com.seeyon.v3x.ext.resources.i18n.ExtResources" var="v3xExtI18N"/>
</c:if>
<script type="text/javascript">

baseUrl='${exchangeEdoc}?method=';

try {
	getA8Top().endProc('');
} catch(e) {}

function deleteItem() {
	var checkedIds = document.getElementsByName('id');
	var len = checkedIds.length;
	var objs = [];
	var k = 0;
	for(var i = 0; i < len; i++) {
		var checkedId = checkedIds[i];
		if(checkedId && checkedId.checked) {
			objs[k++] = checkedId;
		}
	}
	if(objs.length == 0) {
		alert("<fmt:message key='edoc.delete.alert.label' bundle='${edocI18N}'/>");
		return false;
	}
	if(window.confirm("<fmt:message key='edoc.deleteconfirm.alert.label' bundle='${edocI18N}'/>")){
		var theForm = document.getElementsByName("listForm")[0];
		theForm.action ='${exchangeEdoc}?method=edocDelete&listType=${param.listType}';
        theForm.target = "tempIframe";
        theForm.method = "POST";
		for(var i = 0; i < objs.length; i++) {
			var checkedId = objs[i];
			var idInput = document.createElement("input");
			idInput.name = "sendRecordId";
			idInput.type = "hidden";
			idInput.value = checkedId.value;
			theForm.appendChild(idInput);
			var subjectInput = document.createElement("input");
			subjectInput.name = "subject";
			subjectInput.type = "hidden";
			subjectInput.value = checkedId.getAttribute("subject");
			theForm.appendChild(subjectInput);
		}
        theForm.submit();
        return true;
	}
}	

function editItem(id){
	//if(v3x.getBrowserFlag('pageBreak')){
	//	parent.detailFrame.window.location='${exchangeEdoc}?method=edit&id='+id+'&modelType=sent';
	//}else{
		v3x.openWindow({
	     	url: '${exchangeEdoc}?method=edit&id='+id+'&modelType=sent',
	     	dialogType:'open',
	     	FullScrean: 'yes'
		});
	//}
}

function showByStatus(){
	window.document.searchForm.submit();
}
	
function showReSend(id){
	parent.listFrame.location='${exchangeEdoc}?method=sendDetail&id='+id+'&modelType=toSend&reSend=true';
}

//lijl添加,GOV-1728.公文管理-发文管理-分发-已分发,点击【补发】，在框架内显示了.
function editItem1(id){
	//if(v3x.getBrowserFlag('pageBreak')){
	//	parent.detailFrame.window.location='${exchangeEdoc}?method=sendDetail&id='+id+'&modelType=toSend&fromlist=true';
	//}else{
		v3x.openWindow({
	     	url: '${exchangeEdoc}?method=sendDetail&id='+id+'&modelType=toSend&reSend=true',
	     	width:'100%',
	     	height:'100%',
	     	dialogType:'open',
	     	FullScrean: 'yes'
		});
	//}
}
	
var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
/** 按钮页签 **/
var resources = <c:out value="${CurrentUser.resourceJsonStr}" default="null" escapeXml="false"/>;
//待发送
if(resources.indexOf("F07_exWaitSend")>-1) {
	myBar.add(new WebFXMenuButton("presendPanel", "${presendLabel}", "modelTransfer('toSend', 'listExchangeToSend', '${param.id}');", [4,6], "", null));
}
//待签收
if(resources.indexOf("F07_exToReceive")>-1) {
	myBar.add(new WebFXMenuButton("presignPanel", "${presignLabel}", "modelTransfer('toReceive', 'listExchangeToRecieve', '${param.id}');", [5,1], "", null));
}
//已发送
if(resources.indexOf("F07_exSent")>-1) {
	myBar.add(new WebFXMenuButton("sendPanel", "${sendLabel}", "modelTransfer('sent', 'listExchangeSent', '${param.id}');", [4,7], "", null));
}
//已签收
if(resources.indexOf("F07_exReceived")>-1) {
	myBar.add(new WebFXMenuButton("signPanel", "${signLabel}", "modelTransfer('received', 'listExchangeReceived', '${param.id}');", [5,2], "", null));
}
<c:if test="${param.modelType=='sent'}">
	myBar.add(new WebFXMenuButton("deleteBtn", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteItem();", [1,3], "", null));
</c:if>

<c:if test="${isFenfa=='1'}">
//GOV-3388 （需求检查）【公文管理】-【发文管理】-【已分发】，'取回'按钮隐藏
/*
	myBar.add(new WebFXMenuButton("newBtn", "<fmt:message key='common.toolbar.takeBack.label' bundle='${v3xCommonI18N}' />","exchangeTakeBack();", [1,3], "", null));
*/
</c:if>

<c:if test="${v3x:hasPlugin('extinterPlugin') && isFenfa=='1'}">
	var bindingType = 1;
	//公文推送
	myBar.add(new WebFXMenuButton("systemSend", "<fmt:message key='ext.edoc.push' bundle='${v3xExtI18N}'/>", "extInterSend();", [4,1], "", null));
	//外网推送日志
	myBar.add(new WebFXMenuButton("systemLog", "<fmt:message key='dee.push.log' bundle='${v3xExtI18N}'/>", "extInterLog();",  [4,1], "", null));
</c:if>
	
$(function() {
	setMenuState('sendPanel');
});
	
</script>
<c:if test="${v3x:hasPlugin('extinterPlugin') && isFenfa=='1'}">
	<script type="text/javascript" src="<c:url value="/apps_res/ext/js/ext.js${v3x:resSuffix()}" />"></script>
</c:if>
</head>

<body class="page_color">

<c:if test="${v3x:hasPlugin('extinterPlugin') && isFenfa=='1'}">
	<%
		request.setCharacterEncoding("UTF-8");
	%>
	<fmt:message key='common.button.ok.label' bundle='${v3xExtI18N}' var='ext_ok'/>
	<fmt:message key='common.button.cancel.label' bundle='${v3xExtI18N}' var='ext_cancel'/>
	<jsp:include page="../../ext_inter/openDiv.jsp">
		<jsp:param name="ok" value="${ext_ok}" />
		<jsp:param name="cancel" value="${ext_cancel}" />
	</jsp:include>	
	
	<iframe style="display: none;" name="emptyIframe" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>	
</c:if>

<div class="main_div_row2">
  	<div class="right_div_row2">
    	<div id="toolbar" class="top_div_row2 webfx-menu-bar" style="border-top:0;">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="padding_l_5">
			<script type="text/javascript">
				<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
				document.write(myBar);
				document.close();
			</script>
		</td>
		<td class="webfx-menu-bar">
			<form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
				<input type="hidden" value="" name="selectedValue" />
				<input type="hidden" value="${isFenfa}" name="isFenfa" />
				<input type="hidden" value="<c:out value='${param.method}' />" name="method">
				<input type="hidden" value="<c:out value='${modelType}' />" name="modelType">
				<input type="hidden" value="<c:out value='${listType}' />" name="listType">
				<div class="div-float-right">
					<div class="div-float" id="selectDiv" name="selectDiv">
						<select name="condition" id="condition" onChange="showNextSpecialCondition(this);" class="condition">
							<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
							<!--
							<option value="total" <c:if test="${condition == 'total'}">selected</c:if>><fmt:message key="exchange.element.total" /></option>
							-->
							<option value="sendUnit"  <c:if test="${condition == 'sendUnit'}">selected</c:if>><fmt:message key="exchange.edoc.sendaccount" /></option>
							<option value="subject" <c:if test="${condition == 'subject'}">selected</c:if>><fmt:message key="exchange.edoc.title" /></option>
							<option value="docMark" <c:if test="${condition == 'docMark'}">selected</c:if>><fmt:message key="exchange.edoc.wordNo" /></option>
							<option value="exchangeType"  <c:if test="${condition == 'exchangeType'}">selected</c:if>><fmt:message key="edoc.exchange.type" bundle="${edocI18N}"/></option>
							<c:if test="${v3x:hasPlugin('sursenExchange')}"> 
								<option value="exchangeMode"  <c:if test="${condition == 'exchangeMode'}">selected</c:if>><fmt:message key="edoc.exchangeMode" /></option>  <%-- 交换方式 --%>
							</c:if>
						</select>
					</div>
					<!--
				  	<div id="totalDiv" class="div-float hidden">
						<input type="text" name="textfield" class="textfield" <c:if test="${condition == 'total'}"> value="${textfield}" </c:if>  onkeydown="javascript:if(event.keyCode==13)return false;">
				  	</div>
					-->
				  	<div id="sendUnitDiv" class="div-float hidden">
						<input type="text" name="textfield" class="textfield" <c:if test="${condition == 'sendUnit'}"> value="${textfield}" </c:if>  onkeydown="javascript:if(event.keyCode==13)return false;">
				  	</div>
				  	<div id="subjectDiv" class="div-float hidden">
						<input type="text" name="textfield" class="textfield" <c:if test="${condition == 'subject'}"> value="${textfield}" </c:if>  onkeydown="javascript:if(event.keyCode==13)return false;">
				  	</div>
				  	<div id="docMarkDiv" class="div-float hidden">
						<input type="text" name="textfield" class="textfield" <c:if test="${condition == 'docMark'}"> value="${textfield}" </c:if>  onkeydown="javascript:if(event.keyCode==13)return false;">
				  	</div>
					<div id="exchangeTypeDiv" class="div-float hidden">
						<select name="textfield">
							<option value=0><fmt:message key='edoc.send.exchange'/></option>
							<option value=1><fmt:message key='edoc.rec.exchange'/></option>
						</select>
				  	</div>
				  	<c:if test="${v3x:hasPlugin('sursenExchange')}">
					  	<div id="exchangeModeDiv" class="div-float hidden">
							<select name="textfield">
								<option value=0><fmt:message key='edoc.exchangeMode.internal'/></option>   <%-- 内部公文交换 --%>
								<option value=1><fmt:message key='edoc.exchangeMode.sursen'/></option>  <%-- 书生公文交换 --%>
							</select>
					  	</div>
					</c:if>
							<!--  input type="button" value="查询" onclick="showByStatus();"-->
				  	<div id="grayButton" onclick="javascript:doSearch()" class="condition-search-button"></div>
				  	<c:if test="${isFenfa=='1'}">
				  		<button style="line-height:15px;" onclick="javascript:openSendRegister(0)"><fmt:message key='edoc.send.register' bundle="${edocI18N}"/></button>
				  	</c:if> 
			  	</div>
			</form>
		</td>
	</tr>
</table>

		</div>
    	<div class="center_div_row2" id="scrollListDiv">
			<form name="listForm" id="listForm" method="get" onsubmit="return false">
				<v3x:table data="list" var="bean" htmlId="listTable" showHeader="true" showPager="true" bundle="${edocI18N}">
					<v3x:column width="5%" align="center"
						label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
					<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>"  <c:if test="${bean.id==param.id}" >checked</c:if> />
					</v3x:column>
					<v3x:column width="8%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.category" className="cursor-hand sort" maxLength="20">
					<v3x:metadataItemLabel metadata="${colMetadata['edoc_doc_type']}" value="${bean.docType}" />
					</v3x:column>
					<v3x:column width="15%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.wordNo" className="cursor-hand sort"  symbol="..." value="${bean.docMark}" alt="${bean.docMark}">
					</v3x:column>
					<v3x:column width="18%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.title" className="cursor-hand sort mxtgrid_black"  symbol="..." importantLevel="${bean.urgentLevel}" value="${bean.subject}${col.affair.subject}" alt="${bean.subject}">
					</v3x:column>
					<%--//TODO(5.0sprint3)
					<v3x:column width="18%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.title" className="cursor-hand sort"  symbol="..." importantLevel="${bean.urgentLevel}" value="${bean.subject}${col:showSubjectOfSummary4Done(col.affair, -1)}" alt="${bean.subject}">
					</v3x:column> 
					--%>
					<v3x:column width="15%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.sendaccount" className="cursor-hand sort" symbol="..." value="${bean.sendUnit}" alt="${bean.sendUnit}">
					</v3x:column>
					<v3x:column width="10%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.signingperson" className="cursor-hand sort"   symbol="..." value="${bean.issuer}">
					</v3x:column>
					<v3x:column width="10%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.signingdate" className="cursor-hand sort" maxLength="20" >
						<span title="<fmt:formatDate value="${bean.issueDate}" pattern="yyyy-MM-dd"/>">
							<fmt:formatDate value="${bean.issueDate}" type="both" dateStyle="full" pattern="yyyy-MM-dd" />&nbsp;
						</span>
					</v3x:column>
					<%--
					<v3x:column width="10%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.secretlevel" className="cursor-hand sort" maxLength="10" >
						<v3x:metadataItemLabel metadata="${colMetadata['edoc_secret_level']}" value="${bean.secretLevel}" />
					</v3x:column>
					--%>
					<v3x:column width="10%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.sendperson" className="cursor-hand sort" symbol="..." value="${bean.sendUserNames}">
					</v3x:column>
					<v3x:column width="10%" type="String" onClick="editItem('${bean.id}');"
						label="edoc.exchange.type" className="cursor-hand sort"  >
						<c:if test="${bean.isTurnRec==0 }"><fmt:message key='edoc.send.exchange'/></c:if>
						<c:if test="${bean.isTurnRec==1 }"><fmt:message key='edoc.rec.exchange'/></c:if>
					</v3x:column>
					<%-- 如果是书生交换 不存在补发 --%>
					<v3x:column width="9%" type="String" 
						label="exchange.menu.column.resend" className="cursor-hand sort" maxLength="10"  symbol="...">
							<c:if test="${bean.exchangeMode ne 1 }">
								[&nbsp;<a href="javascript:void(0)" onClick="editItem1('${bean.id}');"><fmt:message key="exchange.menu.column.resend" /></a>&nbsp;]
							</c:if>
					</v3x:column>
					<c:if test="${v3x:hasPlugin('sursenExchange')}"> 
						<v3x:column width="10%" type="String" onClick="editItem('${bean.id}');"
							label="edoc.exchangeMode" className="cursor-hand sort" symbol="...">  <%-- 交换方式 --%> 
							<c:if test="${bean.exchangeMode==0}"><fmt:message key='edoc.exchangeMode.internal'/></c:if> <%-- 内部公文交换 --%> 
							<c:if test="${bean.exchangeMode==1}"><fmt:message key='edoc.exchangeMode.sursen'/></c:if> <%-- 书生公文交换 --%>
						</v3x:column>
					</c:if>
				</v3x:table>
			</form>
		</div>
  	</div>
</div>

<script type="text/javascript">
window.onload=function(){
setTimeout(function(){
	//ie7兼容处理
	if(v3x.isMSIE7){
		$("#bDivlistTable").height($("#bDivlistTable").height()-15)
	}
},200);
}
initIpadScroll("scrollListDiv",550,870);
showDetailPageBaseInfo("detailFrame", "<fmt:message key='${exchangelabel}' />", [1,2], pageQueryMap.get('count'), _("ExchangeLang.detail_info_6011"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>

<iframe name="tempIframe" id="tempIframe" style="height:0px;width:0px;display:none"></iframe>

</body>
</html>