<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<%@ include file="../exchangeHeader.jsp" %>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>

<title></title>

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
<c:set var="current_user_id" value="${CurrentUser.id}"/>
<script type="text/javascript">
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
	if("${hasSubjectWrap}" == "true"){
		var obj = document.getElementById("showAllSubjectId");
		obj.checked = true;
		subjectWrapSettting();
	}
});
	
		function deleteItem() {
		  var checkedIds = document.getElementsByName('id');

		  var len = checkedIds.length;
		  
		  var str = "";
		  
		  for(var i = 0; i < len; i++) {
		  		var checkedId = checkedIds[i];
				
				if(checkedId && checkedId.checked && checkedId.parentNode.parentNode.tagName == "TR"){			
					str += checkedId.value;
					str +=","
				}
			}
			
		 //-- justify is any id has been chose.
		  
		  if(str==null || str==""){
		  	alert("<fmt:message key='edoc.delete.alert.label' bundle='${edocI18N}'/>");
		  	return false;
		  }

		 //-- justification end.	
		 	
			str = str.substring(0,str.length-1);
			
		if(window.confirm("<fmt:message key='edoc.deleteconfirm.alert.label' bundle='${edocI18N}'/>")){
			
			document.location.href='${exchange}?method=edocDelete&type=sign&id='+str;
			}
			

		}	
	
	baseUrl='${exchange}?method=';
	
	
	
	function editItem(id){
		openCtpWindow({
            url: '${exchange}?method=receiveDetail&id='+id+'&modelType=toReceive&userId=${current_user_id}',
            id : 'edocRec_' + id
        });
	}
	
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
	/** 按钮页签 **/
	var resources = <c:out value="${CurrentUser.resourceJsonStr}" default="null" escapeXml="false"/>;
	var paramID = "${v3x:escapeJavascript(param.id)}";
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
	
	$(function() {
		setMenuState('presignPanel');
	});
</script>
</head>

<body class="page_color">

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
				<div class="div-float-right condition-search-div">
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
    	<ul class="nUL hidden" id="showAllSubject">
    		<li><input type="checkbox" id="showAllSubjectId" onclick="javascript:subjectWrapSettting('ajax');"/><fmt:message key="edoc.subject.wrap" /></li>
    	</ul>
			<form id="listForm">
			<v3x:table data="list" var="bean" htmlId="listTable" showHeader="true" showPager="true">
				<v3x:column width="5%" align="center"
					label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>"  <c:if test="${bean.id==param.id}" >checked</c:if> />
				</v3x:column>
				<v3x:column width="8%" type="String" onClick="editItem('${bean.id}');"
					label="exchange.edoc.category" className="cursor-hand sort" symbol="..." maxLength="20">
				<v3x:metadataItemLabel metadata="${colMetadata['edoc_doc_type']}" value="${bean.docType}" />	
				</v3x:column>
				<v3x:column width="17%" type="String" onClick="editItem('${bean.id}');"
					label="exchange.edoc.wordNo" className="cursor-hand sort" symbol="..." value="${bean.docMark}" alt="${bean.docMark}">
				</v3x:column>
				<c:choose>
					<c:when test="${modelType=='toReceive'}">
					<v3x:column width="28%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.title" className="cursor-hand sort mxtgrid_black"  symbol="..."  importantLevel="${bean.urgentLevel}"  value="${bean.subject}" alt="${bean.subject}">
					</v3x:column>
					</c:when>
				<c:otherwise>
					<v3x:column width="22%" type="String" onClick="editItem('${bean.id}');"
						label="exchange.edoc.title" className="cursor-hand sort" maxLength="24"  symbol="..."  importantLevel="${bean.urgentLevel}" alt="${bean.subject}">
					${bean.subject}(<fmt:message key='edoc.beReturned'/>)
					</v3x:column>
				</c:otherwise>
				</c:choose>
				<v3x:column width="20" label="<span class='cursor-hand nbtn ico16 arrow_1_b'>&nbsp</span>">
				
				</v3x:column>
				<v3x:column width="10%" type="String" onClick="editItem('${bean.id}');"
					label="exchange.edoc.sendaccount" className="cursor-hand sort" symbol="..." value="${bean.sendUnit}" alt="${bean.sendUnit}">
				</v3x:column>
				<v3x:column width="8%" type="String" onClick="editItem('${bean.id}');"
					label="exchange.edoc.signingperson" className="cursor-hand sort" symbol="..." value="${bean.issuer}">
				</v3x:column>
				<v3x:column width="8%" type="String" onClick="editItem('${bean.id}');"
					label="exchange.edoc.signingdate" className="cursor-hand sort" maxLength="10" alt="${bean.issueDate}">
					<span title="<fmt:formatDate value="${bean.issueDate}" pattern="yyyy-MM-dd"/>">	
						<fmt:formatDate value="${bean.issueDate}" type="both" dateStyle="full" pattern="yyyy-MM-dd" />&nbsp;
					</span>
				</v3x:column>
				<%--
				<v3x:column width="12%" type="String" onClick="editItem('${bean.id}');"
					label="exchange.edoc.secretlevel" className="cursor-hand sort" maxLength="10" >
					<v3x:metadataItemLabel metadata="${colMetadata['edoc_secret_level']}" value="${bean.secretLevel}" />
				</v3x:column>
				--%>
				<v3x:column width="12%" type="String" onClick="editItem('${bean.id}');"
					label="exchange.edoc.sendToNames" className="cursor-hand sort" symbol="..." value="${bean.sendTo}" alt="${bean.sendTo}">
				</v3x:column>
			</v3x:table>
			</form>
			</div>
  </div>
</div>
<script type="text/javascript">
initIpadScroll("scrollListDiv",550,870);
showDetailPageBaseInfo("detailFrame", "<fmt:message key='${exchangelabel}' />", [1,2], pageQueryMap.get('count'), _("ExchangeLang.detail_info_6012"));
showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
function subjectWrapSettting(needUpdate){
	var obj = document.getElementById("showAllSubjectId");
	var edocType = "${param.edocType==null||param.edocType==''?'1':param.edocType}";
	//3:收文-签收
	var listType = 3;
	isWrap(obj.checked, edocType, listType, needUpdate);
	document.getElementById("showAllSubject").className = "nUL hidden";
}
</script>
</body>
</html>