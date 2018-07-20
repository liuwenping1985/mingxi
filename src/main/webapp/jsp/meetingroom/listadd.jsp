<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<title></title>
		<%@ include file="header.jsp" %>
		<c:set value="全选" var="selectAllLabel" />
		<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
		<script type="text/javascript">
		    showCtpLocation("F09_meetingRoom");
		</script>
		<script type="text/javascript">
			$(function() {
				setTimeout(function() {
					if($("#headIDlistTable") != null) {
						$("#headIDlistTable").find("th").eq(0).find("div").attr("title", '${selectAllLabel}');
					}
				}, 100);
			});
		
			function doCreate(){
				parent.detailFrame.location = "${mrUrl}?method=createAdd&flag=register";
			}
			function showModify(id){
				parent.detailFrame.location = "${mrUrl}?method=createAdd&id="+id;
			}
			function showDetail(id){
				parent.detailFrame.location = "${mrUrl}?method=createAdd&id="+id+"&readOnly=true";
			}
			function doModify(){
				var id = checkSelectOne(document.listForm);
				if(id == ""){
					alert("<fmt:message key='mr.alert.pleaseselectroom'/>");
					return false;
				}
				if(id == "false"){
					alert("<fmt:message key='mr.alert.modifyselectone'/>");
					return false;
				}
				parent.detailFrame.location = "${mrUrl}?method=createAdd&flag=edit&id="+id;
				
			}
			function doDelete(){
				var id = checkSelect(document.listForm);
				if(id == ""){
					alert("<fmt:message key='mr.alert.pleaseselecttodel'/>");
					return false;
				}else{
					if(confirm("<fmt:message key='mr.alert.delconfirm'/>？")){
						document.listForm.action = "${mrUrl}?method=execDel";
						document.listForm.submit();
					}
				}
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
							<c:if test="${conditionValue == MRConstants.Status_MeetingRoom_Normal}">
								document.getElementById("status").selectedIndex = 0;
							</c:if>
							<c:if test="${conditionValue == MRConstants.Status_MeetingRoom_Stop}">
								document.getElementById("status").selectedIndex = 1;
							</c:if>
						</c:when>
						<c:when test="${selectCondition == 3}">
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
				var inputDiv_Input = document.getElementById("condition_div_input");
				var str = "";
				var str_input = "";
				inputDiv_Input.style.display = "none";
				if(node.value == "0"){
					str = "";
				}else if(node.value == "1"){
					str += "<input type='text' id='name' name='name' inputName='<fmt:message key='mr.label.querycondition'/>：<fmt:message key='mr.label.meetingroomname'/>' validate='maxLength' maxLength='50' style='width:100px' />";
				}else if(node.value == "2"){
					str += "<select name='status' id='status'><option value='${MRConstants.Status_MeetingRoom_Normal}'><fmt:message key='mr.label.status.normal'/></option><option value='${MRConstants.Status_MeetingRoom_Stop}'><fmt:message key='mr.label.status.stop'/></option></select>";
				}else if(node.value == "3"){
					str += "<select name='seatCountCondition' id='seatCountCondition'>";
					str += "<option value='${MRConstants.Condition_ge}'><fmt:message key='mr.label.gt'/></option>";
					str += "<option value='${MRConstants.Condition_le}'><fmt:message key='mr.label.lt'/></option>";
					str += "<option value='${MRConstants.Condition_eq}'><fmt:message key='mr.label.eq'/></option>";
					str += "</select>";
					str_input += "<input type='text' id='seatCount' name='seatCount' inputName='<fmt:message key='mr.label.querycondition'/>：<fmt:message key='mr.label.seatCount'/>' validate='notNull,maxLength,isInteger' min='1' maxLength='3' style='width:100px' />";
					inputDiv_Input.innerHTML = str_input;
					inputDiv_Input.style.display = "";
				}
				inputDiv.innerHTML = str;
			}
			function doSearch(){
				var patrn = /^[\d]+$/; 
				//if(checkForm(document.searchForm)){xiangfan 注释 修复GOV-2619
				//xiangfan 添加条件判断 2012-05-03
				var seatCountObj = document.getElementById("seatCount");
				if(seatCountObj != null){
					if(seatCountObj.value == ""){
						alert("可容纳人数不能为空！");
						return ;
					}else if(!patrn.exec(seatCountObj.value)){
						alert("请输入正整数！");
						return ;
					}
				}
				document.searchForm.submit();
				//}
			}
		</script>
		<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
	</head>
	<body srcoll="no" style="overflow: hidden" style="padding: 0px" onload="initSearchCondition()" onUnLoad="UnLoad_detailFrameDown()">
		<div class="main_div_row2">
  		<div class="right_div_row2">
    		     <div class="top_div_row2">
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   		<tr>
				<td height="22" class="webfx-menu-bar">
	   				<script type="text/javascript">
	   					var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","gray");
	   					myBar.add(new WebFXMenuButton("create", "<fmt:message key='mr.button.register'/>", "doCreate()", [1,1]));
	   					myBar.add(new WebFXMenuButton("modify", "<fmt:message key='mr.button.edit'/>", "doModify()", [1,2]));
	   					myBar.add(new WebFXMenuButton("delete", "<fmt:message key='mr.button.del'/>", "doDelete()", [1,3]));
	   					document.write(myBar);
					    document.close();
	   				</script>
	   			</td>
	   			<td class="webfx-menu-bar">
	   			<form name="searchForm" action="${mrUrl }?method=listAdd" method="post" onsubmit="">
	   			<div class="div-float-right">
	   				<div class="div-float"><select id="selectCondition" name="selectCondition" class="condition" onChange="showCondition(this)" inputName="<fmt:message key='mr.label.querycondition'/>" validate="notNull">
	   					<option value="">--<fmt:message key='mr.label.querycondition'/>--</option>
	   					<option value="1"><fmt:message key='mr.label.meetingroomname'/></option>
	   					<option value="2"><fmt:message key='mr.label.status'/></option>
	   					<option value="3"><fmt:message key='mr.label.seatCount'/></option>
	   				</select></div>
	   				<div id="condition_div" style="margin-right:2px;" class="div-float"></div>
                    <div id="condition_div_input" style="display: none;" class="div-float"></div>
	   				<div onclick="javascript:doSearch();" class="condition-search-button">&nbsp;</div>
	   			</div></form></td>
	   		</tr>
	   		</table>
             </div>
    <div class="center_div_row2" id="scrollListDiv">
    <form name="listForm" id="listForm" method="post" style="margin: 0px">
    <v3x:table htmlId="listTable" data="list" var="bean" pageSize="${pageSize }" size="${size }" showHeader="true" showPager="true" isChangeTRColor="true">
		<v3x:column width="4%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
			<input type='checkbox' name='id' value="<c:out value='${bean.id }'/>" />
		</v3x:column>
		<v3x:column width="36%" type="String" onDblClick="showModify('${bean.id }')" onClick="showDetail('${bean.id }')" 
			label="mr.label.meetingroomname" className="cursor-hand sort mxtgrid_black" alt="${bean.name }">
			<c:out value="${bean.name }" />
			<c:if test="${bean.needApp == 0}"><%--xiangfan 2012-04-23 将MRConstants.Type_MeetingRoom_NoNeedApp 改成 '1' 修复GOV-2040 不需要审核的会议室 不需要加'※'标示 --%>
				<!-- img src="/seeyon/apps_res/meetingroom/images/redflag.gif"/-->※
			</c:if>
		</v3x:column>
		<v3x:column width="30%" type="String" onDblClick="showModify('${bean.id }')" onClick="showDetail('${bean.id }')" 
			label="mr.label.place" className="cursor-hand sort" alt="${bean.place }">
			<c:out value="${bean.place }" />
		</v3x:column>
		<v3x:column width="15%" type="Number" onDblClick="showModify('${bean.id }')" onClick="showDetail('${bean.id }')" 
			label="mr.label.seatCount" className="cursor-hand sort" alt="${bean.seatCount }">
			<c:out value="${bean.seatCount }" />
		</v3x:column>
		<v3x:column width="15%" type="String" onDblClick="showModify('${bean.id }')" onClick="showDetail('${bean.id }')" 
			label="mr.label.status" className="cursor-hand sort" alt="">
			<c:if test="${bean.status == MRConstants.Status_MeetingRoom_Normal }"><fmt:message key='mr.label.status.normal'/></c:if>
			<c:if test="${bean.status == MRConstants.Status_MeetingRoom_Stop }"><fmt:message key='mr.label.status.stop'/></c:if>
		</v3x:column>
	</v3x:table>
	</form>
</div>
  </div>
</div>
<script type="text/javascript">
initIpadScroll("scrollListDiv",550,870);
showDetailPageBaseInfo("detailFrame", "<fmt:message key='mr.tab.add'/>", [2,3], pageQueryMap.get('count'), _("officeLang.detail_info_meetingroom_sigin"));
</script>
	</body>
</html>
	