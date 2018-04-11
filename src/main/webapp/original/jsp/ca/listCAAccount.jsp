<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@page import="java.util.Properties"%>
<html>
<head>
<title>成员列表</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<%@include file="caaccountHeader.jsp"%>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/src/Set.js${v3x:resSuffix()}" />"></script>
<script type="text/javascript">
function editOrViewMember(operationType ,memberId){
	parent.detailFrame.location.href = "${caacountURL}?method=showAddOrEditCAAccount&operationType="+ operationType +"&memberId=" + memberId;
}

</script>
<script type="text/javascript">
		function create(){
			parent.detailFrame.location.href = "${caacountURL}?method=showAddOrEditCAAccount&operationType=add";
		}
		
		function modify(){
			var id = getSelectIds(parent.listFrame);
			var ids = id.split(",");
			if(ids.length==2){
				parent.detailFrame.location.href = "${caacountURL}?method=showAddOrEditCAAccount&operationType=edit&memberId=" + ids[0];
			}else if(ids.length>2){
				alert(v3x.getMessage("organizationLang.orgainzation_select_one_once"));
				return false;
			}else{
				alert("<fmt:message key="member.chosece.modify"/>");
				return false;
			}
		}

		function removeCaa(){
			var id = getSelectIds(parent.listFrame);
			var ids = id.split(",");
			var theForm = parent.listFrame.document.getElementById("accountform");
		    if (!theForm) {
		        return false;
		    }
		    var id_checkbox = parent.listFrame.document.getElementsByName("id");
		    if (!id_checkbox) {
		        return;
		    }
		    var hasMoreElement = false;
		    var len = id_checkbox.length;
		    for (var i = 0; i < len; i++) {
		        if (id_checkbox[i].checked) {
		            hasMoreElement = true;
		            break;
		        }
		    }
		    if (!hasMoreElement) {
		        alert("<fmt:message key='member.delete'/>");
		        return;
		    }
			if(!confirm("<fmt:message key='ca.prompt.deleteAccount'/>"))
				return false;
			//getA8Top().startProc('');
			theForm.action = "${caacountURL}?method=destroyAccount";
			theForm.submit();
		}

		function impCAAccount(){
			var u = null;
			var ok = canIO(u);
			ok='ok';
			if('ok' == ok){
				var returnValue=v3x.openWindow({
					url : "${caacountURL}?method=importExcel",
					width : "350",
					height : "317",
					resizable : "false"
				});
				
				if(returnValue!=null){
					getA8Top().startProc('');
					parent.detailFrame.location.href = "${caacountURL}?method=doImportResult";
					parent.listFrame.location.href = "${caacountURL}?method=listCAAccount";
				}
			}else{
				  //alert('后台正在进行导入导出操作');
				  alert(v3x.getMessage("organizationLang.organization_back_deal"));
			}
		}
		
		function download() {
		    var downloadUrl = "${caacountURL}?method=downloadTemplate";
		    var eurl = "<c:url value='" + downloadUrl + "' />";
		    document.exportIFrame.location.href = eurl;
		}
				
		function expCAAccountToExcel(){
			var u = null;
			var ok = canIO(u);
			ok='ok';
			if('ok' == ok){
					//parent.detailFrame.location.href="${organizationURL}?method=toExpBase&tomethod=exportMember";
					//alert('导出数据需要一段时间处理，请耐心等待');
					alert(v3x.getMessage("organizationLang.organization_export_wait"));
					var condition = document.getElementById("condition").value;
					var textfield = document.getElementById("textfield4Export").value;
					if(condition == ''||textfield==''){
					    condition = parent.listFrame.document.getElementById("condition").value;
					    textfield = parent.listFrame.document.getElementById("textfield").value;
					}
					document.exportIFrame.location.href = "<c:url value='/caAccountManagerController.do?method=expCAAccountToExcel' />&condition="+condition+"&textfield="+encodeURI(textfield);
			}else{
				  //alert('后台正在进行导入导出操作');
				  alert(v3x.getMessage("organizationLang.organization_back_deal"));
			}
		}
		
		function conditionOnChangeHandler(conditionObject){
			var options = conditionObject.options;
			
			for (var i = 0; i < options.length; i++) {
				 var d = document.getElementById(options[i].value + "Div");
				  if (d) {
				       d.style.display = "none";
				  }
			}
			if(document.getElementById(conditionObject.value + "Div") == null) return;
			document.getElementById(conditionObject.value + "Div").style.display = "block";
		}

		//批量停启用
		function changeStatus(status){
			var theForm = parent.listFrame.document.getElementById("accountform");
			var aIds = parent.listFrame.document.getElementsByName('id');
			var temp = 0;
			for(var i = 0; i < aIds.length; i++){
				if(aIds[i].checked){
					if(status == 1 && aIds[i].st== "true"){
						alert(aIds[i].na+v3x.getMessage("edocLang.element_alter_have_enabled"));
						return;
					}else if(status == 0 && aIds[i].st == "false"){
						alert(aIds[i].na+v3x.getMessage("edocLang.element_alter_have_disabled"));
						return;
					}
					temp = temp + 1;
				}
			}

			if(temp == 0){
				alert(v3x.getMessage("CAAccountLong.ca_alter_select_change_status"));
				return;
			}
			theForm.action = "${caacountURL}?method=changeStatus&status=" + status;
			theForm.submit();
			
			//getA8Top().startProc('');
			//myBar.disabled('editBtn');
			//myBar.disabled('enableBtn');
			//myBar.disabled('disableBtn');
			//myBar.disabled('excelBtn');
		}

		function doSearch(){
			var searchObjValue = document.getElementById('condition').value;
			if(searchObjValue==''){
				parent.listFrame.location.href="${caacountURL}?method=listCAAccount";
			}else if(searchObjValue=='name'){
				parent.listFrame.location.href="${caacountURL}?method=listCAAccount" + "&condition="+document.getElementById('condition').value + "&textfield="+encodeURI(document.getElementById('nametextfield').value);
			}else if(searchObjValue=='loginName'){
				parent.listFrame.location.href="${caacountURL}?method=listCAAccount" + "&condition="+document.getElementById('condition').value + "&textfield="+encodeURI(document.getElementById('loginNametextfield').value);
			}else if(searchObjValue=='keyNum'){
				parent.listFrame.location.href="${caacountURL}?method=listCAAccount" + "&condition="+document.getElementById('condition').value + "&textfield="+encodeURI(document.getElementById('keyNumtextfield').value);
			}
		}
	window.onload = function(){
		document.querySelector(".bDiv").style.height=document.querySelector(".bDiv").clientHeight - 40 + "px";
	}
	window.onresize = function(){
		setTimeout(function(){
			document.querySelector(".bDiv").style.height=document.querySelector(".bDiv").clientHeight - 40 + "px";
		},50);
	}
	</script>
	<style>
	.mxtgrid{
		height:100%;
	}
	</style>
