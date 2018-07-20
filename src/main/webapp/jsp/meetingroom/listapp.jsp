<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title></title>
		<%@ include file="header.jsp" %>
		<fmt:setBundle basename="com.seeyon.v3x.office.admin.resources.i18n.AdminResources" var="v3xAdminI18N"/>
		<c:set value="全选" var="selectAllLabel" />
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript">
			if(getA8Top()!=null && typeof(getA8Top().showLocation)!="undefined") {
				getA8Top().showLocation(906, "<fmt:message key='mr.tab.app'/>");
			}
		</script>
		<script type="text/javascript">
			
			$(function() {
				setTimeout(function() {
					if($("#headIDlistTable") != null) {
						$("#headIDlistTable").find("th").eq(0).find("div").attr("title", '${selectAllLabel}');
					}
				}, 100);
			});
			
			function showView(){
				//window.showModalDialog("${mrUrl}?method=view",self,"dialogHeight: 287px; dialogWidth:750px;dialogTop:45;dialogLeft: 115;center: yes; status=no");
				window.showModalDialog("${mrUrl}?method=view",self,"dialogHeight: 320px; dialogWidth:750px;dialogTop:45;dialogLeft: 115;center: yes;help: no; status=no");
			}
			function showDetail(id){
				parent.detailFrame.location = "${mrUrl}?method=createAdd&id="+id+"&readOnly=true";
			}
			function createApp(){
				var id = checkSelectOne(document.listForm);
				if(id == ""){
					alert("<fmt:message key='mr.alert.pleaseselecttoapp'/>");
					return false;
				}
				if(id == "false"){
					alert("<fmt:message key='mr.alert.appselectone'/>");
					return false;
				}
				parent.detailFrame.location = "${mrUrl}?method=createApp&id="+id;
			}
			function initSearchCondition(){
				<c:if test="${selectCondition!=null}">
					var selectNode = document.getElementById("selectCondition");
					selectNode.selectedIndex = ${selectCondition};
					showCondition(selectNode);
					<c:choose>
						<c:when test="${selectCondition == 1}">
							document.getElementById("name").value = "${conditionValue}";
						</c:when>
						<c:when test="${selectCondition == 2}">
							document.getElementById("seatCount").value = "${conditionValue[0]}";
							<c:choose>
								<c:when test="${conditionValue[1]==MRConstants.Condition_ge}">
									document.getElementById("seatCountCondition").selectedIndex = 0;
								</c:when>
								<c:when test="${conditionValue[1]==MRConstants.Condition_le}">
									document.getElementById("seatCountCondition").selectedIndex = 1;
								</c:when>
								<c:when test="${conditionValue[1]==MRConstants.Condition_eq}">
									document.getElementById("seatCountCondition").selectedIndex = 2;
								</c:when>
							</c:choose>
						</c:when>
					</c:choose>
				</c:if>
			}
			function showCondition(node){
				var inputDiv = document.getElementById("condition_div");
				var str = "";
				if(node.value == "0"){
					str = "";
				}else if(node.value == "1"){
					str += "<input type='text' name='name' inputName='<fmt:message key='mr.label.querycondition'/>：<fmt:message key='mr.label.meetingroomname'/>' validate='maxLength' maxLength='50' style='width:100px' />";
				}else if(node.value == "2"){
					str += "<select name='seatCountCondition'>";
					str += "<option value='${MRConstants.Condition_ge}'><fmt:message key='mr.label.gt'/></option>";
					str += "<option value='${MRConstants.Condition_le}'><fmt:message key='mr.label.lt'/></option>";
					str += "<option value='${MRConstants.Condition_eq}'><fmt:message key='mr.label.eq'/></option>";
					str += "</select>";
					str += "<input type='text' name='seatCount' inputName='<fmt:message key='mr.label.querycondition'/>：<fmt:message key='mr.label.seatCount'/>' validate='notNull,maxLength,isInteger' min='0' maxLength='3' style='width:100px' />";
				}
				inputDiv.innerHTML = str;
			}
			function doSearch(){
				if(checkForm(document.searchForm)){
					document.searchForm.submit();
				}
			}
		</script>
	</head>
	<body srcoll="no" style="overflow: hidden" style="padding: 0px" onload="initSearchCondition()">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   		<tr>
				<td height="22" class="webfx-menu-bar">
	   				<script type="text/javascript">
	   					var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","gray");
	   					myBar.add(new WebFXMenuButton("create", "<fmt:message key='common.toolbar.application.label' bundle='${v3xCommonI18N}'/>", "createApp()", [6,10]));
	   					myBar.add(new WebFXMenuButton("view", "<fmt:message key='common.toolbar.view.label' bundle='${v3xCommonI18N}'/>", "showView()", [7,3]));
	   					document.write(myBar);
					    document.close();
	   				</script>
	   			</td>
	   			<td class="webfx-menu-bar-gray">
	   			<form name="searchForm" action="${mrUrl }?method=listApp" method="post" onsubmit="">
	   			<div class="div-float-right">
	   				<div class="div-float"><select name="selectCondition" onChange="showCondition(this)" inputName="<fmt:message key='mr.label.querycondition'/>" validate="notNull">
	   					<option value="">--<fmt:message key='mr.label.querycondition'/>--</option>
	   					<option value="1"><fmt:message key='mr.label.meetingroomname'/></option>
	   					<option value="2"><fmt:message key='mr.label.seatCount'/></option>
	   				</select></div>
	   				<div id="condition_div" class="div-float"></div>
	   				<div onclick="javascript:doSearch();" class="condition-search-button">&nbsp;</div>
	   			</div></form></td>
	   		</tr>
	   		<tr>
	   			<td colspan="2">
	<div class="scrollList">
    <form name="listForm" id="listForm" method="post" style="margin: 0px">
    <fmt:message key="admin.label.manager" var="mrManager" bundle="${v3xAdminI18N}"/>
    <v3x:table htmlId="listTable" data="list" var="bean" pageSize="${pageSize }" size="${size }" showHeader="true" showPager="true" isChangeTRColor="true">
		<v3x:column width="4%" align="center" label="${selectAllInput }">
			<input type='checkbox' name='id' value="<c:out value='${bean.id }'/>" />
		</v3x:column>
		<v3x:column width="30%" type="String" label="mr.label.meetingroomname" onClick="showDetail('${bean.id }')" 
			className="cursor-hand sort" alt="${bean.name }">
			<c:out value="${bean.name }" />
		</v3x:column>
		<v3x:column width="30%" type="String" label="mr.label.place" onClick="showDetail('${bean.id }')" 
			className="cursor-hand sort" alt="${bean.place }">
			<c:out value="${bean.place }" />
		</v3x:column>
		<v3x:column width="12%" type="String" label="mr.label.seatCount" onClick="showDetail('${bean.id }')" 
			className="cursor-hand sort" alt="">
			<c:out value="${bean.seatCount }" />
		</v3x:column>
		<v3x:column width="12%" type="String" label="mr.label.status" onClick="showDetail('${bean.id }')" 
			className="cursor-hand sort" alt="">
			<c:if test="${bean.status == MRConstants.Status_MeetingRoom_Normal }"><fmt:message key='mr.label.status.normal'/></c:if>
			<c:if test="${bean.status == MRConstants.Status_MeetingRoom_Stop }"><fmt:message key='mr.label.status.stop'/></c:if>
		</v3x:column>
		<v3x:column width="12%" type="String" label="${mrManager}" onClick="showDetail('${bean.id }')" 
			className="cursor-hand sort" alt="${bean.v3xOrgMember.name }">
			<c:out value="${bean.v3xOrgMember.name }" />
		</v3x:column>
	</v3x:table>
	</form>
	</div>
	   			</td>
	   		</tr>
	   	</table>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='mr.tab.app'/>", [2,3], pageQueryMap.get('count'), _("officeLang.detail_info_meetingroom_application"));	
</script>
	</body>
</html>
	