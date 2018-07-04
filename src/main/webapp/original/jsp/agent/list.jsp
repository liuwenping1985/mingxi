<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ include file="../common/INC/noCache.jsp"%>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="header.jsp" %>    
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<style>
.disabled { color: #999; }
.webfx-menu--button {
	cursor: pointer;
	clear: none;
	height: 22px;
	line-height: 22px;
	vertical-align: middle;
	margin-top: 3px;
	color: #1E1E1E;
	border: 1px #ededed solid;
}
.listPadding {background: #f0f0f0;}
</style>
<script type="text/javascript">

//隐藏外部框架的按钮
var parentDocument = window.parent.parent.document; 
$("#submitbtn",parentDocument).hide(); 
$("#toDefaultBtn",parentDocument).hide(); 
$("#cancelbtn",parentDocument).hide(); 
$("#personalSetContent",parentDocument).height($("#personalSetContent",parentDocument).height()+$(".stadic_layout_footer",parentDocument).height());
$(".stadic_layout_footer",parentDocument).css("display","none");

window.onload = function(){
	if("true" != "${agentToFlag}"){
		for(var i = 0; i < myBar._menuItems.length; i++) {
			var item = myBar._menuItems[i];
			myBar.disabled(item.id);
			document.getElementById(item.id).childNodes[0].className = 'disabled';
		}

	}
}
function searchEnter() {
	if(window.event.keyCode==13){
		doSearch();
	}
}
<%--function param--%>
</script>
</head>
<body class="listPadding">
<span id="nowLocation"></span>
<input type="hidden" name="isGroupFlag" value="${isGroupFlag}" id="isGroupFlag"/>
<input type="hidden" name="isAdmin" value="${isAdmin}" id="isAdmin"/>
<input type="hidden" name="accountId" value="${accountId}" id="accountId"/>
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22" style="width: 70%">
	    	<script type="text/javascript">
	    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
	    	if(v3x.getBrowserFlag('hideMenu')){
				myBar.add(new WebFXMenuButton("new", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", "newAgent()", [1,1]));
	    		myBar.add(new WebFXMenuButton("update", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", "updateAgentInfo()",[1,2]));    	
	    	}
	    	myBar.add(new WebFXMenuButton("cancel", "<fmt:message key='common.toolbar.cancel.agent' bundle='${v3xCommonI18N}' />", "cancelAgent()", [1,3]));
	    	document.write(myBar);
	    	document.close();
	    	</script>
		</td>
		<c:if test="${isGroupFlag=='true'||isAdmin=='true'}">
		<td>
		<form action="" name="searchForm" id="searchForm" method="get"  onsubmit="return false">
			<div class="div-float-right">
				<div class="div-float">
					<select name="condition" style="height:24px;" id="condition" onchange="showInput(this)" >
					    <option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
					    <option value="agent_To"  <c:if test="${agentFlag=='agent_To'}"> selected </c:if> ><fmt:message key="agent.is.surrogate.name" bundle="${v3xCommonI18N}" /></option>
			  			<option value="agent" <c:if test="${agentFlag=='agent'}"> selected </c:if> ><fmt:message key="agent.surrogate.name" bundle="${v3xCommonI18N}" /></option>
					</select>
				</div>
				<div id="nameDiv" class="div-float <c:if test="${empty name && empty agentFlag}">  hidden </c:if>" style="display:<c:if test="${not empty name || not empty agentFlag}">  block </c:if>">
					<input type="text" name="nameTextField" id='nameTextField' class="search_input" value="<c:out value="${name}"/>" onkeydown="searchEnter()">
				</div>
				<div onclick="javascript:doSearch()" class="condition-search-button div-float"></div>
			</div>
		</form>
		</td>
		</c:if>
	</tr>
		</table>
    
    </div>
    <div class="center_div_row2 border_lr" id="scrollListDiv" style="width:99.7%">
			<form name="listForm" id="listForm" method="get" target="mainFrame" onsubmit="return false" style="margin: 0px">
				<v3x:table htmlId="agent" data="agentList" var="agent">
					<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
						<input type="checkbox" name="id" value="${agent.id}" ${agent.agentType == 2 ? 'disabled' : ''}/>
						<input type="hidden" name="agentId" value="${agent.agentId}" />
                        <input type="hidden" name="agentToId" value="${agent.agentToId}" />
                        <input type="hidden" name="curtUserId" value="${curtUserId}" />
					</v3x:column>
				
					<c:set var="click" value="showAgentDetail('${agent.id }')" />
					
					<c:choose>
					<c:when test="${agentToFlag}" >
						<c:set var="dblclick" value="updateAgentInfo('${agent.id }','${agent.agentType }','${agent.agentId}')" />
					</c:when>
					<c:otherwise>
						<c:set var="dblclick" value="" />
					</c:otherwise>
					</c:choose>
                         
                    <v3x:column width="10%" type="String" label="${'agent.is.surrogate.name'}" align="left"
                        onClick="${click}" onDblClick="${dblclick}" className="cursor-hand sort"
                         value="${v3x:showMemberName(agent.agentToId)}" alt="${v3x:showMemberName(agent.agentToId)}"/>  
                                                
					<v3x:column width="10%" type="String" label="${'agent.surrogate.name'}" align="left"
						onClick="${click}" onDblClick="${dblclick}" className="cursor-hand sort"
						 value="${v3x:showMemberName(agent.agentId)}" alt="${v3x:showMemberName(agent.agentId)}"/>
					
					<v3x:column width="30%" type="String" label="agent.option.name" align="left"
                        onClick="${click}" onDblClick="${dblclick}" className="cursor-hand sort" value="${agent.agentOptionName}"  alt="${agent.agentOptionName}"/>
                        	
					<v3x:column width="12%" type="Date" label="common.date.begindate.label" className="cursor-hand sort" align="left" 
						onClick="${click}" onDblClick="${dblclick}" alt="${fn:substring(agent.startDate, 0, 16)}"> 
						<fmt:formatDate value="${agent.startDate}" pattern="yyyy-MM-dd HH:mm"/>
					</v3x:column>
					
					<v3x:column width="12%" type="Date" label="common.date.enddate.label" className="cursor-hand sort" align="left"
						onClick="${click}" onDblClick="${dblclick}" alt="${fn:substring(agent.endDate, 0, 16)}">
						<fmt:formatDate value="${agent.endDate}" pattern="yyyy-MM-dd HH:mm"/>
					</v3x:column>
					<v3x:column width="10%" type="String" label="agent.type" align="left"
                        onClick="${click}" onDblClick="${dblclick}" className="cursor-hand sort"  >
                        <fmt:message key='agent.type.${agent.agentType}' />
                    </v3x:column>
					<v3x:column width="11%" type="String" label="agent.agentOperation" align="left"
						alt="${v3x:showMemberName(agent.agentToId)}"
                        onClick="${click}" onDblClick="${dblclick}" className="cursor-hand sort">
                        <c:if test="${agent.agentOperation == '0'}">${v3x:showMemberName(agent.agentToId)}</c:if>
                        <c:if test="${agent.agentOperation != '0'}"><fmt:message key='agent.agentOperation.${agent.agentOperation}' /></c:if>
                    </v3x:column>
				</v3x:table>
			</form>
    </div>
  </div>
</div>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.individual.agent' bundle='${v3xMainI18N}'/>", "/common/images/detailBannner/120703.gif", pageQueryMap.get('count'), _("agentLang.detail_info_101"));
//TODO initIpadScroll("scrollListDiv",550,880);
</script>
<script language="javascript">
if('${isGroupFlag}'=='true'){
  showCtpLocation('F13_groupAgentManager');
}
else if('${isAdmin}'=='true'){
  showCtpLocation('F13_accountAgentManager');
}else{
showCtpLocation('F12_Agent');
}
</script>
</body>
</html>