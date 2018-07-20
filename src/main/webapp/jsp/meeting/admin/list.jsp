<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.seeyon.v3x.meeting.manager.MtMeetingManagerImpl"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../include/taglib.jsp"%>
<%@ include file="../include/header.jsp"%>
<script type="text/javascript" src="<c:url value="/common/js/menu/xmenu.js${v3x:resSuffix()}" />"></script>
<link type="text/css" rel="stylesheet" href="<c:url value="${v3x:getSkin()}/skin.css${v3x:resSuffix()}" />">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/jquery.js${v3x:resSuffix()}" />"></script>
<c:set value="<input type='checkbox' onclick='selectAll(this, \"id\")'/>" var="selectAllInput" />
<c:set value="全选" var="selectAllLabel" />
<script type="text/javascript">
<!--
	try {
		getA8Top().endProc('');
	} catch(e) {}
	
	//当前位置
	showCtpLocation("F03_meetingDataBase");
    	
	var tempUrl = "${mtAdminController}?method=listMeetingRoom";
   	function doCreate(){
   	    //parent.detailFrame.document.location.href = "${mtAdminController}?method=create_admin&showFlag=1";
		selectPeopleFun_wf();
   	}
    	
   	function doModify(){
   		var count = checkSelectCount();
		if(count == 0){
			alert("<fmt:message key='admin.alert.selectdit'/>");
			return false;
		}else if(count > 1){
			alert("<fmt:message key='admin.alert.selectonerecord'/>");
			return false;
		}else if(count == 1){
			parent.detailFrame.document.location.href = "${mtAdminController}?method=editAdmin&id="+selectValue();
		}
   	}
   	$(function() {
      setTimeout(function() {
          if($("#headIDlistTable") != null) {
              $("#headIDlistTable").find("th").eq(0).find("div").attr("title", '${selectAllLabel}');
          }
      }, 100);
    });
   	function showDetail(assetId){
   		parent.detailFrame.document.location.href = "${mtAdminController}?method=detailAdmin&id="+assetId;
   	}
   	function showDetailFull(assetId){
   		parent.parent.detailFrame.document.location.href = "${officeadminURL}?method=detail&id="+assetId+"&fs=true";
   	}
	// 不再检查，直接调用删除
	function checkHasMtRoomByAdmin(){
   		var count = checkSelectCount();
   		if(count == 0){
   			alert("<fmt:message key='admin.alert.selectonerecord'/>");
   			return;
   		}
		if(confirm("<fmt:message key='admin.alert.confirmdelrecord'/>")){
			document.listForm.action = "${mtAdminController}?method=del";
			document.listForm.submit();
		}
	}
    	
   	function checkSelectCount(){
   		var id = document.getElementsByName("id");
   		var count = 0;
   		for(var i = 0; i < id.length; i++){
   			if(id[i].checked){
   				count++;
   			}
   		}
   		return count;
   	}
   	
   	function selectValue(){
   		var id = document.getElementsByName("id");
   		for(var i = 0; i < id.length; i++){
   			if(id[i].checked){
   				return id[i].value;
   			}
   		}
   	}
    	
   	function selectPeople(value)
	{
		if(value == 3){
			selectPeopleFun_selectDepartment();
		}else if(value == 2){
			selectPeopleFun_selectMember();
		}
	}
	
	function setBulPeopleFields_Dep(elements){
		if(elements.length > 1){
			alert("<fmt:message key='admin.alert.selectonedep'/>");
			return false;
		}else if(elements.length == 1){
			var element = elements[0];
			document.getElementById("textfield3").value=getIdsString(elements, false);
			document.getElementById("textfieldd").value=element.name;
		}else if(elements.length == 0){
			document.getElementById("textfield3").value="";
			document.getElementById("textfieldd").value="";
		}
	}
	
	function setBulPeopleFields_Mem(elements){
		if(elements.length > 1){
			alert("<fmt:message key='admin.alert.selectone'/>");
			return false;
		}else{
			var element = elements[0];
			document.getElementById("textfield2").value=element.id;
			document.getElementById("textfieldm").value=element.name;
		}
	}

	function setBulPeopleFields(elements){
		if(elements.length > 1){
			alert("<fmt:message key='admin.alert.selectone'/>");
		    return false;
	    }else{
			var element = elements[0];
			try {
				var requestCaller = new XMLHttpRequestCaller(null, "ajaxMeetingRoomAdminManager", "getAdminSettingById", false, "POST");
				var domainid = '${v3x:currentUser().loginAccount}';
				requestCaller.addParameter(1, "Long", domainid);
				requestCaller.addParameter(2, "Long", element.id);
				requestCaller.addParameter(3, "Long", null);
				requestCaller.addParameter(4, "String", null);
				requestCaller.addParameter(5, "Boolean", null);
				var processXMLs = requestCaller.serviceRequest();
				if(processXMLs==null || processXMLs=="") {
					parent.detailFrame.document.location.href = "${mtAdminController}?method=doCreate&admin="+element.id;
				}else{
					alert("<fmt:message key='admin.alert.addfailure'/>");
					return false;
				}
			}catch (ex1) {
			}
		}
	}
    var onlyLoginAccount_wf = true; // 只能选择管理员登录的单位的人员 xieFei
	var onlyLoginAccount_selectDepartment = false;
	var onlyLoginAccount_selectMember = true;
	var showOriginalElement_selectDepartment = true;
    //-->
