<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="../docHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
<style type="text/css">
.right_div_row2>.center_div_row2 {
 top:40px;
}
</style>
</head>
<script type="text/javascript">
try{
	var isShowLocations = "${isShowLoction}";
	var tohtml= "";
	if (isShowLocations == 'true') {
		tohtml='<span class="nowLocation_content"><a title="'+v3x.getMessage('DocLang.doc_jsp_knowledge') + '">'+
	    v3x.getMessage('DocLang.doc_jsp_knowledge')+'</a>'+
	    ' > '+
	    '<a href=###" onclick="showMenu(\''+v3x.baseURL +'/doc/knowledgeController.do?method=personalKnowledgeCenterIndex'+'\')"'+
	    ' title="'+ v3x.getMessage('DocLang.doc_jsp_personal_knowledge_center') + '">'+
	    v3x.getMessage('DocLang.doc_jsp_personal_knowledge_center')+'</a>'+
	    ' > '+
	    '<a title="'+v3x.getMessage('DocLang.doc_jsp_subscription_management') + '"'+'href=###" onclick="showMenu(\''+window.location.href+'\')">'+
	    v3x.getMessage('DocLang.doc_jsp_subscription_management')+'</a></span>';
	} else {
		tohtml='<span class="nowLocation_content"><a title="'+v3x.getMessage('DocLang.doc_manage_title') + '">'+
    	v3x.getMessage('DocLang.doc_manage_title')+'</a>'+' > '+
        '<a title="'+v3x.getMessage('DocLang.doc_jsp_subscription_management') + '"'+'href=###" onclick="showMenu(\''+window.location.href+'\')">'+
        v3x.getMessage('DocLang.doc_jsp_subscription_management')+'</a></span>';
	}
	showCtpLocation("",{html:tohtml});
}catch(e){
}


	function doClick(alertIds){
		//parent.bottom.location.href="${detailURL}?method=docAlertAdminView&alertIds="+alertIds;
	}
	
	function modify(){
		var chkid = self.document.getElementsByName("id");
		var count = 0;
		var theId = '';

		for(var i = 0; i < chkid.length; i++){
			if(chkid[i].checked){
				count += 1;
				theId = chkid[i].value;
				if(count > 1) {
					alert(v3x.getMessage("DocLang.doc_alert_admin_select_one_alert"))
					return;
				}				

			}
		}
		if(count == 0) {
			alert(v3x.getMessage("DocLang.doc_alert_admin_select_alert"))
			return;
		}

        if(aclExist(theId)=='false'){
			alert(v3x.getMessage('DocLang.doc_source_doc_no_exist'));
			
		}else{
	     var url = "${detailURL}?method=docAlertAdminEdit&alertIds="+theId; 
  	     getA8Top().docAclWin = getA8Top().$.dialog({
              title:"<fmt:message key='doc.jsp.alert.admin.edit.lable'/> ",
              transParams:{'parentWin':window},
              url: url,
              width: 400,
              height: 450,
              isDrag:false
          });
		}
		
	}
	
	function modifyCollBack () {
		getA8Top().docAclWin.close();
		location.href ="${detailURL}?method=docAlertAdminList";
	}
	
	function doDoubleClick(alertIds, personalAlert){
		if(personalAlert == 'false'){
			alert(v3x.getMessage("DocLang.doc__alert_admin_no_edit_alert"));
			doClick(alertIds);
			return;
		}else{	
			if(aclExist(alertIds)=='false'){
			alert(v3x.getMessage('DocLang.doc_source_doc_no_exist'));
			
		     }else{
		       var url ="${detailURL}?method=docAlertAdminEdit&alertIds="+alertIds;
		       getA8Top().docAclWin = getA8Top().$.dialog({
	                title:"<fmt:message key='doc.jsp.alert.admin.edit.lable'/> ",
	                transParams:{'parentWin':window},
	                url: url,
	                width: 400,
	                height: 450,
	                isDrag:false
	            });
		     }
		 location.href ="${detailURL}?method=docAlertAdminList";
		}
	}
	
	function cancelAlert() {
		var aurl = "${detailURL}?method=docAlertCancel&ids=";
	
		var chkid = self.document.getElementsByName("id");
		var count = 0;
		var ids = "";
		for(var i = 0; i < chkid.length; i++){
			if(chkid[i].checked){
				count += 1;
				ids += "," + chkid[i].value;
			}
		}
		if(count == 0) {
			alert(v3x.getMessage("DocLang.doc_alert_admin_cancel_select_alert"))
			return;
		}
		aurl += ids.substring(1, ids.length);
		//alert(aurl)
		theForm1.action = aurl;	
		theForm1.submit();
		
		//for(var i = 0; i < chkid.length; i++){
			//if(chkid[i].checked){
		//		chkid[i].parentNode.parentNode.removeNode(true);
		//		i--;
		//	}
		//}
		
		//parent.bottom.location.href = '<c:url value="/common/detail.jsp" />';
	}
