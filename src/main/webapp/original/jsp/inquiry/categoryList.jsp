<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">	
<%@ include file="header.jsp"%>
<%@ include file="../common/INC/noCache.jsp" %>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>
<title>category list</title>
<script language="javascript">
<!--

	var	spaceTypeMap = new Properties();
	var delBsMap = new Properties();
	 
	window.onload = function(){
		showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
	}
	
	function newcategory(){
		parent.detailFrame.location.href="${detailURL}?method=categoryDetail&spaceType=${param.spaceType}&spaceId=${param.spaceId}";
	}
	
	function updatecat(){
	  var ElementsObject= document.getElementsByName("id");
	  var id ="";
	  var count = 0;
	  for(var j = 0;j<ElementsObject.length;j++){
	      if (ElementsObject[j].checked == true)
	            {
	                id = ElementsObject[j].value;
	                //alert(id);
	                count++;
	            }
	  }
	  if(count == 0){
	    alert(v3x.getMessage("InquiryLang.inquiry_one_alert"));
	    return false;
	  }
	  if(count > 1){
	    alert(v3x.getMessage("InquiryLang.inquiry_more_one_alert"));
	    return false;   
	  }
	    mainForm.target="detailFrame";
		mainForm.action="${detailURL}?method=categoryMDetail&update=update&id=" + id + "&spaceType=${param.spaceType}&spaceId=${param.spaceId}";
		mainForm.submit();
	}
	
	function delOk(){
		var ids=document.getElementsByName('id');
		var id='';
		for(var i=0;i<ids.length;i++){
			var idCheckBox=ids[i];
			if(idCheckBox.checked){
				id = id + idCheckBox.value + ',';
			}
		}
		if(id==''){
			alert(v3x.getMessage("InquiryLang.inquiry_alertDeleteItem"));
			return;
		}
		mainForm.action="${detailURL}?method=removetype&spaceId=${param.spaceId}&id="+id;
		if(confirm(v3x.getMessage("InquiryLang.inquiry_type_delete_alert"))){
			mainForm.submit();
		}
	}
	
	function modifyRecord(id){
		parent.detailFrame.location="${detailURL}?method=categoryMDetail&update=readOnly&id=" + id + "&spaceId=${param.spaceId}";
		
	}
	function dbModifyRecord(id){
		parent.detailFrame.location="${detailURL}?method=categoryMDetail&update=update&id=" + id + "&spaceId=${param.spaceId}";
	}
	
	function adminSearch(){
	   searchForm.action="${detailURL}?method=admin_query&spaceId=${param.spaceId}";
	   searchForm.submit();
	}
	
	
	//调查排序方法
	function surveyTypeOrder(){
		//parent.detailFrame.location.href="${detailURL}?method=orderSurveyType";
		getA8Top().surveyTypeOrderWin = getA8Top().$.dialog({
	        title:' ',
	        transParams:{'parentWin':window},
	        url: "${detailURL}?method=orderSurveyType&spaceId=${param.spaceId}&spaceType=${param.spaceType}",
	        width: 290,
	        height: 310,
	        isDrag:false
		});
	
	}
	
	function surveyTypeOrderCollBack (returnValue) {
		getA8Top().surveyTypeOrderWin.close();
		if(returnValue != null && returnValue != undefined){
			var theForm = document.forms[0];
			for(var i=0; i<returnValue.length; i++){
			   var element = document.createElement("input");
			   element.setAttribute('type','hidden');
			   element.setAttribute('name','projects');
			   element.setAttribute('value',returnValue[i]);
			   theForm.appendChild(element);
			}
			theForm.action = "${detailURL}?method=saveOrder&spaceId=${param.spaceId}";
			theForm.target = "_self";
			theForm.method = "post";
		    theForm.submit();
		}
	}



-->
</script>
<style>
.webfx-menu-bar-gray{
	background: none;
}
</style>
</head>
<body>
<table height="100%" width="100%" border="0" cellspacing="0"
	cellpadding="0">
	<tr>
		<td height="22" class="webfx-menu-bar-gray" style="height:38px; background:#fafafa;">
<script>
//first
var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", "newcategory()", [1,1],"<fmt:message key='common.toolbar.new.label' bundle='${v3xCommonI18N}' />", null));
myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", "updatecat()", [1,2],"<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />", null));
myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", "delOk()", [1,3], "<fmt:message key='common.toolbar.delete.label' bundle='${v3xCommonI18N}' />", null));