</script>
</head>
<body onload="" class="page_color">
<v3x:selectPeople id="selectMember" panels="Department" selectType="Member" jsFunction="setBulPeopleFields_Mem(elements);" minSize="1" maxSize="1"/>	
<v3x:selectPeople id="wf" panels="Department" selectType="Member" jsFunction="setBulPeopleFields(elements);" minSize="1" maxSize="1" />	
	
<div class="main_div_row2">
<div class="right_div_row2">
<div class="top_div_row2">
<table width="100%" height="100%" border="0" cellspacing="0"
	cellpadding="0">
	<tr>
		<td class="webfx-menu-bar ">
		<script type="text/javascript">
    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}","gray");
    	myBar.add(new WebFXMenuButton("create", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'/>", "doCreate()", [1,1], "", null));
		// 会议室改造，管理员的管理范围跟随会议室走，这里去掉修改按钮，因为修改按钮失去意义 xieFei-->
    	// myBar.add(new WebFXMenuButton("modify", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}'/>", "doModify()", [1,2], "", null));
    	myBar.add(new WebFXMenuButton("delete", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/>", "checkHasMtRoomByAdmin()", [1,3], "", null));
    	document.write(myBar);
    	document.close();
    </script>
		</td>
		<td class="webfx-menu-bar">
		<form name="searchForm" id="searchForm" method="post" action="${mtAdminController}" style="margin: 0px">
		<input type="hidden" name="method" value="listMeetingRoom"/>
		<div class="div-float-right condition-search-div">
		<div class="div-float">
				<select id="condition" name="condition" onChange="showNextCondition(this)">
					<option value="0">-<fmt:message key='admin.alert.selectcondition'/>-</option>
					<option value="2"><fmt:message key='mt.admin.button.administrator'/></option>
					<!-- 会议室改造，管理员的管理范围跟随会议室走，这里取消查询条件中的管理范围 xieFei-->
					<!--<option value="3"><fmt:message key='mt.admin.button.management.range'/></option>-->
				</select>
			</div>
		      <div id="2Div" class="div-float hidden">
							<input type="text" name="textfield" id="textfield2" class="textfield" value=""/>
							<!-- <input type='text' id="textfieldm" class='textfield1' name='textfield1'  value='' /> -->
				</div>
				<div id="3Div" class="div-float hidden">
							<input type="hidden" name="textfield" id="textfield3" class="textfield"/><input type='text' id="textfieldd" class='textfield1' name='textfield1' onclick='selectPeople(3)' value='${checkselectdep}' readonly onkeydown="javascript:if(event.keyCode==13)return false;"/>
				</div>
				
			<div onclick="javascript:doSearch()" class="condition-search-button">&nbsp;</div>
		</div>
		</form>
		</td>
	</tr>
</table>

</div>
<div class="center_div_row2" id="scrollListDiv">
<form name="listForm"  id="listForm" method="post" style="margin: 0px">
<v3x:table htmlId="listTable" data="list" var="bean" leastSize="0">
	

		<v3x:column width="4%" align="center" label="${selectAllInput }" >
			<input type='checkbox' name='id' value="<c:out value='${bean.admin},${bean.admin_model }'/>" />
		</v3x:column>
		<!-- 会议室改造，xieFei -->
		<!-- onClick="showDetail('${bean.admin},${bean.admin_model }')" -->
		<v3x:column width="54%" type="String" 
			label="mt.admin.button.administrator" className="cursor-hand sort" alt="${bean.adminName}"><%--xiangfan 修改alt,修复GOV-2604 --%>
			<c:out value="${bean.adminName}" />
		</v3x:column>
		<!-- 会议室改造，取消范围的输入改为创建时间 xieFei -->
		<v3x:column width="42%" type="String"
			label="admin.label.createdate" className="cursor-hand sort" alt="${bean.createDate}">
			<fmt:formatDate value='${bean.createDate}' pattern='yyyy年MM月dd日'/>
		</v3x:column>
	
</v3x:table>
</form>
</div>
</div>
</div>
<%--
<%@ include file="../../doc/pigeonholeHeader.jsp"%>
 --%>
<jsp:include page="../include/deal_exception.jsp" />
<script type="text/javascript">
<!--
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='mt.mtMeeting.Meeting.Room.label' /><fmt:message key='mt.list' />", [1,5], pageQueryMap.get('count'), _("meetingLang.detail_info_603_1"));	
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	initIpadScroll("scrollListDiv",550,870);
//-->
</script>

</body>
</html>