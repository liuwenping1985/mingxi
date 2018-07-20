<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>
<html>
<head>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
</head>
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
	<td>
		<script type="text/javascript">
			var myBar1 = new WebFXMenuBar("<c:out value='${pageContext.request.contextPath}' />");
			
			myBar1.add(new WebFXMenuButton("setNewPassWrod", "<fmt:message key='system.password.protecd'/>", "setNewPassWrod()", [9,9]));
			if(v3x.getBrowserFlag('hideMenu')){
				myBar1.add(new WebFXMenuButton("export", "<fmt:message key='common.toolbar.exportExcel.label' bundle='${v3xCommonI18N}' />", "exportExcel()", [2,6]));
			}
			
			document.write(myBar1);
			document.close();
		</script>
	</td>
	<td><input type="hidden" id="isSearch" value="" /></td>
	<td><input type="hidden" id="exFromTime" value"" /><input type="hidden" id="exToTime" value="" /></td>
	<td class="webfx-menu-bar" width="50%" height="100%">
		<c:if test="${v3x:getBrowserFlagByRequest('HideOperation', pageContext.request)}">
			<form action="" name="searchForm" id="searchForm" style="margin: 0px">
				<div class="div-float-right" >
					<div id="subjectDiv" class="div-float" >
						<fmt:message key='hr.salary.search.mounth.label' bundle='${v3xHRI18N}' />:
					</div>
					<div id="subjectDiv" class="div-float">
						<input type="text" inputName="<fmt:message key="plan.body.fromtime.label"/>" style="cursor:pointer" validate="notNull" name="fromTime" id="fromTime" onclick="selectDates('fromTime'); return false;" readonly>-
					    <input type="text" inputName="<fmt:message key="plan.body.endtime.label"/>" style="cursor:pointer" validate="notNull" name="toTime" id="toTime" onclick="selectDates('toTime'); return false;" readonly>
					</div>
					<div id="searchId" onClick="javascript:searchSalary()" class="div-float condition-search-button"></div>
				</div>
			</form>
		</c:if>
	</td>
  </tr>
</table>
</body>
</html>