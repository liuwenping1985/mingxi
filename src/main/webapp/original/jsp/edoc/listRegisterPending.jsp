<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<%@ include file="edocHeader.jsp" %>
<html:link renderURL="/exchangeEdoc.do" var="exchangeEdoc" />
<c:set var="current_user_id" value="${CurrentUser.id}"/>
<c:set var="current_user_name" value="${CurrentUser.name}"/>
<script type="text/javascript">
var jsEdocType=${edocType};
window.onload = function(){
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
}
function dispSign(id)
{
  parent.detailFrame.window.location='${exchangeEdoc}?method=edit&id='+id+'&modelType=received&from=tobook';
}
function newRegisterEdoc(edocType)
{ 
  var checkObj;
  var id_checkbox = document.getElementsByName("id");
  if (!id_checkbox) {
        return;
  }
    var checkedNum = 0;
    var len = id_checkbox.length;
    for (var i = 0; i < len; i++) {
        if (id_checkbox[i].checked) {            
            checkedNum ++;
            if(checkedNum==1){checkObj=id_checkbox[i];}
        }
        if(checkedNum>1)
        {
          alert(_("edocLang.edoc_alertDontSelectMulti"));
          return;
        }
    }
    if(checkedNum==0)
    {
      alert(_("edocLang.edoc_alertDontSelectMulti"));
      return;
    }
    var url=genericURL+"?method=newEdoc&comm=register&edocType="+edocType+"&exchangeId="+checkObj.value+"&edocId="+checkObj.edocId+"&exchangeOrgId="+checkObj.exchangeOrgId+"&exchangeType="+checkObj.exchangeType;    
    parent.location.href=url;    
}
/**
 * ���˴�Ǽǹ���
 */
function stepBackRegisterEdoc(){
	var theForm = document.getElementsByName("listForm")[0];
    if (!theForm) {
        return false;
    }

    var id_checkbox = document.getElementsByName("id");
    if (!id_checkbox) {
        return true;
    }

    var hasMoreElement = false;
    var len = id_checkbox.length;
    var countChecked = 0;
    var obj;
    for (var i = 0; i < len; i++) {
        if (id_checkbox[i].checked) {
        	obj = id_checkbox[i];
            hasMoreElement = true;
            countChecked++;
        }
    }

    if (!hasMoreElement) {
        alert(v3x.getMessage("edocLang.edoc_alertStepBackItem"));
        return true;
    }
    
    if(countChecked > 1){
    	alert(v3x.getMessage("edocLang.edoc_alertSelectStepBackOnlyOne"));
        return true;
    }
    var summaryId = obj.value;
    var resgisteringEdocId = summaryId; 
	if (window.confirm(v3x.getMessage("edocLang.edoc_confirmRecessionItem"))) {
		var returnValues = v3x.openWindow({
	        url:'exchangeEdoc.do?method=openStepBackDlg4Resgistering&resgisteringEdocId='+resgisteringEdocId,
	        width:"400",
	        height:"300",
	        resizable:"0",
	        scrollbars:"true",
	        dialogType:"modal"
	        });
		if(returnValues!=null && returnValues != undefined){
			if(1==returnValues[0]){
					theForm.action = '${exchangeEdoc}'+'?method=stepBackRecievedEdoc&stepBackToRegisterEdocId='+summaryId+'&stepBackInfo='+encodeURIComponent(returnValues[3]);
					theForm.method = "POST";
					theForm.submit();
				}
			}
	}
}
</script>
<style>
SELECT{
		FONT-SIZE: 10pt; 
		FONT-FAMILY: Times New Roman;
		MARGIN-TOP:1px;
}
</style>
</head>
<body scroll="no" onload="setMenuState('menu_register');">
<table height="100%" width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22">
	    	<script type="text/javascript">
	    	var edocContorller="${detailURL}";
	    	var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
	    	if(v3x.isMSIE){
				myBar.add(new WebFXMenuButton("", "<fmt:message key='${newEdoclabel}'/>", "javascript:newRegisterEdoc('${edocType}')", [4,5], "", null));
	    	}
	    	myBar.add(new WebFXMenuButton("menu_darft", "<fmt:message key='common.toolbar.state.darft.label' bundle='${v3xCommonI18N}'/>", "javascript:jumpState('darft','${edocType}')", [4,6], "", null));
	    	myBar.add(new WebFXMenuButton("menu_sended", "<fmt:message key='common.toolbar.state.sended.label' bundle='${v3xCommonI18N}'/>", "javascript:jumpState('sended','${edocType}')", [4,7], "", null));
	    	myBar.add(new WebFXMenuButton("menu_pending", "<fmt:message key='common.toolbar.state.pending.label' bundle='${v3xCommonI18N}' />", "javascript:jumpState('pending','${edocType}')", [4,8], "", null));
	    	myBar.add(new WebFXMenuButton("menu_done", "<fmt:message key='common.toolbar.state.done.label' bundle='${v3xCommonI18N}' />", "javascript:jumpState('done','${edocType}')", [4,9], "", null));
	    	
	    	myBar.add(new WebFXMenuButton("menu_register", "<fmt:message key='common.toolbar.state.register.label' bundle='${v3xCommonI18N}' />", "javascript:jumpState('waitRegister','${edocType}')", [4,10], "", null));
	    	myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.stepBack.label' bundle='${v3xCommonI18N}' />", "javascript:stepBackRegisterEdoc()", [4,1], "", null));
	    	<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
	    	document.write(myBar.toString());
	    	document.close();
	    	</script>			
		</td>
		<td class="webfx-menu-bar">
		</td>			
	</tr>                              
	<tr>
		<td colspan="2">
		<div class="scrollList">
		<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
