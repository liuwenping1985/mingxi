<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.util.Properties;"%>
<%@ taglib uri="http://v3x.seeyon.com/taglib/core" prefix="v3x"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>流程分析设置</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="./header.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<fmt:setBundle basename="com.seeyon.v3x.system.resources.i18n.SysMgrResources" var="sysI18n"/>
</head>
<style>
.search-menu-bar{
    border-top: 1px #A4A4A4 solid;
	background-image: url(/seeyon/common/skin/default/images/xmenu/toolbar_bg.gif);
	background-repeat: repeat-x;
}
</style>
<script type="text/javascript">

getA8Top().showLocation(1505);
	
function create() {
	parent.detailFrame.location.href="${workFlowAnalysisURL}?method=addAuthorization";
}

function modify() {
	var ids = document.getElementsByName('authorizationId');
	var sum = 0 ;
	var id = "";
	for (var i = 0 ; i < ids.length ; i ++) {
		if (ids[i].checked) {
			sum ++ ;
			id = ids[i].value ;
		}
	}
	if (sum == 0) {
		alert(v3x.getMessage("V3XLang.please_select_a_record"));
		return ;
	}
	if (sum >1) {
		alert("<fmt:message key='common.choose.one.record.label' bundle='${v3xCommonI18N}'/>");
		return ;
	}
	if (id != "")
		parent.detailFrame.location.href="${workFlowAnalysisURL}?method=queryAuthorizationById&id="+id;
}

function remove() {
	var selected = false;
	var ids = document.getElementsByName('authorizationId');
	for (var i = 0 ; i < ids.length ; i ++) {
		if (ids[i].checked) {
			selected = true;
			break;
		}
	}
	if (!selected) {
		alert(v3x.getMessage("V3XLang.please_select_a_record"));
		return ;
	}
	
	if (confirm("<fmt:message key='common.isdelete.label' bundle='${v3xCommonI18N}'/>")) {
		var form = document.getElementById("workFlowAnalysisListForm");
		form.target="listFrame";
		form.submit();
	}
	return ;
}

function selectAll(){
	var ids = document.getElementsByName('authorizationId');
	
	var selectAll = document.getElementById("allCheckbox");
	if (selectAll.checked) {
		for (var i = 0 ; i < ids.length ; i ++) {
			ids[i].checked = true ;
		}
	} else {
		for (var i = 0 ; i < ids.length ; i ++) {
			ids[i].checked = false ;
		}
	}
};

function viewData(id) {
	parent.detailFrame.location.href="${workFlowAnalysisURL}?method=queryAuthorizationById&flag=view&id="+id;
}
</script>
<body>

<div class="main_div_row2">
  <div class="right_div_row2">
    <div class="top_div_row2">
		<script type="text/javascript">
			var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
			myBar.add(new WebFXMenuButton("add","<fmt:message key="common.toolbar.new.label" bundle="${v3xCommonI18N}"  />","create()",[1,1], "<fmt:message key="common.toolbar.new.label" bundle="${v3xCommonI18N}"  />",null));
			myBar.add(new WebFXMenuButton("mod","<fmt:message key="common.toolbar.update.label" bundle='${v3xCommonI18N}'/>","modify()",[1,2],"<fmt:message key="common.toolbar.update.label" bundle='${v3xCommonI18N}'/>", null));
			myBar.add(new WebFXMenuButton("rem","<fmt:message key='common.toolbar.delete.label' bundle="${v3xCommonI18N}" />","remove()",[1,3],"<fmt:message key='common.toolbar.delete.label' bundle="${v3xCommonI18N}" />", null));
			document.write(myBar);
	    	document.close();
    	</script>
    </div>
    <div class="center_div_row2" id="scrollListDiv">
		<form id="workFlowAnalysisListForm" method="post" action="${workFlowAnalysisURL}?method=removeAuthorization">
			<v3x:table data="workFlowAnalysisAclList" var="data" htmlId="ssss">
				<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll()'/>">
					<input id="authorizationId" type="checkbox" name="authorizationId" value="${data.id }" />
				</v3x:column>
				<v3x:column width="30%" align="left" label="common.personnel.label" type="String" value="${data.memberNames }"
					className="cursor-hand sort" maxLength="200" symbol="..." onClick="viewData('${data.id }');">
				</v3x:column>
				<c:choose>
					<c:when test="${data.templeteIds=='1' }">
						<v3x:column width="65%" align="left" label="common.view.range.lable" type="String"
							className="cursor-hand sort" maxLength="200" symbol="..." onClick="viewData('${data.id }')">
							<fmt:message key='common.all.templete.label' bundle='${v3xCommonI18N}'/>
						</v3x:column>
					</c:when>
					<c:otherwise>
						<v3x:column width="65%" align="left" label="common.view.range.lable" type="String" value="${data.templeteNames }"
							className="cursor-hand sort" maxLength="200" symbol="..." onClick="viewData('${data.id }')">
						</v3x:column>
					</c:otherwise>
				</c:choose>
			</v3x:table>
		</form>
    </div>
  </div>
</div>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "", [3,5],pageQueryMap.get('count'),"");	
</script>
</body>
</html>
