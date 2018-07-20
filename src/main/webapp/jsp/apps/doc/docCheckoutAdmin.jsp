<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <!DOCTYPE html>
<%@ include file="docHeader.jsp"%>
<%@ include file="../../common/INC/noCache.jsp"%>
<html>
<head>
<title></title>
<script>
	function checkin(){
		var listForm = self.document.getElementById("checkoutAdminForm");
		//listForm.target = "theCheckoutIframe";
		var aurl = "${detailURL}?method=docCheckin&docLibId=${param.docLibId}";
	
		var chkid = self.document.getElementsByName("id");
		var count = 0;
		for(var i = 0; i < chkid.length; i++){
			if(chkid[i].checked){
				count += 1;
				break;
			}
		}
		if(count == 0) {
			alert(v3x.getMessage("DocLang.doc_check_in_select_alert"))
			return;
		}
		
			listForm.action = aurl;	
		listForm.submit();
		
		//for(var i = 0; i < chkid.length; i++){
		//	if(chkid[i].checked){
		//		chkid[i].parentNode.parentNode.removeNode(true);
		//		i--;
		//	}
		//}
		
		//parent.close();

		//alert(parent.coframe)
		//document.location.href = jsURL + "?method=docCheckoutView&docLibId=${param.docLibId}";
		//parent.location.reload(true);
	}
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
${v3x:skin()}
</head>
<body scroll="no">
	<div class="main_div_row2">
	 <form name="checkoutAdminForm" id="checkoutAdminForm"  method="post" target="_self">
  		<div class="right_div_row2">
  		 
    		<div class="top_div_row2">
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td height="22">
				
				  <input type="hidden" value="${param.docLibId}" name="docLibId">
				    <script type="text/javascript">
						var myBar = new WebFXMenuBar("${pageContext.request.contextPath}");
						myBar.add(new WebFXMenuButton("checkin", "<fmt:message key='doc.jsp.checkout.checkin' />", "checkin()", "<c:url value='/apps_res/doc/images/unlock.gif'/>"));
						myBar.add(new WebFXMenuButton("", "<fmt:message key='common.toolbar.back.label' bundle='${v3xCommonI18N}'/>",  "window.top.close();", "<c:url value='/common/images/toolbar/back.gif'/>"));
						document.write(myBar);
					</script>
					
						</td>
					</tr>
				</table>
			</div>
	
	<div class="center_div_row2" style="overflow:hidden;" id="scrollListDiv" >
		<div id="checkoutAdminDiv">
  		<v3x:table data="${covos}" var="vo" isChangeTRColor="true" showHeader="true" showPager="false" htmlId="checkoutAdminTable">
			<v3x:column width="5%" align="center"
				label="<input type='checkbox' id='allCheckbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="${vo.docResource.id}" />
			</v3x:column>

			<v3x:column width="30%" type="String" className="cursor-hand sort"
				align="left" label="${v3x:_(pageContext, 'doc.metadata.def.name')}" onClick="" alt="${v3x:_(pageContext, vo.docResource.frName)}">
			<img src="${pageContext.request.contextPath}/apps_res/doc/images/docIcon/${vo.icon}" />
				&nbsp;${v3x:getLimitLengthString(v3x:_(pageContext, vo.docResource.frName), 50,'...')}
			</v3x:column>

			<v3x:column width="15%" type="String" align="left" label="${v3x:_(pageContext, 'doc.metadata.def.type')}"
				value="${v3x:_(pageContext, vo.type)}"></v3x:column>
				
			<v3x:column width="20%" type="String" align="left" label="${v3x:_(pageContext, 'doc.jsp.properties.common.path')}"
				value="${v3x:getLimitLengthString(v3x:_(pageContext, vo.path), 32,'...')}" alt="${v3x:_(pageContext, vo.path)}"></v3x:column>

			<v3x:column width="10%" type="String" align="left" label="${v3x:_(pageContext, 'doc.jsp.checkout.user')}"
				value="${vo.checkOutUserName}"></v3x:column>

			<v3x:column width="20%" type="Date" align="left" label="${v3x:_(pageContext, 'doc.jsp.checkout.time')}">
				<fmt:formatDate value="${vo.checkOutTime}"
					pattern="${datetimePattern}" />
			</v3x:column>
			</v3x:table>
		</div>
 </div>
</div> </form></div>
  <iframe id="theCheckoutIframe" name="theCheckoutIframe" frameborder="0" marginheight="0" marginwidth="0" ></iframe>
</body>
</html>