</head>
<body >
<table style="position:relative;" height="22" width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22" id="toolbar-top-border" class="">
			<script type="text/javascript">
				var _mode = parent.parent.WebFXMenuBar_mode || 'blue'; //取得HR外围frame中的菜单样式
				var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />",_mode);
				myBar.add(new WebFXMenuButton("add","<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}'/>","create()",[1,1], "",null));
				myBar.add(new WebFXMenuButton("mod","<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}'/>","modify()",[1,2],"", null));
				myBar.add(new WebFXMenuButton("enabled","<fmt:message key="edoc.element.enabled" bundle='${v3xEdocI18N}'/>","changeStatus(1)",[2,3],"",null));
				myBar.add(new WebFXMenuButton("disable","<fmt:message key="edoc.element.disabled" bundle='${v3xEdocI18N}'/>","changeStatus(0)",[2,4],"",null ));
				myBar.add(new WebFXMenuButton("del","<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}'/>","removeCaa()",[1,3],"", null));
				var transmit = new WebFXMenu;
	    		transmit.add(new WebFXMenuItem("", "<fmt:message key="org.button.imp.label" />Excel", "impCAAccount()"));
				//导入模板下载
				transmit.add(new WebFXMenuItem("", "<fmt:message key='org.template.excel.download' />", "download()"));
				transmit.add(new WebFXMenuItem("", "<fmt:message key="org.button.exp.label" />Excel", "expCAAccountToExcel()"));
				myBar.add(new WebFXMenuButton("transmit", "<fmt:message key="org.button.imp.label" />/<fmt:message key="org.button.exp.label" />", null, [1,7], "", transmit));
				document.write(myBar);
		    	document.close();
	    	</script>
	    </td>
	    <td id="grayTd" class="webfx-menu-bar ">
	    	<form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
			<input type="hidden" value="listMember" name="method">
			<input type="hidden" id="textfield4Export" value="${textfield}" name="textfield">
			<div class="div-float-right">
				<div class="div-float">
					<select name="condition" id="condition" onChange="conditionOnChangeHandler(this)" class="condition" style="width: 120px;">
				    	<option value=""><fmt:message key="member.list.find"/></option>
				    	<option value="name" <c:if test="${condition == 'name' }">selected</c:if>><fmt:message key="member.list.find.name"/></option>
					    <option value="loginName" <c:if test="${condition == 'loginName' }">selected</c:if>><fmt:message key="ca.loginName.label" /></option>
					    <option value="keyNum" <c:if test="${condition == 'keyNum' }">selected</c:if>><fmt:message key="ca.keyNum.label" /></option>
				  	</select>
			  	</div>
			  	<div id="nameDiv" class="div-float hidden">
					<input type="text" name="textfield" id="nametextfield" class="textfield-search" <c:if test="${condition == 'name'}"> value="${textfield}" </c:if>  onkeydown="javascript:if(event.keyCode==13) doSearch();">
				</div>
			  	<div id="loginNameDiv" class="div-float hidden">
					<input type="text" name="textfield" id="loginNametextfield" class="textfield-search" <c:if test="${condition == 'loginName'}"> value="${textfield}" </c:if>  onkeydown="javascript:if(event.keyCode==13) doSearch();">
				</div>
			  	<div id="keyNumDiv" class="div-float hidden">
					<input type="text" name="textfield" id="keyNumtextfield" class="textfield-search" <c:if test="${condition == 'keyNum'}"> value="${textfield}" </c:if>  onkeydown="javascript:if(event.keyCode==13) doSearch();">
				</div>
			  	<div id="grayButton" onclick="javascript:doSearch()" class="div-float condition-search-button"></div>
		  	</div>
		  	</form>
		</td>
	</tr>
