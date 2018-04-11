<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<title></title>
<%@ include file="../include/taglib.jsp" %>
<%@ include file="../include/header.jsp" %>
<fmt:setBundle basename="com.seeyon.v3x.office.admin.resources.i18n.AdminResources" var="v3xAdmin"/>
<fmt:message key='admin.alert.selectmodel' var="adminalert"/>
<fmt:message key='admin.alert.checkselectdep' var='checkselectdep'/>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/jquery/jquery.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
<!--

function selectPeople()
{
	selectPeopleFun_wf();
}

function setBulPeopleFields(elements){
	if(elements.length > 1){
		alert("<fmt:message key='admin.alert.selectone'/>");
		return false;
	}else{
		var element = elements[0];
		document.getElementById("admin").value=element.id;
		document.getElementById("admin_name").value=element.name;
		/*
		for(prop in element){
			alert(prop+"="+element[prop]);
		}
		*/
	}
}

function selectDepartment()
{
	selectPeopleFun_depart();
}

/*function setBulDepartmentFields(elements){
	if(elements.length > 1){
		alert("<fmt:message key='admin.alert.selectonedep'/>");
		return false;
	}else{
		var element = elements[0];
		document.getElementById("accountId").value=element.accountId;
		document.getElementById("departmentId").value=element.id;
		document.getElementById("mngDepId").value=element.accountShortname + "-" + element.name;
	}
}*/

function setBulDepartmentFields(elements){
	if(elements.length > 0){
		document.getElementById("accountId").value="";
		document.getElementById("departmentId").value="";
		document.getElementById("mngDepId").value="";
		var accValue = document.getElementById("accountId").value;
		var depValue = document.getElementById("departmentId").value;
		var mngValue = document.getElementById("mngDepId").value;
		for(var i = 0; i < elements.length; i++){
			var element = elements[i];
			if(accValue.length > 0){
				accValue += ",";
				depValue += ",";
				mngValue += ",";
			}
			accValue += element.accountId;
			depValue += element.id;
			//mngValue += element.accountShortname + "-" + element.name;
			mngValue += element.name;
		}
		document.getElementById("accountId").value = accValue;
		document.getElementById("departmentId").value = depValue;
		document.getElementById("mngDepId").value = mngValue;
		
	}
}

function doSubmit(){
	var form = document.newForm;
	var checkboxs = document.getElementsByName("adminModel");
	var selectCount = 0;
	for(var i = 0; i < checkboxs.length; i++){
		if(checkboxs[i].checked){
			selectCount++;
		}
	}
	if(selectCount == 0){
		alert("${adminalert}");
		return false;
	}
	/* 会议室改造，管理员的管理范围跟随会议室走，这里取消范围的输入 xieFei
	//xiangfan 添加 
	if(document.getElementsByName("mngDepId")[0].value == "${checkselectdep}"){
		alert(v3x.getMessage("meetingLang.alert_info_meetingroome_selectscope"));
		return ;
	}
	*/
	if(checkForm(form)){
		newForm.submit();
	}else{
		return false;
	}
}

function cancelOper(){
    //alert("good");
	var frmObj = document.forms[0];
	
		frmObj.reset();
		  window.parent.listFrame.location.reload();
}

$(function(){
    var w = document.body.clientHeight - $(".categorySet-head").height() - 58 - 10;
    if($.browser.version == 9){
        w = w - 20;
    }
    $("#blankSpace").height(w);
})

${script}
//-->
var excludeElements_wf = "${v3x:parseElementsOfTypeAndId(members)}"; // 过滤查询的人员，已经是管理员的不再出现
</script>
	
<base>
</head>
<body style="text-align:center">
<!-- 
<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center">
	<tr align="center">
		<td height="12" class="detail-top"><img src="<c:url value="/apps_res/bulletin/images/button.preview.gif" />" height="8" onclick="previewFrame()" class="cursor-hand"></td>
	</tr>
</table>
-->
<div id="topDiv" class="">
<div id="mainDiv">
<script type="text/javascript">
	var onlyLoginAccount_wf = true;
	//var onlyLoginAccount_depart = true; xiangfan 注释 2012-04-23， 修复GOV-130 不能跨单位选择的错误
