<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="../exchangeHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>

<c:if test="${v3x:hasPlugin('extinterPlugin') }">
	<fmt:setBundle basename="com.seeyon.v3x.ext.resources.i18n.ExtResources" var="v3xExtI18N"/>
</c:if>
<link rel="stylesheet" href="${path}/skin/default/skin.css" />
<style>
/*.mxtgrid div.bDiv td div{
	padding-bottom:2px;
	padding-top:2px;
	height:auto;
	line-height:1.5;
}*/
/* xxp添加 公文标题多行显示 样式background:url(/skin/default/images/table/control_icon.png) no-repeat 50% 50%; */
.nbtn{display:block;width:18px;height:18px;position:relative;valign:middle;}
.nUL{margin:0;padding:0;list-style:none;width:100px; position:absolute;z-index:100;background:#fff;padding:5px;border:1px solid #ccc;}
.nUL input{vertical-align:middle;margin-right:5px;}
</style>
<script type="text/javascript">

baseUrl='${exchangeEdoc}?method=';

try {
	getA8Top().endProc('');
} catch(e) {}

$(function(){
	$(".nbtn").parent("div").attr("title", "");
	$(".nbtn").attr("title", "");
	$(".nbtn").parent("div").css("padding","1");
	$(".nbtn").parent("div").css("height","65%");
	$(".nbtn").click(function(e){
		var nul=$(".nUL"); //菜单div
		var left=parseInt($(this)[0].offsetLeft)-nul.width()+10; //计算div偏移量
		nul.toggleClass("hidden");
		nul.css({"left":left+"px","top":"25px"});
		addEvent(document.body,"mousedown",clickOther);
	});
	if("${hasSubjectWrap}" == "true") {
		var obj = document.getElementById("showAllSubjectId");
		obj.checked = true;
		subjectWrapSettting();
	}
});

function deleteItem() {
	var checkedIds = document.getElementsByName('id');
	var len = checkedIds.length;
	var objs = [];
	var k=0;
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
	     	url: '${exchangeEdoc}?method=sendDetail&id='+id+'&modelType=toSend',
	     	width:'100%',
	     	height:'100%',
	     	dialogType:'open',
	     	FullScrean: 'yes'
		});
	//}
}	

function showByStatus(){
	window.document.searchForm.submit();
}

var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
/** 按钮页签 **/
var resources = <c:out value="${CurrentUser.resourceJsonStr}" default="null" escapeXml="false"/>;
var paramID="${v3x:escapeJavascript(param.id)}";
//待发送
if(resources.indexOf("F07_exWaitSend")>-1) {
	myBar.add(new WebFXMenuButton("presendPanel", "${presendLabel}", "modelTransfer('toSend', 'listExchangeToSend', '"+paramID+"');", [4,6], "", null));
}
//待签收
if(resources.indexOf("F07_exToReceive")>-1) {
	myBar.add(new WebFXMenuButton("presignPanel", "${presignLabel}", "modelTransfer('toReceive', 'listExchangeToRecieve', '"+paramID+"');", [5,1], "", null));
}
//已发送
if(resources.indexOf("F07_exSent")>-1) {
	myBar.add(new WebFXMenuButton("sendPanel", "${sendLabel}", "modelTransfer('sent', 'listExchangeSent', '"+paramID+"');", [4,7], "", null));
}
//已签收
if(resources.indexOf("F07_exReceived")>-1) {
	myBar.add(new WebFXMenuButton("signPanel", "${signLabel}", "modelTransfer('received', 'listExchangeReceived', '"+paramID+"');", [5,2], "", null));
}
<c:if test="${param.modelType=='toSend'}">
    //BUG OA-35939 注掉的
    myBar.add(new WebFXMenuButton("deleteBtn", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "deleteItem();", [1,3], "", null));
</c:if>
<c:if test="${isFenfa=='1'}">
	myBar.add(new WebFXMenuButton("batch", "<fmt:message key='edoc.toolbar.Bulkdistribution.label' bundle='${edocI18N}'/>", "javascript:batchFenfa()", [10,1], "", null));
	/*myBar.add(new WebFXMenuButton("batch", "退回", "javascript:returnBackEdoc()", [10,1], "", null));*/
</c:if>
<c:if test="${v3x:hasPlugin('extinterPlugin') && isFenfa=='1'}">
	var bindingType = 1;
	myBar.add(new WebFXMenuButton("systemSend", "<fmt:message key='ext.edoc.push' bundle='${v3xExtI18N}'/>", "extInterSend();", [4,1], "", null));
	myBar.add(new WebFXMenuButton("systemLog", "<fmt:message key='dee.push.log' bundle='${v3xExtI18N}'/>", "extInterLog();", [4,1], "", null));
</c:if>

</script>

<c:if test="${v3x:hasPlugin('extinterPlugin') && isFenfa=='1'}">
	<script type="text/javascript" src="<c:url value="/apps_res/ext/js/ext.js${v3x:resSuffix()}" />"></script>
</c:if>
</head>

<body onload="setMenuState('presendPanel');" class="page_color h100b" style="position: static;">

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

