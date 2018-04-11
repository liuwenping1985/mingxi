<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@include file="caaccountHeader.jsp"%>
<!-- 所在位置 -->
<script type="text/javascript">
	   getA8Top().showLocation(null, "<fmt:message key='ca.menu.manage' />", "<fmt:message key='ca.account.binding' />");
	   showCtpLocation('F13_caManager');
</script>
<script type="text/javascript" charset="UTF-8" src="<c:url value="/common/js/src/Set.js${v3x:resSuffix()}" />"></script>
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
	</script>
</head>
<body onload="">
<table height="100%" width="100%" border="0" cellspacing="0" cellpadding="0">
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
				myBar.add(new WebFXMenuButton("","<fmt:message key='org.button.exp.label' />Excel","expCAAccountToExcel()",[2,8],"", null));
				myBar.add(new WebFXMenuButton("","<fmt:message key='org.template.excel.download' />","download()",[1,9],"", null));
				myBar.add(new WebFXMenuButton("","<fmt:message key='org.button.imp.label' />Excel","impCAAccount()",[1,7],"", null));
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
<iframe width="0" height="0" name="exportIFrame" id="exportIFrame"></iframe>
</body>
</html>