myBar.add(
	new WebFXMenuButton(
	"orderBtn",
	"<fmt:message key='common.toolbar.order.label' bundle='${v3xCommonI18N}' />",
	"surveyTypeOrder();",
	[8,9],
	"",
	null
	)
);

/*
myBar.add(
	new WebFXMenuButton(
		"refBtn", 
		"<fmt:message key='common.toolbar.refresh.label' bundle='${v3xCommonI18N}' />", 
		"parent.location.reload();", 
		"<c:url value='/common/images/toolbar/refresh.gif'/>", 
		"", 
		null
		)
);
*/
document.write(myBar);
</script></td>
	</tr>
	<tr>
		<td colspan="2" style="vertical-align: top;">
		<div class="scrollList">
		<form name="mainForm" method="post">
		<c:set value="0" var="delBsLoop" />
		<v3x:table data="${typelist}" var="con" htmlId="typelist" isChangeTRColor="true" showHeader="true" leastSize="0" subHeight="38">
			<c:set var="auditor" value="${v3x:getMember(con.checker.id)}" />
			<c:set var="onclick" value="modifyRecord('${con.inquirySurveytype.id}')" />
			<c:set var="onDbclick" value="dbModifyRecord('${con.inquirySurveytype.id}')" />
			
			<v3x:column  width="5%" align="center" 
				label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="${con.inquirySurveytype.id}" />
				<script type="text/javascript">
					spaceTypeMap.put('${con.inquirySurveytype.id}','${con.inquirySurveytype.spaceType}');
					<%-- delBsMap.put('${con.inquirySurveytype.id}','${delBsList[delBsLoop]}'); --%>
				</script>
				<c:set var="delBsLoop" value="${delBsLoop+1}" />
			</v3x:column>

			<v3x:column  type="String"  width="20%" label="inquiry.categoryName.label" value="${con.inquirySurveytype.typeName}" 
				 onClick="${onclick}" onDblClick="${onDbclick}" className="cursor-hand sort" alt="${con.inquirySurveytype.typeName}"></v3x:column>
			<v3x:column  type="String" width="20%" label="inquiry.manager.label" onClick="${onclick}" onDblClick="${onDbclick}" className="cursor-hand sort"  value="${v3x:showOrgEntities(con.managers, 'id', 'entityType' , pageContext)}" maxLength="25" alt="${v3x:showOrgEntities(con.managers, 'id', 'entityType' , pageContext)}">
				
			</v3x:column>
			<v3x:column  type="String" width="10%" label="inquiry.audit.whether" onClick="${onclick}" onDblClick="${onDbclick}" className="cursor-hand sort">
					<c:choose>
						<c:when test="${con.inquirySurveytype.censorDesc==0}">
							<fmt:message key="common.true"  bundle="${v3xCommonI18N}" />
						</c:when>
						<c:otherwise>
							<fmt:message key="common.false" bundle="${v3xCommonI18N}" />
						</c:otherwise>
					</c:choose>
			</v3x:column>
			
			<v3x:column  type="String" width="20%" label="inquiry.auditor.label" onClick="${onclick}" onDblClick="${onDbclick}" className="cursor-hand sort" maxLength="42" alt="${v3x:showOrgEntitiesOfIds(con.checker.id, 'Member', pageContext)}">
				<c:choose>
					<c:when test="${!auditor.enabled || auditor.isDeleted}">
						<font color='gray'>${v3x:showOrgEntitiesOfIds(con.checker.id, 'Member', pageContext)}</font>
					</c:when>
					<c:otherwise>
						${v3x:showOrgEntitiesOfIds(con.checker.id, 'Member', pageContext)}
					</c:otherwise>
				</c:choose>
			</v3x:column>
			
			<v3x:column  type="String" width="25%" label="inquiry.categoryDesc.label" value="${con.inquirySurveytype.surveyDesc}" onDblClick="${onDbclick}" onClick="${onclick}" className="cursor-hand sort" maxLength="20" alt="${con.inquirySurveytype.surveyDesc}"></v3x:column>

		</v3x:table></form>
		</div>
		</td>
	</tr>
</table>
<script type="text/javascript">
showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.account.inquiry.set' bundle="${v3xMainI18N}"/>", [2,1], pageQueryMap.get('count'), _("InquiryLang.detail_info_2006"));	
</script>
</body>
</html>