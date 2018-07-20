<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%@include file="../edocHeader.jsp" %>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />"/>    
<script type="text/javascript">
<!--
	var canEditEdocElements="true";"${canEditEdocElements}";
	var myBar = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />","gray");

	myBar.add(
		new WebFXMenuButton(
			"editBtn", 
			"<fmt:message key='common.toolbar.update.label' bundle='${v3xCommonI18N}' />",  
			"editElement('undefined','edit');", 
			[1,2],
			"", 
			null
			)
	);
	//屏蔽启用和停用按钮
	// myBar.add(
	//	new WebFXMenuButton(
	//		"enableBtn", 
	//		"<fmt:message key='edoc.element.enabled' />", 
	//		"changeStatus('1');", 
	//		[2,3],
	//		"", 
	//		null
	//		)
	//);
	//myBar.add(
	//	new WebFXMenuButton(
	//		"disableBtn", 
	//		"<fmt:message key='edoc.element.disabled' />", 
	//		"changeStatus('0');", 
	//		[2,4],
	//		"", 
	//		null
	//		)
	//);
	
	myBar.add(new WebFXMenuButton("excelBtn", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "exportElement();", [2,6], "", null));	
	
	//myBar.add(new WebFXMenuButton("print", "<fmt:message key='common.toolbar.print.label' bundle='${v3xCommonI18N}' />", "elementPrint();", "<c:url value='/common/images/toolbar/print.gif'/>", "", null));	
	
	function exportElement(){
		var exportValue = '';
		if('' != "${v3x:escapeJavascript(param.condition)}"){
			exportValue = "${ctp:escapeJavascript(param.condition)}";
		}
		var conditionObj = document.getElementById(exportValue+'Div');
		var conditionValue = '';
		var old_textfield =document.getElementById("old_textfield").value;
		if('' != old_textfield){
			conditionValue = old_textfield;
		}
		var statusSelectValue = '';
		if('' != "${v3x:escapeJavascript(param.statusSelect)}"){
			statusSelectValue = "${v3x:escapeJavascript(param.statusSelect)}";
		}
		
		document.getElementById("mainForm").action =  "<c:url value='/edocElement.do'/>?method=exportElementToExcel&exportValue="+exportValue+"&conditionValue="+conditionValue+"&statusSelectValue="+statusSelectValue;
		document.getElementById("mainForm").target = "empty";
		document.getElementById("mainForm").method = "post";
		document.getElementById("mainForm").submit();
	}
	

	function elementPrint() {		
		var printEdocBody = "";
		var edocBody = document.getElementById("print").innerHTML;
		//alert(edocBody);
		var edocBodyFrag = new PrintFragment(printEdocBody, edocBody);
		var cssList = new ArrayList();
	
		var pl = new ArrayList();
		pl.add(edocBodyFrag);
		printList(pl,cssList);
	}

	function editElement(id, flag) {
		if(navigator.userAgent.indexOf('MSIE') < 0){
			alert("请用IE浏览器打开");
			return false;
		}
	    var editMode=flag;
	    if(canEditEdocElements!="false"){}
	    else{editMode="view";}
		var aUrl = "${edocElement}?method=editPage&flag=" + editMode;
		var checkid = id;
		if (checkid == "undefined") {
			checkid = document.getElementById("mainForm").id;
			var len = checkid.length;
			var checked = false;
			if (isNaN(len)) {
				if (!checkid.checked) {
					alert(v3x.getMessage("edocLang.element_alter_not_select"));
					return ;
				}	
				else {
					var aId = document.getElementById("mainForm").id.value;
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
					alert(v3x.getMessage("edocLang.element_alter_not_select"));
					return ;
				}
				else if (j > 1) {
					alert(v3x.getMessage("edocLang.element_alter_select_one"));
					return ;
				}
			}
		}
		else {
			aUrl += "&id=" + id;
		}
		parent.detailFrame.location = aUrl;
	}

	function changeStatus(status) {
		var aIds = document.getElementsByName("id");
		var temp = 0;
		var _elementIds = document.getElementById("elementIds");
		for(var i = 0; i < aIds.length; i++) {
			if(aIds[i].checked) {

				if(status == 1 && status == aIds[i].st){
					alert(aIds[i].na+v3x.getMessage("edocLang.element_alter_have_enabled"));
					return;
				}else if(status == 0 && status == aIds[i].st){
					alert(aIds[i].na+v3x.getMessage("edocLang.element_alter_have_disabled"));
					return;
				}
				
				_elementIds.innerHTML += "<input type=hidden name=ids value=" + aIds[i].value + ">";
				temp = temp + 1;
			}
		}
		if(temp == 0) {
			alert(v3x.getMessage("edocLang.element_alter_select_change_status"));
			return ;
		}
		document.getElementById("mainForm").target = "empty";
		document.getElementById("mainForm").method = "post";
		document.getElementById("mainForm").action = "${edocElement}?method=changeStatus&status=" + status;
		document.getElementById("mainForm").submit();
		
		if(getA8Top()!=null && typeof(getA8Top().showLocation)!="undefined") {
		      getA8Top().startProc('');
		    }
		myBar.disabled('editBtn');
		myBar.disabled('enableBtn');
		myBar.disabled('disableBtn');
		myBar.disabled('excelBtn');
		
	}

	function showByStatus(){
		window.document.searchForm.submit();
	}

	function showConditionInput(conditionObject) {
	    var options = conditionObject.options;
		    for (var i = 0; i < options.length; i++) {
		        var d = document.getElementById(options[i].value + "Div");
		        //alert(d);
		        if (d) {
		            d.style.display = "none";
		        }
		  }
		if(document.getElementById(conditionObject.value + "Div") == null) return;
	    document.getElementById(conditionObject.value + "Div").style.display = "block";
	}