</script>
<form name="newForm" action="${mtAdminController}?method=doCreate" method="post" onsubmit="" style="margin-top:0px;">
<input type="hidden" name="method" value="doCreate"/>
<v3x:selectPeople id="wf" panels="Department" selectType="Member" jsFunction="setBulPeopleFields(elements);" minSize="1" maxSize="1" />
<v3x:selectPeople id="depart" panels="Department" selectType="Account,Department" jsFunction="setBulDepartmentFields(elements);" />
<table border="0" cellpadding="0" cellspacing="0" width="100%" align="center" class="categorySet-bg">
	<tr align="center">
		<td height="8" class="detail-top">
			<script type="text/javascript">
				getDetailPageBreak("<c:url value='/common/images/button.preview.up.gif'/>", "<c:url value='/common/images/button.preview.down.gif'/>");
			</script>
		</td>
	</tr>
	<tr>
		<td class="categorySet-4" height="8"></td>
	</tr>
	<tr>
		<td class="categorySet-head" style="padding: 0px 0px 0px 0px">
			<div class="categorySet-body">
				<table height="100%" width="30%" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td class="bg-gray" width="12%" nowrap="nowrap"><font color="red">*</font><fmt:message key='mt.admin.button.administrator'/>:&nbsp;</td>
						<td class="new-column" width="35%" nowrap="nowrap"><fmt:message key='admin.alert.checkselectperson' var='checkselectperson'/>
							<input type="hidden" name="admin" id="admin" />
							<input type="text" name="admin_name" id="admin_name" onclick="selectPeople()" 
							inputName="<fmt:message key='admin.label.manager' bundle="${v3xAdmin }"/>" deaultValue="${checkselectperson }" validate="notNull,isDeaultValue" 
							value="<c:out value="${checkselectperson}" escapeXml="true" />" readonly />
						</td>
						<td colspan="2">&nbsp;</td>
					</tr>
					<!--会议室改造，管理员的管理范围跟随会议室走，这里取消范围的输入 xieFei
					<tr>
						<td class="bg-gray" width="12%" nowrap="nowrap"><font color="red">*</font><fmt:message key='mt.admin.button.management.range'/>:&nbsp;</td>
						<td class="new-column" width="35%" nowrap="nowrap" colspan="3">
							<input type="hidden" name="accountId" id="accountId" /><input type="hidden" name="departmentId" id="departmentId"/>
							
                            <%-- <input type="text" name="mngDepId" id="mngDepId" onclick="selectDepartment()" 
							inputName="<fmt:message key='admin.label.mgedep' bundle="${v3xAdmin }"/>" deaultValue="${checkselectdep }" validate="notNull,isDeaultValue" 
							value="<c:out value="${checkselectdep }" escapeXml="true" />" readonly /> --%>
                            <textarea name="mngDepId" id="mngDepId" onclick="selectDepartment()" inputName="<fmt:message key='admin.label.mgedep' bundle="${v3xAdmin }"/>" deaultValue="${checkselectdep }" validate="notNull,isDeaultValue" rows="6" cols="40" readonly><c:out value="${checkselectdep }" escapeXml="true" /></textarea>
						</td>
					</tr>-->
					<tr  style="display:none;">
						<td width="12%" nowrap="nowrap" class="bg-gray" valign="top" style="padding-top: 3px;">&nbsp;</td>
						<td width="35%" nowrap="nowrap" class="new-column" colspan="3" >
						    <input type="checkbox" checked="checked" name="adminModel"  id="admin_meeting" value="5"/>
						</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
	<tr>
		<td id="blankSpace" style="background:#ffffff;"></td>
	</tr>
	<tr>
		<td height="42" align="center" class="bg-advance-bottom" style="background:#F3F3F3;left: 0px; width: 100%; height: 42px; bottom: 0px; line-height: 42px; position: absolute;">
			<input type="button" class="button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" onclick="doSubmit()" />&nbsp;
			<input type="button" onclick="cancelOper()" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" />
		</td>
	</tr>

	</table>
	<%--<div align="center" class="bg-advance-bottom border-top" style="height:42px;width:100%;position:absolute;left:0;bottom:10px;line-height:42px;background:#F3F3F3;">--%>
	<%--<input type="button" class="button-default_emphasize" value="<fmt:message key='common.button.ok.label' bundle="${v3xCommonI18N}" />" onclick="doSubmit()" />&nbsp;--%>
	<%--<input type="button" onclick="cancelOper()" class="button-default-2" value="<fmt:message key='common.button.cancel.label' bundle="${v3xCommonI18N}" />" />--%>
	<%--</div>--%>
</tr>
</form>
</div>
</div>
<c:choose>
	<c:when test="${showFlag == 1 }"></c:when>
	<c:otherwise>
		<script type="text/javascript">
			document.getElementById("mainDiv").style.display="none";
		</script>
	</c:otherwise>
</c:choose>

</body>
</html> 