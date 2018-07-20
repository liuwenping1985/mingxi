<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../exchangeHeader.jsp" %>
<head>
<title></title>
	
<script type="text/javascript">
<!--	
		function deleteItem() {
		  var checkedIds = document.getElementsByName('id');

		  var len = checkedIds.length;
		  
		  var str = "";
		  
		  for(var i = 0; i < len; i++) {
		  		var checkedId = checkedIds[i];
				
				if(checkedId && checkedId.checked && checkedId.parentNode.parentNode.tagName == "TD"){			
					str += checkedId.value;
					str +=","
				}
			}
			
		 //-- justify is any id has been chose.
		  
		  if(str==null || str==""){
			alert(v3x.getMessage("ExchangeLang.outter_unit_alter_not_select"));
		  	return false;
		  }

		 //-- justification end.	
		 if(window.confirm(v3x.getMessage("ExchangeLang.outter_unit_alter_delete_confirm"))) {
			str = str.substring(0,str.length-1);
			
			document.location.href='${exchangeEdoc}?method=deleteExchangeAccount&id='+str;
		 }
		}	

	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");
	
	myBar.add(
		new WebFXMenuButton(
			"newBtn", 
			"<fmt:message key='common.toolbar.new.label' bundle="${v3xCommonI18N}" />", 
			"parent.detailFrame.location.href='${exchangeEdoc}?method=addExchangeAccountPage'", 
			[1,1], 
			"", 
			null
			)
	);

	myBar.add(
		new WebFXMenuButton(
			"editBtn", 
			"<fmt:message key='common.toolbar.update.label' bundle="${v3xCommonI18N}" />", 
			"editItem('undefined','edit');", 
			[1,2], 
			"", 
			null
			)
	);

	myBar.add(
		new WebFXMenuButton(
			"delBtn", 
			"<fmt:message key='common.button.delete.label' bundle="${v3xCommonI18N}" />",
			"deleteItem();",
			[1,3], 
			"", 
			null
			)
	);	
	function editItem(id,flag){
		var aUrl = "${exchangeEdoc}?method=editExchangeAccountPage&flag=" + flag;		
		var checkid = id;
		if (checkid == "undefined") {
			checkid = document.getElementsByName("id");
			var len = checkid.length;
			var checked = false;
			if (isNaN(len)) {
				if (!checkid.checked) {
					alert(v3x.getMessage("ExchangeLang.outter_unit_alter_not_select"));
					return ;
				}	
				else {
					var aId = mainForm.id.value;
					aUrl += "&id=" + aId;
				}
			}
			else {
				var j = 0;
				for (i = 0; i <len; i++) {
					if (checkid[i].checked == true) {
						aUrl += "&id=" + checkid[i].value;
						j++;
					}
				}
				if (j == 0) {
					alert(v3x.getMessage("ExchangeLang.outter_unit_alter_not_select"));
					return ;
				}
				else if (j > 1){
					alert(v3x.getMessage("ExchangeLang.outter_unit_alter_select_one"));
					return ;
				}
			}
		}
		else {
			aUrl += "&id=" + id;
		}
		parent.detailFrame.location = aUrl;
	}

//-->	
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"> 
</head>
<body class="page_color">
<div class="main_div_row2">
<div class="right_div_row2">

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td height="22" class="webfx-menu-bar-gray">
			<script type="text/javascript">
			<v3x:showThirdMenus rootBarName="myBar" addinMenus="${AddinMenus}"/>
				document.write(myBar);	
				document.close();
			</script>
		</td>
		<td>
		<form action="" name="searchForm" id="searchForm" method="get" onsubmit="return false" style="margin: 0px">
		<input type="hidden" value="<c:out value='${param.method}' />" name="method">
		<div class="div-float-right">
				<div class="div-float">
					<select id="condition" name="condition" onChange="showNextSpecialCondition(this)" class="condition" style="width:90px">
				    	<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
				    	<option value="unitName"><fmt:message key="edoc.form.name" bundle="${edocI18N}" /></option>
				    </select>
				</div>
				<div id="unitNameDiv" class="div-float hidden"><input type="text" id="textfield" style="height:15px;" name="textfield" class="textfield"></div>
				<div onclick="javascript:doSearch()" class="condition-search-button"></div>
		</div>		  
		</form>
		</td> 
	</tr>
</table>

<div class="center_div_row2" id="scrollListDiv">
	<form name="listForm" id="listForm" method="get" onsubmit="return false" style="margin: 0px">
	<v3x:table data="list" var="bean" htmlId="listTable" showHeader="true" showPager="true">
		<v3x:column width="5%" align="center" label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
		<input type='checkbox' name='id' value="<c:out value="${bean.id}"/>"/>
		</v3x:column>
		<v3x:column width="30%" type="String" onClick="editItem('${bean.id}','view');" onDblClick="editItem('${bean.id}','edit');" label="common.name.label" className="cursor-hand sort" symbol="..." value="${bean.name}" maxLength="42">
		</v3x:column>
		<v3x:column width="64%" type="String" onClick="editItem('${bean.id}','view');" onDblClick="editItem('${bean.id}','edit');" label="common.description.label" className="cursor-hand sort" maxLength="90" symbol="..." value="${bean.description}">
		</v3x:column>
	</v3x:table>
	</form>
</div><!-- center_div_row2 -->
</div><!-- right_div_row2 -->
</div><!-- main_div_row2 -->

<script type="text/javascript">
showCondition("${v3x:escapeJavascript(param.condition)}", "<v3x:out value='${v3x:escapeJavascript(param.textfield)}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
initIpadScroll("scrollListDiv",550,870);
showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.edoc.exchangeAccount' bundle="${v3xMainI18N}"/>", [1,2], pageQueryMap.get('count'), _("ExchangeLang.detail_info_6001"));	
</script>
</body>
</html>