//-->
</script>
<link rel="stylesheet" type="text/css" href="<c:url value="/common/css/layout.css${v3x:resSuffix()}" />">
</head>
<body scroll="no" id="print" name="print" class="page-color">

<div class="main_div_row2">
<div class="right_div_row2">

<div class="top_div_row2 webfx-menu-bar" style="border-top:0;">
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td>
		<script type="text/javascript">
			document.write(myBar);	
			document.close();
		</script>
	</td>

	<td class="webfx-menu-bar">
		<form action="" name="searchForm" id="searchForm" method="get"
			onkeypress="doSearchEnter()" onsubmit="return false"
			style="margin: 0px">
			<input type="hidden" value="<c:out value='${param.method}' />" name="method">
			<input type="hidden" value="" name="selectedValue" />
			<div class="div-float-right">
				<div class="div-float">
					<select name="condition"
						onChange="showConditionInput(this)" id="condition" class="condition" style="font-family: sans-serif">
						<option value=""><fmt:message key="common.option.selectCondition.text" bundle="${v3xCommonI18N}" /></option>
						<option value="elementName" <c:if test="${condition == 'elementName'}">selected</c:if>><fmt:message key="edoc.element.elementName" /></option>
						<%-- <option value="elementStatus" <c:if test="${condition == 'elementStatus'}">selected</c:if>><fmt:message key="edoc.element.elementStatus"/></option> --%>
						<option value="elementfieldName" <c:if test="${condition == 'elementfieldName'}">selected</c:if>><fmt:message key="edoc.element.elementfieldName" /></option>
					</select>
				</div>
				<div id="elementNameDiv" class="div-float hidden">
					<input type="text" name="textfield" style="height:14px;" class="textfield">
				</div>
				<div id="elementStatusDiv" class="div-float hidden">
					<div class="div-float">
						<select name="statusSelect" id="statusSelect"
							 class="condition" style="font-family: sans-serif">
							<option value="1" <c:if test="${statusSelect == '1'}">selected</c:if>><fmt:message key="edoc.element.enabled" /></option>
							<option value="0" <c:if test="${statusSelect == '0'}">selected</c:if>><fmt:message key="edoc.element.disabled" /></option>
						</select>
					</div>
				</div>
				<div id="elementfieldNameDiv" class="div-float hidden">
					<input type="text" name="textfield" style="height:14px;" class="textfield">
				</div>			
				<div onclick="javascript:doSearch()" class="condition-search-button" style="font-size:12px"></div>
			</div>
		</form>
	</td>
</tr>
</table>
</div>