<v3x:table data="list" var="bean" htmlId="listTable" showHeader="true" showPager="true" bundle="${exchangeI18N}">
	<v3x:column width="3%" align="center"
		label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
		<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>" edocId="<c:out value="${bean.edocId}"/>" 
			exchangeOrgId="<c:out value="${bean.exchangeOrgId}"/>" exchangeType="<c:out value="${bean.exchangeType}"/>"
			<c:if test="${bean.id==param.id}" >checked</c:if> />
	</v3x:column>
	<v3x:column width="10%" type="String" onClick="dispSign('${bean.id}');" maxLength="12"
		label="exchange.edoc.wordNo" className="cursor-hand sort"  symbol="..." value="${bean.docMark}">
	</v3x:column>
	<c:if test="${bean.isRetreat==0}">
		<v3x:column width="22%" type="String" onClick="dispSign('${bean.id}');"
		label="exchange.edoc.title" className="cursor-hand sort mxtgrid_black" maxLength="30"  symbol="..." value="${bean.subject}" importantLevel="${bean.urgentLevel}">
		</v3x:column>
	</c:if>
	<c:if test="${bean.isRetreat==1}">
		<v3x:column width="22%" type="String" onClick="dispSign('${bean.id}');"
		label="exchange.edoc.title" className="cursor-hand sort" maxLength="30"  symbol="..." importantLevel="${bean.urgentLevel}">
		${bean.subject}(<fmt:message key='edoc.beReturned'/>)
		</v3x:column>
	</c:if>
	<v3x:column width="9%" type="String" onClick="dispSign('${bean.id}');"
		label="exchange.edoc.sendaccount" className="cursor-hand sort" maxLength="15"  symbol="..." value="${bean.sendUnit}">
	</v3x:column>
	<v3x:column width="9%" type="String" onClick="dispSign('${bean.id}');"
		label="exchange.edoc.sendToNames" className="cursor-hand sort" maxLength="15"  symbol="..." value="${bean.sendTo}">
	</v3x:column>
	<v3x:column width="7%" type="String" onClick="dispSign('${bean.id}');"
		label="exchange.edoc.copy" className="cursor-hand sort" maxLength="7"  symbol="..." value="${bean.copies}">
	</v3x:column>
	<v3x:column width="11%" type="String" onClick="dispSign('${bean.id}');"
		label="exchange.edoc.secretlevel" className="cursor-hand sort" maxLength="10"  symbol="..." >
		<v3x:metadataItemLabel metadata="${colMetadata['edoc_secret_level']}" value="${bean.secretLevel}" bundle="${edocI18N}"/>
	</v3x:column>
	<v3x:column width="8%" type="String" onClick="dispSign('${bean.id}');"
		label="exchange.edoc.signingperson" className="cursor-hand sort" maxLength="9"  symbol="..." value="${bean.issuer}">
	</v3x:column>
	<fmt:formatDate value='${bean.recTime}' type='both' dateStyle='full' pattern='yyyy-MM-dd' var="recTime"/>		
	<v3x:column width="10%" type="String" onClick="dispSign('${bean.id}');"
		label="exchange.edoc.receiveddate" className="cursor-hand sort" maxLength="10"  symbol="..." value="${recTime}">
	</v3x:column>
	<v3x:column width="11%" type="String" onClick="dispSign('${bean.id}');"
		label="exchange.edoc.booker" className="cursor-hand sort" maxLength="9"  symbol="..." value="${current_user_name}">		
	</v3x:column>

</v3x:table>	
</form>
		</div></td>
	</tr>		
</table>
<%--<c:if test="${not empty flash}" >
    <c:out value="${flash}" escapeXml="false" />
</c:if>--%>

<script type="text/javascript">
<!--
showDetailPageBaseInfo("detailFrame", "<fmt:message key='edoc.workitem.state.register' />", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_3001"));
//-->
</script>
</body>
</html>