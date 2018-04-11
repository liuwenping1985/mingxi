<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.seeyon.v3x.exchange.util.Constants"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="../exchangeHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<title></title>

<script type="text/javascript">

function deleteItem() {
	var checkedIds = document.getElementsByName('id');
	var objs = [];
	var k = 0;
	var len = checkedIds.length;
	for(var i = 0; i < len; i++) {
		var checkedId = checkedIds[i];
		if(checkedId && checkedId.checked) {
			objs[k++] = checkedId;
		}
	}
	if(objs.length == 0) {
	  	alert(v3x.getMessage("edocLang.edoc_deleteItem_alert1"));
	  	return false;
	}
	if(window.confirm(v3x.getMessage("edocLang.edoc_deleteItem_alert2"))) {
		var theForm = document.getElementsByName("listForm")[0];
		theForm.action ='${exchangeEdoc}?method=edocDelete&listType=${param.listType}';
        theForm.target = "tempIframe";
        theForm.method = "POST";
		for(var i = 0; i < objs.length; i++) {
			var checkedId = objs[i];
			var idInput = document.createElement("input");
			idInput.name = "receiveRecordId";
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
        
		document.location.href='${exchangeEdoc}?method=edocDelete&type=sign&id='+str;
	}
}	

	baseUrl='${exchangeEdoc}?method=';
	
	function editItem(id){
		if(v3x.getBrowserFlag('pageBreak')){
			parent.detailFrame.location.href='${exchange}?method=edit&id='+id+'&modelType=received&upAndDown=true';
		}else{
			v3x.openWindow({
		     	url: '${exchange}?method=edit&id='+id+'&modelType=received',
		     	dialogType:'open',
		     	workSpace: 'yes'
			});
		}
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
	
	//删除
	myBar.add(new WebFXMenuButton("newBtn", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteItem();", [1,3], "", null));
	
	$(function() {
		setMenuState('signPanel');
	});
	
</script>
</head>

<body class="page_color">

<c:set value="<%=Constants.C_iStatus_Recieved%>" var="un_rec" />
<c:set value="<%=Constants.C_iStatus_Registered%>" var="rec" />

<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2 webfx-menu-bar" style="border-top:0;">

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="padding_l_5">
			<script type="text/javascript">
			<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
				document.write(myBar.toString());	
				document.close();
			</script>
		</td>
		<td class="webfx-menu-bar">
			<form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
				<input type="hidden" value="<c:out value='${param.method}' />" name="method">
				<input type="hidden" value="<c:out value='${modelType}' />" name="modelType">
				<input type="hidden" value="" name="selectedValue" />
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
					<!--  input type="button" value="查询" onclick="showByStatus();"-->
			  		<div id="grayButton" onclick="javascript:doSearch()" class="condition-search-button"></div>
			  	</div>
			</form>
		</td>
	</tr>
	</table>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
			<form name="listForm" id="listForm" method="get" onsubmit="return false">
			<v3x:table data="list" var="bean" htmlId="listTable" showHeader="true" showPager="true">
				<v3x:column width="5%" align="center"
					label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>"  <c:if test="${bean.id==param.id}" >checked</c:if> <c:if test="${bean.status == un_rec}">disabled</c:if> />
				</v3x:column>
				<v3x:column width="8%" type="String" onClick="editItem('${bean.id}');"
					label="exchange.edoc.category" className="cursor-hand sort" maxLength="20">
				<v3x:metadataItemLabel metadata="${colMetadata['edoc_doc_type']}" value="${bean.docType}" />	
				</v3x:column>
				<v3x:column width="12%" type="String" onClick="editItem('${bean.id}');"
					label="exchange.edoc.wordNo" className="cursor-hand sort" symbol="..." value="${bean.docMark}" alt="${bean.docMark}">
				</v3x:column>
				<v3x:column width="26%" type="String" onClick="editItem('${bean.id}');"
					label="exchange.edoc.title" className="cursor-hand sort mxtgrid_black"  symbol="..." importantLevel="${bean.urgentLevel}" value="${bean.subject}" alt="${bean.subject}">
				</v3x:column>
				<v3x:column width="14%" type="String" onClick="editItem('${bean.id}');"
					label="exchange.edoc.sendaccount" className="cursor-hand sort" symbol="..." value="${bean.sendUnit}" alt="${bean.sendUnit}">
				</v3x:column>
				<%--
				<v3x:column width="7%" type="String" onClick="editItem('${bean.id}');"
					label="exchange.edoc.secretlevel" className="cursor-hand sort" maxLength="10" >
					<v3x:metadataItemLabel metadata="${colMetadata['edoc_secret_level']}" value="${bean.secretLevel}" />
				</v3x:column>
				--%>
				<v3x:column width="9%" type="String" onClick="editItem('${bean.id}');"
					label="exchange.edoc.receivedperson" className="cursor-hand sort"  symbol="..." value="${v3x:getMember(bean.recUserId).name}">
				</v3x:column>
				<v3x:column width="14%" type="String" onClick="editItem('${bean.id}');"
					label="exchange.edoc.receiveddate" className="cursor-hand sort" maxLength="20">
						<span title="<fmt:formatDate value="${bean.recTime}" pattern="yyyy-MM-dd HH:mm"/>">
							<fmt:formatDate value="${bean.recTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd" />&nbsp;
						</span>
				</v3x:column>
				
				<c:if test="${displayDistributeState == 'true'}">
					<c:set var="registerState" value="edoc.distribute.state"/>
				</c:if>
				<c:if test="${displayDistributeState != 'true'}">
					<c:set var="registerState" value="exchange.edoc.bookstate"/>
				</c:if>
				
				<v3x:column width="12%" type="String" onClick="editItem('${bean.id}');"
					label="${registerState }" className="cursor-hand sort" maxLength="10">
					
					
					<c:if test="${bean.status == 30}">
						<fmt:message key="edoc.receive.unattributed"  bundle="${edocI18N}"/>
					</c:if>
					<c:if test="${bean.status == 40}">
						<fmt:message key="edoc.receive.attributed"  bundle="${edocI18N}"/>
					</c:if>
					
					<c:choose>
					<c:when test="${displayDistributeState != 'true'}">
						<c:if test="${bean.status != rec }">
						<fmt:message key="exchange.edoc.unregistered" />
						</c:if>
						<c:if test="${bean.status == 2}">
							<fmt:message key="exchange.edoc.registered" />
						</c:if>
					</c:when>
					<c:otherwise>
						<c:if test="${empty bean.reciveEdocId}">
							<fmt:message key="edoc.receive.unattributed"  bundle="${edocI18N}"/>
						</c:if>
						<c:if test="${!empty bean.reciveEdocId}">
							<fmt:message key="edoc.receive.attributed"  bundle="${edocI18N}"/>
						</c:if>
					</c:otherwise>
					</c:choose>
					
					
					
				</v3x:column>
			</v3x:table>
			</form>
		</div>
  </div>
</div>
<script type="text/javascript">
initIpadScroll("scrollListDiv",550,870);
showDetailPageBaseInfo("detailFrame", "<fmt:message key='${exchangelabel}' />", [1,2], pageQueryMap.get('count'), _("ExchangeLang.detail_info_6013"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
</script>

<iframe name="tempIframe" id="tempIframe" style="height:0px;width:0px;display:none"></iframe>

</body>
</html>