</script>
<body scroll="no" style="font-weight:normal;">
<div class="main_div_row2">
  <div class="right_div_row2">
<div class="top_div_row2">
<form id="theForm1" name="theForm1" method="post" target="empty">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" class="bg_color">
	<tr>
		<td height="22">
        <script type="text/javascript">
        	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
        	myBar.add(new WebFXMenuButton("modify", "<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />" , "modify()", [1,2], "", null));
        	myBar.add(new WebFXMenuButton("cancel", "<fmt:message key='doc.jsp.alert.admin.cancel' />" , "cancelAlert()", [4,1], "", null));
        	
        	document.write(myBar);
        </script>
		</td>
	</tr>

	</table>
    </form>
    </div>
        <div class="center_div_row2" id="scrollListDiv" >
		<form id="theForm" name="theForm" method="post" target="empty">
  	<v3x:table data="${davos}" var="vo" isChangeTRColor="true" showHeader="true" htmlId="docAlertAdminTable">
    
			<v3x:column width="5%" align="center"
				label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="${vo.alertIds}" 
					${v3x:outConditionExpression(vo.personalAlert=='false', 'disabled', '')} />
			</v3x:column>

			<v3x:column width="35%" type="String" className="cursor-hand sort"
				align="left" label="${v3x:_(pageContext, 'doc.metadata.def.name')}" onClick="doClick('${vo.alertIds}')"  onDblClick="doDoubleClick('${vo.alertIds}', '${vo.personalAlert}')" alt="${v3x:toHTML(v3x:_(pageContext, vo.docResource.frName))}">
			<img src="${pageContext.request.contextPath}/apps_res/doc/images/docIcon/${vo.icon}" width="16" height="16" />
				&nbsp;${v3x:toHTML(v3x:getLimitLengthString(v3x:_(pageContext, vo.docResource.frName), 50,'...'))}
			</v3x:column>

			<v3x:column width="15%" type="String" align="left" onClick="doClick('${vo.alertIds}')" onDblClick="doDoubleClick('${vo.alertIds}', '${vo.personalAlert}')" label="${v3x:_(pageContext, 'doc.metadata.def.type')}"
				value="${v3x:_(pageContext, vo.type)}"></v3x:column>
				
			<v3x:column width="15%" type="String" align="left" onClick="doClick('${vo.alertIds}')" onDblClick="doDoubleClick('${vo.alertIds}', '${vo.personalAlert}')" label="${v3x:_(pageContext, 'doc.jsp.alert.admin.content')}"
				value="${vo.alertType}"></v3x:column>	

			<v3x:column width="10%" type="String" align="left" onClick="doClick('${vo.alertIds}')" onDblClick="doDoubleClick('${vo.alertIds}', '${vo.personalAlert}')" label="${v3x:_(pageContext, 'doc.jsp.alert.admin.alertCreater')}"
				value="${vo.alertCreater}"></v3x:column>

			<v3x:column width="20%" type="Date" align="left" onClick="doClick('${vo.alertIds}')" onDblClick="doDoubleClick('${vo.alertIds}', '${vo.personalAlert}')" label="${v3x:_(pageContext, 'doc.jsp.alert.admin.alerttime')}">
				<fmt:formatDate value="${vo.alertCreateTime}"	pattern="${datetimePattern}" />
			</v3x:column>
			

			</v3x:table>
            </form>
</div>
	
	</div></div>
<iframe id="empty" name="empty" marginheight="0" marginwidth="0" width="0" height="0"></iframe>
</body>
</html>