<div class="main_div_row2" style="position: static;">
  <div class="right_div_row2" style="position: static;">
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
				<input type="hidden" value="<c:out value='${listType}' />" name="listType">
				<input type="hidden" value="<c:out value='${isFenfa}' />" name="isFenfa">
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
								<option value="exchangeType"  <c:if test="${condition == 'exchangeType'}">selected</c:if>><fmt:message key="edoc.exchange.type" bundle="${edocI18N}"/></option>
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
				  	
					<!--   input type="button" value="查询" onclick="showByStatus();"-->
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
	   		<ul class="nUL hidden" id="showAllSubject">
	    		<li><input type="checkbox" id="showAllSubjectId" onclick="javascript:subjectWrapSettting('ajax');"/><fmt:message key="edoc.subject.wrap" /></li>
	    	</ul>
			<form name="listForm" id="listForm" method="post" onsubmit="return false">
				<v3x:table data="list" var="bean" htmlId="listTable"  showHeader="true" showPager="true" bundle="${edocI18N}">
					<c:choose>
						<c:when test="${bean.status == 0}">
							<c:set value="disabled" var="disabled" />
						</c:when>
						<c:otherwise>
							<c:set value="" var="disabled" />
						</c:otherwise>
					</c:choose>
					<v3x:column width="5%" align="center"
						label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
					<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" subject="${bean.subject }" <c:if test="${bean.id==param.id}" >checked</c:if> ${disabled } />
					</v3x:column>
					<v3x:column width="8%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.category" className="cursor-hand sort" symbol="..." maxLength="20">
					<v3x:metadataItemLabel metadata="${colMetadata['edoc_doc_type']}" value="${bean.docType}" />
					</v3x:column>
					<v3x:column width="15%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.wordNo" className="cursor-hand sort" symbol="..."  value="${bean.docMark}" alt="${bean.docMark}">
					</v3x:column>
					<v3x:column width="22%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.title" className="cursor-hand sort  mxtgrid_black" importantLevel="${bean.urgentLevel}" value="${bean.subject}" alt="${bean.subject}">
					</v3x:column>
					
					<v3x:column width="20" label="<span class='cursor-hand nbtn ico16 arrow_1_b'>&nbsp</span>">
					</v3x:column>
				
					<v3x:column width="14%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.sendaccount" className="cursor-hand sort" symbol="..." value="${bean.sendUnit}" alt="${bean.sendUnit}">
					</v3x:column>
					<v3x:column width="10%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.signingperson" className="cursor-hand sort" alt="${bean.issuer}" value="${bean.issuer}" >
					</v3x:column>
					<v3x:column width="10%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.signingdate" className="cursor-hand sort" maxLength="10" alt="${bean.issueDate}">
						<span title="<fmt:formatDate value="${bean.issueDate}" pattern="yyyy-MM-dd"/>">
							<fmt:formatDate value="${bean.issueDate}" type="both" dateStyle="full" pattern="yyyy-MM-dd" />&nbsp;
						</span>
					</v3x:column>
					<%--
					<v3x:column width="15%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.create.date" className="cursor-hand sort" maxLength="20" alt="${bean.createTime}">
						<fmt:formatDate value="${bean.createTime}" type="both" dateStyle="full" pattern="yyyy-MM-dd" />
					</v3x:column>
					<v3x:column width="10%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.copy" className="cursor-hand sort" maxLength="10" value="${bean.copies}">
					</v3x:column>
					--%>
					<v3x:column width="10%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.minortoaccount" className="cursor-hand sort"  symbol="..." value="${bean.sendNames}" alt="${bean.sendNames}">
					</v3x:column>
					<v3x:column width="10%" type="String" onClick="editItem('${bean.id}');"
						label="edoc.exchange.type" className="cursor-hand sort"  >
						<c:if test="${bean.isTurnRec==0 }"><fmt:message key='edoc.send.exchange'/></c:if>
						<c:if test="${bean.isTurnRec==1 }"><fmt:message key='edoc.rec.exchange'/></c:if>
					</v3x:column>
					
					<v3x:column width="5%" type="String" onClick="editItem('${bean.id}');" label="exchange.edoc.status" className="cursor-hand sort"  symbol="...">
						<fmt:message key="exchange.edoc.status.${bean.status }"/>
					</v3x:column>
				</v3x:table>
			</form>
		</div>
  	</div>
</div>

<script type="text/javascript">
initIpadScroll("scrollListDiv",550,870);
showDetailPageBaseInfo("detailFrame", "<fmt:message key='${exchangelabel}' />", [1,2], pageQueryMap.get('count'), _("ExchangeLang.detail_info_6010"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
function subjectWrapSettting(needUpdate){
	var obj = document.getElementById("showAllSubjectId");
	var edocType = "${param.edocType==null||param.edocType==''?'0':param.edocType}";
	//2:发文-分发
	var listType = 2;
	isWrap(obj.checked, edocType, listType, needUpdate);
	document.getElementById("showAllSubject").className = "nUL hidden";
}
</script>
<iframe name="tempIframe" id="tempIframe" style="height:0px;width:0px;display:none"></iframe>
</body>
</html>