<div class="center_div_row2" id="scrollList" style="overflow:hidden;">
	<form name="mainForm" id="mainForm">
		<input type="hidden" name="old_textfield" value="${v3x:toHTML(param.textfield)}" id="old_textfield"/>
		<v3x:table data="list" var="bean" htmlId="listTable" showHeader="true" showPager="true" subHeight="30">
			<c:if test="${bean.isSystem}">
				<fmt:message key="${bean.name}" var="name"/>
			</c:if>
			<c:if test="${!bean.isSystem}">
				<c:set value="${bean.name}" var="name" />
			</c:if>
			<v3x:column width="5%" align="center"
				label="<input type='checkbox' onclick='selectAll(this, \"id\")'/>">
				<input type='checkbox' name='id' value="<c:out value="${bean.elementId}"/>" st="<c:out value="${bean.status}" />" na="<c:out value="${name}" />" >
			</v3x:column>
			<v3x:column width="20%" type="String" onClick="editElement('${bean.elementId}','view');" onDblClick="editElement('${bean.elementId}','edit');" label="edoc.element.elementName" className="cursor-hand sort mxtgrid_black" value="${name }" alt="${name }" maxLength="20">
		
			</v3x:column>
			<v3x:column width="25%" type="String" onClick="editElement('${bean.elementId}','view');" onDblClick="editElement('${bean.elementId}','edit');" label="edoc.element.elementfieldName" className="cursor-hand sort">
				${bean.fieldName}
			</v3x:column>
			<v3x:column width="25%" type="String" onClick="editElement('${bean.elementId}','view');" onDblClick="editElement('${bean.elementId}','edit');" label="edoc.element.elementType" className="cursor-hand sort">
				<c:choose>
					<c:when test="${bean.type==0}">
					<fmt:message key="edoc.element.string" />
					</c:when>
					<c:when test="${bean.type==1}">
					<fmt:message key="edoc.element.text" />
					</c:when>
					<c:when test="${bean.type==2}">
					<fmt:message key="edoc.element.integer" />
					</c:when>
					<c:when test="${bean.type==3}">
					<fmt:message key="edoc.element.decimal" />
					</c:when>
					<c:when test="${bean.type==4}">
					<fmt:message key="edoc.element.date" />
					</c:when>
					<c:when test="${bean.type==5}">
					<fmt:message key="edoc.element.list" />
					</c:when>
					<c:when test="${bean.type==6}">
					<fmt:message key="edoc.element.comment" />
					</c:when>
					<c:when test="${bean.type==7}">
					<fmt:message key="edoc.element.img" />
					</c:when>
				</c:choose>
			</v3x:column>
			<v3x:column width="25%" type="String" onClick="editElement('${bean.elementId}','view');" onDblClick="editElement('${bean.elementId}','edit');" label="edoc.element.elementIsSystem" className="cursor-hand sort">
				<c:choose>				
					<c:when test="${bean.isSystem}">
						<fmt:message key="edoc.element.systemType" />
					</c:when>
					<c:otherwise>
						<fmt:message key="edoc.element.userType" />
					</c:otherwise>
					</c:choose>
			</v3x:column>
<%-- 			<v3x:column width="17%" type="String" onClick="editElement('${bean.elementId}','element');" onDblClick="editElement('${bean.elementId}','edit');" label="edoc.element.elementStatus" className="cursor-hand sort">
				<c:choose>
					<c:when test="${bean.status==0}">
					<fmt:message key="edoc.element.disabled" />
					</c:when>
					<c:when test="${bean.status==1}">
					<fmt:message key="edoc.element.enabled" />
					</c:when>
				</c:choose>
			</v3x:column> --%>
		</v3x:table>
		<div id="elementIds" style="display:none"></div>
	</form>
</div>
</div>
</div>

<script type="text/javascript">
<!--
	showDetailPageBaseInfo("detailFrame", "<fmt:message key='menu.edoc.property.setup' bundle="${v3xMainI18N}"/>", [1,2], pageQueryMap.get('count'), _("edocLang.detail_info_4005"));	
	showCondition("${param.condition}", "<v3x:out value='${param.textfield}' escapeJavaScript='true' />", "<v3x:out value='${param.textfield1}' escapeJavaScript='true' />");
//-->
</script>
</body>
</html>
<iframe name="temp_iframe" id="temp_iframe" style="display:none" frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
<iframe name="empty" id="empty"  style="display:none"frameborder="0" height="0" width="0" scrolling="no" marginheight="0" marginwidth="0"></iframe>
