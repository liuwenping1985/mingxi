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
<%--function param--%>
</script>
</head>
<body class="listPadding">
<span id="nowLocation"></span>
<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22">
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
						<c:set var="dblclick" value="updateAgentInfo('${agent.id }','${curtUserId}','${agent.agentId}')" />
					</c:when>
					<c:otherwise>
						<c:set var="dblclick" value="" />
					</c:otherwise>
					</c:choose>
					<v3x:column width="10%" type="String" label="${'agent.surrogate.name'}" align="left"
						onClick="${click}" onDblClick="${dblclick}" className="cursor-hand sort"
						 value="${v3x:showMemberName(agent.agentId)}" />

                    <v3x:column width="10%" type="String" label="${'agent.is.surrogate.name'}" align="left"
                        onClick="${click}" onDblClick="${dblclick}" className="cursor-hand sort"
                         value="${v3x:showMemberName(agent.agentToId)}" />

					<v3x:column width="35%" type="String" label="agent.option.name" align="left"
                        onClick="${click}" onDblClick="${dblclick}" className="cursor-hand sort" value="${agent.agentOptionName}" />

					<v3x:column width="15%" type="Date" label="common.date.begindate.label" className="cursor-hand sort" align="left"
						onClick="${click}" onDblClick="${dblclick}">
						<fmt:formatDate value="${agent.startDate}" pattern="yyyy-MM-dd HH:mm"/>
					</v3x:column>

					<v3x:column width="15%" type="Date" label="common.date.enddate.label" className="cursor-hand sort" align="left"
						onClick="${click}" onDblClick="${dblclick}">
						<fmt:formatDate value="${agent.endDate}" pattern="yyyy-MM-dd HH:mm"/>
					</v3x:column>
					<v3x:column width="15%" type="String" label="agent.type" align="left"
                        onClick="${click}" onDblClick="${dblclick}" className="cursor-hand sort">
                        <fmt:message key='agent.type.${agent.agentType}' />
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
showCtpLocation('F12_Agent');
</script>
</body>
</html>