<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="edocHeader.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><fmt:message key="systemswitch.title.lable"/></title>
<html:link renderURL='/edocOpenController.do' var="edocOpenController" />

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

</head>
<script type="text/javascript">
//是否是单位公文管理员
 var isAccountAdmin = ${v3x:isRole("AccountEdocAdmin", v3x:currentUser())};
function confirmthisform(){
	var form = document.all("submitform");
	form.action = "${edocOpenController}?method=saveEdocOpenSet";
	form.submit();
}
function defaultform(){
	var form = document.all("submitform");
	form.action = "${edocOpenController}?method=defaultEdocOpenSet";
	form.submit();
}
var mainURL = "<html:link renderURL='/main.do'/>";
function cancelthisform(){
 top.contentFrame.mainFrame.location.href = mainURL + "?method=showSystemNavigation";
}
<c:if test="${operateResult}">
alert(v3x.getMessage('edocLang.operateOk'));
</c:if>
</script>
<body>
<form name="submitform" method="post">
<table width="100%" height="100%" align="center" class="" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td align="center" valign="top">
		<div class="scrollList">
			<table width="50%" height="100%" align="center" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td valign="middle">
						<fieldset><legend><fmt:message key="menu.edocCreateAcc.label"/></legend>
						<table width="100%" cellpadding="4" cellspacing="6" border=0>
						<c:if test="${v3x:hasPlugin('edoc')}">
						<tr>
						<td width="65px"><fmt:message key="menu.edocSendNew.label"/></td>
						<td><textarea id="edocSendCreatesName" rows="5" class="new-column cursor-hand" name="edocSendCreatesName" readonly style="width:100%" onclick ="openSelectDepartWin();">${v3x:showOrgEntitiesOfTypeAndId(edocSendCreates,pageContext)}</textarea></td>
						</tr>
						<tr>
						<td><fmt:message key="menu.edocRecNew.label"/></td>
						<td><textarea id="edocRecCreatesName" rows="5" class="new-column cursor-hand" name="edocRecCreatesName" readonly style="width:100%" onclick ="openSelectDepartWin();">${v3x:showOrgEntitiesOfTypeAndId(edocRecCreates,pageContext)}</textarea></td>
						</tr>
						<tr>
						<td><fmt:message key="menu.edocRecDistributeNew.label"/></td>
						<td><textarea id="edocRecDistributeCreatesName" rows="5" class="new-column cursor-hand" name="edocRecDistributeCreatesName" readonly style="width:100%" onclick ="openSelectDepartWin();">${v3x:showOrgEntitiesOfTypeAndId(edocRecDistributeCreates, pageContext)}</textarea></td>
						</tr>
						<tr>
						<td><fmt:message key="menu.edocArchiveModifyNew.label"/></td>
						<td><textarea id="edocArchiveModifyCreatesName" rows="5" class="new-column cursor-hand" name="edocArchiveModifyCreatesName" readonly style="width:100%" onclick ="openSelectDepartWin();">${v3x:showOrgEntitiesOfTypeAndId(edocArchiveModifyCreates, pageContext)}</textarea></td>
						</tr>
						</c:if>
						<tr>
						<td><fmt:message key="menu.edocSignNew.label"/></td>
						<td><textarea id="edocSignCreatesName" rows="5" class="new-column cursor-hand" name="edocSignCreatesName" readonly style="width:100%" onclick ="openSelectDepartWin();">${v3x:showOrgEntitiesOfTypeAndId(edocSignCreates,pageContext)}</textarea></td>
						</tr>
						</table>
						</fieldset>	
					</td>
				</tr>
			</table>
		</div>
	</td>
  </tr>  
  <tr>
	    <td height="30" class="bg-advance-bottom"  align="center">
	  	<input name="Input3" type="button" class="button-default_emphasize" value="<fmt:message key="common.button.ok.label" bundle='${v3xCommonI18N}' />" onclick="saveEdocacc()">&nbsp;
	    <input name="Input2" type="button"  class="button-default-2" value="<fmt:message key="systemswitch.cancel.lable" bundle="${v3xMainI18N}"/>" onclick="parent.location.reload(true);">&nbsp;   
	  </td>
  </tr>
</table>
<v3x:selectPeople id="edocSendAcc" panels="Department,Post,Level" minSize="0" selectType="Account,Department,Member,Post,Level,Team" departmentId="${sessionScope['com.seeyon.current_user'].departmentId}" jsFunction="setEdocCreateFields(elements)" viewPage=""  showAllAccount="false" />

<input type="hidden" name="edocSendCreates" id="edocSendCreates" value="${edocSendCreates}">
<input type="hidden" name="edocRecCreates" id="edocRecCreates" value="${edocRecCreates}">
<input type="hidden" name="edocSignCreates" id="edocSignCreates" value="${edocSignCreates}">
<input type="hidden" name="edocRecDistributeCreates" id="edocRecDistributeCreates" value="${edocRecDistributeCreates}">
<input type="hidden" name="edocArchiveModifyCreates" id="edocArchiveModifyCreates" value="${edocArchiveModifyCreates}">
</form>
<div class="hidden">
<iframe name="tempIframe" id="tempIframe"></iframe>
</div>
<script language="javascript">
var recUnitObj;
var selPerElements =new Properties();
var exclude_sendTo = new Array();
var exclude_copyTo = new Array();
var exclude_reportTo = new Array();
var exclude_sendTo2 = new Array();
var exclude_copyTo2 = new Array();
var exclude_reportTo2 = new Array();

function openSelectDepartWin()
{
  recUnitObj=window.event.srcElement;
  
  var inputIdObj;
  var inputName=recUnitObj.name.substr(0,recUnitObj.name.length-4);
  
  elements_edocSendAcc=selPerElements.get(inputName,"");
  
  selectPeopleFun_edocSendAcc();
}

function setEdocCreateFields(elements)
{  
  recUnitObj.value=getNamesString(elements);
  var inputIdObj;
  var inputName=recUnitObj.name.substr(0,recUnitObj.name.length-4);
  selPerElements.put(inputName,elements);
  //alert(inputName);
  inputIdObj=document.getElementById(inputName);
  
  if(inputIdObj!=null){inputIdObj.value=getIdsString(elements);}  
}

function saveEdocacc()
{
	var theForm=window.submitform;
	theForm.action = "${edocOpenController}?method=saveEdocSendSet";
	theForm.target="tempIframe";
	theForm.submit();
}

onlyLoginAccount_edocSendAcc=true;
hiddenPostOfDepartment_edocSendAcc=true;

selPerElements.put("edocSendCreates",parseElements("${v3x:parseElementsOfTypeAndId(edocSendCreates)}"));
selPerElements.put("edocRecCreates",parseElements("${v3x:parseElementsOfTypeAndId(edocRecCreates)}"));
selPerElements.put("edocSignCreates",parseElements("${v3x:parseElementsOfTypeAndId(edocSignCreates)}"));
selPerElements.put("edocRecDistributeCreates", parseElements("${v3x:parseElementsOfTypeAndId(edocRecDistributeCreates)}"));
selPerElements.put("edocArchiveModifyCreates", parseElements("${v3x:parseElementsOfTypeAndId(edocArchiveModifyCreates)}"));
</script>

</body>
</html>