</table>
<div class="main_div_center">
<div class="right_div_center">
<div class="center_div_center" id="scrollListDiv">
<input type="hidden" value="${condition}" id="condition" name="condition">
<input type="hidden" value="${textfield}" id="textfield" name="textfield">
	<form id="accountform" name="accountform" method="post" >
	<fmt:message key="org.entity.disabled" var="orgDisabled"/>
	<fmt:message key="org.entity.deleted" var="orgDeleted"/>
	<fmt:message key="org.entity.transfered" var="orgTransfered"/>
		<v3x:table htmlId="webCAAccountVolist" data="webCAAccountVolist" var="webCAAccountVo" className="sort ellipsis">
			<c:set var="click" value="editOrViewMember('view' ,'${webCAAccountVo.webV3xOrgMember.v3xOrgMember.id}')"/>
			<c:set var="dbclick" value="editOrViewMember('edit' ,'${webCAAccountVo.webV3xOrgMember.v3xOrgMember.id}')"/>
			<v3x:column width="5%" align="center" label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type="checkbox" name="id" id="${webCAAccountVo.webV3xOrgMember.v3xOrgMember.id}" value="${webCAAccountVo.webV3xOrgMember.v3xOrgMember.id}" isInternal="${webCAAccountVo.webV3xOrgMember.v3xOrgMember.isInternal}" 
				st="${webCAAccountVo.caAccount.caState}" na="${webCAAccountVo.webV3xOrgMember.v3xOrgMember.name}"/>
			</v3x:column>
			<v3x:column width="10%" align="left" label="org.member_form.name.label" type="String"
				value="${webCAAccountVo.webV3xOrgMember.v3xOrgMember.name}" className="cursor-hand sort" 
				alt="${webCAAccountVo.webV3xOrgMember.v3xOrgMember.name}" onClick="${click}" onDblClick="${dbclick }"/>
			<v3x:column width="15%" align="left" label="org.member_form.loginName.label" type="String"
				className="cursor-hand sort" alt="${webCAAccountVo.webV3xOrgMember.v3xOrgMember.loginName}" onClick="${click}" onDblClick="${dbclick }">
				<c:out value='${webCAAccountVo.webV3xOrgMember.v3xOrgMember.loginName}' escapeXml='true'/><c:if test="${webCAAccountVo.webV3xOrgMember.stateName!=''&& webCAAccountVo.webV3xOrgMember.stateName!=null}">&nbsp;<img style="vertical-align:middle;" src="<c:url value='/common/images/ldapbinding.gif' />" alt="<fmt:message key='ldap.user.prompt' bundle='${ldaplocale}'><fmt:param value='${webCAAccountVo.webV3xOrgMember.stateName}'></fmt:param></fmt:message>"/></c:if>
			</v3x:column>
			<v3x:column width="15%" align="left" label="ca.keyNum.label" type="String"
				value="${webCAAccountVo.caAccount.keyNum}" className="cursor-hand sort" 
				alt="${webCAAccountVo.caAccount.keyNum}" onClick="${click}" onDblClick="${dbclick }"/>
			<v3x:column width="10%" align="left" label="level.select.state" className="cursor-hand sort" 
				onClick="${click}" onDblClick="${dbclick}">
				<c:choose>
 				<c:when test="${webCAAccountVo.caAccount.caState}">
 					<fmt:message key="edoc.element.enabled" bundle='${v3xEdocI18N}'/>
 				</c:when>
 				<c:otherwise>
 					<fmt:message key="edoc.element.disabled" bundle='${v3xEdocI18N}'/>
 				</c:otherwise>
 				</c:choose>
 			</v3x:column>
 			<v3x:column width="10%" align="left" label="ca.mustUseCA.label" type="String" className="cursor-hand sort"  
				onClick="${click}" onDblClick="${dbclick }">
				<c:choose>
 				<c:when test="${webCAAccountVo.caAccount.caEnable}">
 					<fmt:message key="org.account_form.isRoot.yes"/>
 				</c:when>
 				<c:otherwise>
 					<fmt:message key="org.account_form.isRoot.no"/>
 				</c:otherwise>
 				</c:choose>
			</v3x:column>
			<v3x:column width="15%" align="left" label="ca.mobile.label" type="String" className="cursor-hand sort"  
				onClick="${click}" onDblClick="${dbclick }">
				<c:choose>
 				<c:when test="${webCAAccountVo.caAccount.mobileEnable}">
 					<fmt:message key="org.account_form.isRoot.yes"/>
 				</c:when>
 				<c:otherwise>
 					<fmt:message key="org.account_form.isRoot.no"/>
 				</c:otherwise>
 				</c:choose>
			</v3x:column>
			<v3x:column width="10%" align="left" label="org.member_form.deptName.label" type="String"
				value="${webCAAccountVo.webV3xOrgMember.departmentName}" className="cursor-hand sort" 
				alt="${webCAAccountVo.webV3xOrgMember.departmentName}" onClick="${click}" onDblClick="${dbclick }"/>
			<v3x:column width="10%" align="left" label="org.member_form.account" type="String"
				value="${webCAAccountVo.webV3xOrgMember.accountName}" className="cursor-hand sort" 
				alt="${webCAAccountVo.webV3xOrgMember.accountName}" onClick="${click}" onDblClick="${dbclick }"/>
		</v3x:table>
	</form>
</div>
</div>
</div>
<div id="elementIds" style="display:none"></div>
<iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>
<script type="text/javascript">
<!--
showDetailPageBaseInfo("detailFrame", "<fmt:message key='ca.account.binding'/>", [3,1], pageQueryMap.get('count'), _("CAAccountLong.ca_options_description"));	
//-->
showCtpLocation('F13_caManager');
</script>
</body>
</html>